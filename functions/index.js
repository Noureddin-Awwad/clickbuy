const functions = require('firebase-functions');
const admin = require('firebase-admin');
const vision = require('@google-cloud/vision');
const cors = require('cors')({ origin: true }); // Enable CORS

// --- ⚙️ START OF REQUIRED CONFIGURATION ---
// Initialize Firebase Admin SDK
try {
    admin.initializeApp();
    console.log("Firebase Admin SDK initialized successfully.");
} catch (e) {
    console.error("Error initializing Firebase Admin SDK with default config:", e.message, e.stack);
}

// Initialize Vision API Product Search Client
const visionProductSearchClient = new vision.ProductSearchClient();
const imageAnnotatorClient = new vision.ImageAnnotatorClient(); // For processing image bytes if needed
console.log("Vision API Clients initialized.");

const db = admin.firestore();

// --- CONFIGURATION VALUES (Update these to match your project) ---
const GCP_PROJECT_ID = 'clickbuy-e9657'; // Replace with your Google Cloud Project ID
const GCP_LOCATION = 'us-east1';       // Replace with your Vision API Product Search location
const PRODUCT_SET_ID = 'clickbuy_main_prod_set'; // Replace with your Product Set ID
const FIRESTORE_PRODUCTS_COLLECTION = 'Products'; // Your Firestore collection for products
// --- ⚙️ END OF REQUIRED CONFIGURATION ---

/**
 * HTTP-triggered Cloud Function to search for products using an image.
 * Expects a POST request with a JSON body:
 * {
 *   "imageBase64": "base64_encoded_image_string"
 * }
 * OR
 * {
 *   "imageGcsUri": "gs://your-bucket-name/path/to/image.jpg"
 * }
 */
exports.searchProductsByImage = functions.https.onRequest(async (req, res) => {
    // Handle CORS preflight requests and then actual request
    cors(req, res, async () => {
        if (req.method !== 'POST') {
            return res.status(405).send('Method Not Allowed. Please use POST.');
        }

        console.log("Received request body:", JSON.stringify(req.body).substring(0, 200) + "..."); // Log snippet of body

        const { imageBase64, imageGcsUri } = req.body;

        if (!imageBase64 && !imageGcsUri) {
            console.error("Bad Request: Missing imageBase64 or imageGcsUri in request body.");
            return res.status(400).json({ error: 'Missing imageBase64 or imageGcsUri in request body.' });
        }

        if (imageBase64 && imageGcsUri) {
            console.error("Bad Request: Provide either imageBase64 or imageGcsUri, not both.");
            return res.status(400).json({ error: 'Provide either imageBase64 or imageGcsUri, not both.' });
        }

        let imageSource;
        if (imageBase64) {
            imageSource = { content: imageBase64 };
            console.log("Processing search with imageBase64.");
        } else { // imageGcsUri
            imageSource = { source: { imageUri: imageGcsUri } };
            console.log(`Processing search with imageGcsUri: ${imageGcsUri}`);
        }

        const productSetPath = visionProductSearchClient.productSetPath(
            GCP_PROJECT_ID,
            GCP_LOCATION,
            PRODUCT_SET_ID
        );

        const request = {
            image: imageSource,
            features: [{ type: 'PRODUCT_SEARCH' }],
            imageContext: {
                productSearchParams: {
                    productSet: productSetPath,
                    productCategories: ['general-v1'], // Adjust if you use specific categories
                    // You can add a filter here if needed, e.g., "style=womens"
                },
            },
        };

        try {
            console.log("Sending request to Vision API Product Search...");
            const [response] = await imageAnnotatorClient.batchAnnotateImages({ requests: [request] });
            console.log("Received response from Vision API.");

            if (!response.responses || response.responses.length === 0) {
                console.log("Vision API returned no responses.");
                return res.status(200).json({ products: [] }); // No results found
            }

            const productSearchResults = response.responses[0].productSearchResults;

            if (!productSearchResults || !productSearchResults.results || productSearchResults.results.length === 0) {
                console.log("No product search results found in Vision API response.");
                return res.status(200).json({ products: [] }); // No results found
            }

            console.log(`Found ${productSearchResults.results.length} potential product matches from Vision API.`);

            const visionApiMatches = productSearchResults.results.map(result => ({
                visionProductId: result.product.name.split('/').pop(), // Extract just the product ID
                score: result.score,
                image: result.image, // Reference image that matched
                productDisplayName: result.product.displayName,
                productLabels: result.product.productLabels,
            }));

            // --- Optional: Fetch full product details from Firestore ---
            const productDetailsPromises = visionApiMatches.map(async (match) => {
                // Extract Firestore document ID from Vision Product ID
                const firestoreDocId = match.visionProductId.startsWith('firestore_')
                    ? match.visionProductId.substring('firestore_'.length)
                    : match.visionProductId; // Fallback if not prefixed

                if (!firestoreDocId) {
                    console.warn(`Could not extract Firestore ID from Vision Product ID: ${match.visionProductId}`);
                    return { ...match, firestoreData: null, error: "Invalid Vision Product ID format" };
                }

                try {
                    // Fetch the Firestore document
                    const docRef = db.collection(FIRESTORE_PRODUCTS_COLLECTION).doc(firestoreDocId);
                    const docSnap = await docRef.get();

                    if (docSnap.exists) {
                        console.log(`Fetched Firestore data for ${firestoreDocId}`);
                        return {
                            ...match, // Keep the Vision API match data (score, visionProductId, etc.)
                            firestoreData: docSnap.data(), // Add the full product data from Firestore
                        };
                    } else {
                        console.warn(`Firestore document ${firestoreDocId} not found for Vision match ${match.visionProductId}.`);
                        return {
                            ...match,
                            firestoreData: null,
                            error: `Product details not found in Firestore for ID: ${firestoreDocId}`,
                        };
                    }
                } catch (error) {
                    console.error(`Error fetching Firestore document ${firestoreDocId}:`, error);
                    return {
                        ...match,
                        firestoreData: null,
                        error: `Error fetching product details from Firestore: ${error.message}`,
                    };
                }
            });

            // Wait for all Firestore lookups to complete
            const enrichedProducts = await Promise.all(productDetailsPromises);
            console.log("Successfully enriched products with Firestore data.");
            return res.status(200).json({ products: enrichedProducts });

        } catch (error) {
            console.error('Error processing image search:', error.message, error.stack);

            if (error.code === 7 && error.message.includes('does not have storage.objects.get access')) {
                console.error('Permission error: The Vision API service account may not have "Storage Object Viewer" role on the GCS bucket, or the image GCS URI is incorrect or inaccessible.');
                return res.status(500).json({ error: 'Internal Server Error. Could not access image for search. Check permissions and URI.', details: error.message });
            }

            if (error.code === 5 && error.message.includes('The Product Set is not indexed yet')) {
                console.warn('Product Set not indexed yet. This is normal if recently populated.');
                return res.status(503).json({ error: 'Product set is not indexed yet. Please try again in a few minutes.', details: error.message });
            }

            return res.status(500).json({ error: 'Internal Server Error', details: error.message });
        }
    }); // End of cors wrapper
}); // End of exports.searchProductsByImage function

// You can add more Cloud Functions here if needed, e.g.:
// exports.anotherFunction = functions.https.onRequest((req, res) => { ... });