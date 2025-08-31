import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/utils/exceptions/firebase_exceptions.dart';
import 'package:e_commerce/utils/exceptions/platform_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../featues/shop/models/product_model.dart';
import '../fake_store_product/fake_store_product_repository.dart';
import 'product_repository_interface.dart'; // Import the interface

// Your existing ProductRepository now implements the interface
class ProductRepository extends GetxController implements IProductRepository {
  static ProductRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  ProductRepository();

  // --- Implementations of IProductRepository Methods ---

  @override
  Future<List<ProductModel>> getProducts() async {
    // You need a method here to fetch *all* products from Firebase.
    // Your `getAllFeaturedProducts` fetches only featured.
    // Let's add a method to fetch all.
    try {
      final snapshot = await _db.collection('Products').get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    } on FirebaseException catch(e){
      throw NFirebaseException(e.code).message;
    } on NPlatformException catch(e){
      throw NPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong';
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    // You don't have a dedicated getProductById method in your shared code.
    // Let's add one.
    try {
      final snapshot = await _db.collection('Products').doc(id).get();
      if (snapshot.exists) {
        return ProductModel.fromSnapshot(snapshot);
      }
      return null; // Product not found
    } on FirebaseException catch(e){
      throw NFirebaseException(e.code).message;
    } on NPlatformException catch(e){
      throw NPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong';
    }
  }


  @override
  Future<List<ProductModel>> getProductsForCategory(String categoryId) async {
    print('ProductRepository (Firebase): getProductsForCategory called with Firebase categoryId: $categoryId');
    try {
      print('ProductRepository (Firebase): Starting getProductsForCategory for categoryId: $categoryId'); // <-- Add this

      // This logic is purely for Firebase Firestore
      // It finds product links in 'ProductCategory' where categoryId matches the input,
      // then fetches the corresponding products from the 'Products' collection.
      QuerySnapshot productCategoryQuery = await _db.collection('ProductCategory').where('categoryId', isEqualTo: categoryId).get();
      print('ProductRepository (Firebase): ProductCategory query results count: ${productCategoryQuery.docs.length}'); // <-- Add this
      List<String> productIds = productCategoryQuery.docs.map((doc) => doc['productId'] as String).toList();

      if (productIds.isEmpty) {
        print('ProductRepository (Firebase): No product links found in ProductCategory for categoryId: $categoryId');
        return []; // No products found in Firebase for this categoryId
      }

      print('ProductRepository (Firebase): Found ${productIds.length} product links. Fetching products from Firebase...');

      final List<ProductModel> categoryProducts = [];
      const firebaseQueryLimit = 10; // Firebase whereIn limit
      List<List<String>> firebaseIdChunks = [];
      // Split productIds into chunks of 10 or less
      for (var i = 0; i < productIds.length; i += firebaseQueryLimit) {
        firebaseIdChunks.add(productIds.sublist(i, i + firebaseQueryLimit > productIds.length ? productIds.length : i + firebaseQueryLimit));
      }

      // Fetch products from Firebase in batches
      for (var chunk in firebaseIdChunks) {
        try {
          print('ProductRepository (Firebase): Fetching batch of Firebase products: $chunk');
          final productQuery = await _db.collection('Products').where(FieldPath.documentId, whereIn: chunk).get();
          final firebaseProducts = productQuery.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();
          categoryProducts.addAll(firebaseProducts);
          print('ProductRepository (Firebase): Fetched ${firebaseProducts.length} products in batch.');
        } on FirebaseException catch(e){
          print('ProductRepository (Firebase): FirebaseException fetching product batch: ${e.code}');
          throw NFirebaseException(e.code).message; // Re-throw Firebase exceptions
        } on PlatformException catch(e){
          print('ProductRepository (Firebase): PlatformException fetching product batch: ${e.code}');
          throw NPlatformException(e.code).message; // Re-throw Platform exceptions
        } catch(e){
          print('ProductRepository (Firebase): Unknown error fetching product batch: $e');
          throw 'Something went wrong fetching product batch: $e'; // Re-throw other exceptions
        }
      }

      print('ProductRepository (Firebase): Successfully fetched ${categoryProducts.length} total Firebase products for categoryId: $categoryId');
      return categoryProducts;

    } on FirebaseException catch(e){
      print('ProductRepository (Firebase): FirebaseException fetching products for category: ${e.code}');
      throw NFirebaseException(e.code).message;
    } on PlatformException catch(e){
      print('ProductRepository (Firebase): PlatformException fetching products for category: ${e.code}');
      throw NPlatformException(e.code).message;
    } catch(e){
      print('ProductRepository (Firebase): Unknown error fetching products for category: $e');
      throw 'Something went wrong fetching products for category: $e';
    }
  }

  // --- Your Existing Firebase-Specific Methods (Keep if needed elsewhere) ---

  /// Get Limited Featured products
  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      print('ProductRepository (Firebase): Starting getFeaturedProducts...'); // <-- Add print
      final snapshot = await _db.collection('Products')
          .where('IsFeatured', isEqualTo: true)
          .limit(4) // Or whatever your limit is for featured
          .get();

      print('ProductRepository (Firebase): Fetched ${snapshot.docs.length} documents for featured products.'); // <-- Add print

      final list = snapshot.docs.map((document) => ProductModel.fromSnapshot(document)).toList();
      print('ProductRepository (Firebase): Converted ${list.length} documents to ProductModel.'); // <-- Add print
      return list;
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: ${e.message}';
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }

  /// Fetch products by a custom query (specific to Firebase Query object)
  @override
  Future<List<ProductModel>> fetchProductByQuery(Query? query) async {
    print('ProductRepository: fetchProductByQuery called with query: $query');
    try {
      if (query == null) {
        print('ProductRepository: Query is null, returning empty list.');
        return [];
      }

      print('ProductRepository: Executing query...');
      final querySnapshot = await query.get();
      print('ProductRepository: Query executed. Found ${querySnapshot.docs.length} documents.');

      final List<ProductModel> productList = querySnapshot.docs.map((doc) => ProductModel.fromQuerySnapshot(doc)).toList();
      print('ProductRepository: Mapped ${productList.length} documents to ProductModel.');
      return productList;
    } on FirebaseException catch(e){
      print('ProductRepository (FirebaseException): Error fetching products: ${e.code} - ${e.message}');
      // Rethrow the exception or handle it appropriately
      throw NFirebaseException(e.code).message; // Or just throw e;
    } on PlatformException catch(e){
      print('ProductRepository (PlatformException): Error fetching products: ${e.code} - ${e.message}');
      // Rethrow the exception or handle it appropriately
      throw NPlatformException(e.code).message; // Or just throw e;
    } catch(e){
      print('ProductRepository (Generic Exception): Error fetching products: $e');
      // Rethrow the exception or handle it appropriately
      throw 'Something went wrong: $e'; // Include the actual error in the message
    }
  }

  /// Get favourite products (based on a list of product IDs)
  @override
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async {
    print('ProductRepository (Firebase): getFavouriteProducts called with IDs: $productIds');
    List<ProductModel> favoriteProducts = [];
    List<String> firebaseProductIds = [];
    List<String> fakeStoreProductIds = [];

    // 1. Separate Firebase and Fake Store IDs
    for (String id in productIds) {
      // Assuming purely numeric IDs are from Fake Store API.
      // Adjust this logic based on how you distinguish IDs.
      if (int.tryParse(id) != null) {
        fakeStoreProductIds.add(id);
      } else {
        firebaseProductIds.add(id);
      }
    }

    print('ProductRepository (Firebase): Firebase IDs: $firebaseProductIds');
    print('ProductRepository (Firebase): Fake Store IDs: $fakeStoreProductIds');

    // 2. Fetch from Firebase
    if (firebaseProductIds.isNotEmpty) {
      try {
        print('ProductRepository (Firebase): Fetching Firebase favorite products...');
        const firebaseQueryLimit = 10;
        List<List<String>> firebaseIdChunks = [];
        for (var i = 0; i < firebaseProductIds.length; i += firebaseQueryLimit) {
          firebaseIdChunks.add(firebaseProductIds.sublist(i, i + firebaseQueryLimit > firebaseProductIds.length ? firebaseProductIds.length : i + firebaseQueryLimit)); // Corrected sublist range
        }

        for (var chunk in firebaseIdChunks) {
          final snapshot = await _db.collection('Products').where(FieldPath.documentId, whereIn: chunk).get();
          final firebaseProducts = snapshot.docs.map((querySnapshot) => ProductModel.fromSnapshot(querySnapshot)).toList();
          favoriteProducts.addAll(firebaseProducts);
        }
        print('ProductRepository (Firebase): Fetched ${favoriteProducts.length} Firebase products.');
      } on FirebaseException catch (e) {
        print('ProductRepository (Firebase): FirebaseException fetching favorites: ${e.code}');
        throw NFirebaseException(e.code).message;
      } on PlatformException catch (e) { // Using PlatformException as in your original code
        print('ProductRepository (Firebase): PlatformException fetching favorites: ${e.code}');
        throw NPlatformException(e.code).message;
      } catch (e) {
        print('ProductRepository (Firebase): Unknown error fetching Firebase favorites: $e');
        throw 'Something went wrong fetching Firebase favorites';
      }
    }

    // 3. Fetch from Fake Store
    if (fakeStoreProductIds.isNotEmpty) {
      print('ProductRepository (Firebase): Fetching Fake Store favorite products...');
      try {
        // Get the FakeStoreProductRepository instance using the correct tag
        // You need the FakeStoreProductRepository concrete type here,
        // but it's bound to the IProductRepository interface with the tag 'fake'.
        // Let's try to find the IProductRepository with tag 'fake' and cast it.
        // This assumes your FakeStoreProductRepository is the *only* concrete type
        // bound to IProductRepository with the tag 'fake'.
        final IProductRepository fakeStoreRepoInterface = Get.find<IProductRepository>(tag: 'fake');

        // Safely cast to the concrete type if you need specific methods not in the interface
        // Or better, ensure getProductById is part of your IProductRepository interface.
        // Assuming getProductById is in the interface:
        // final FakeStoreProductRepository fakeStoreRepo = fakeStoreRepoInterface as FakeStoreProductRepository; // If needed to cast

        // Fetch each fake store product individually (Fake Store API doesn't support batch fetches like Firebase)
        for (String id in fakeStoreProductIds) {
          try {
            print('ProductRepository (Firebase): Fetching Fake Store product with ID: $id');
            // Call getProductById on the *Fake Store* repository instance
            final fakeStoreProduct = await fakeStoreRepoInterface.getProductById(id); // Use the interface instance
            if (fakeStoreProduct != null) {
              favoriteProducts.add(fakeStoreProduct);
              print('ProductRepository (Firebase): Added Fake Store product with ID: $id');
            } else {
              print('ProductRepository (Firebase): Fake Store product with ID $id not found.');
            }
          } catch (e) {
            print('ProductRepository (Firebase): Error fetching Fake Store product with ID $id: $e');
            // Handle errors for individual fake store products (e.g., log, skip)
          }
        }
        print('ProductRepository (Firebase): Finished fetching Fake Store favorite products.');
      } catch (e) {
        // Catching errors from Get.find or the fetch loop
        print('ProductRepository (Firebase): Error accessing FakeStoreProductRepository via tag \'fake\' or during fetch loop: $e');
        throw 'Something went wrong accessing Fake Store favorites repository: $e';
      }
    }

    print('ProductRepository (Firebase): getFavouriteProducts returning ${favoriteProducts.length} total products.');
    // 4. Return the Combined List
    return favoriteProducts;
  }


  Future<List<ProductModel>> getAllFeaturedProducts() async{
    // Your existing implementation...
    try {
      final snapshot = await _db.collection('Products').where('IsFeatured', isEqualTo: true).get();
      return snapshot.docs.map((e) => ProductModel.fromSnapshot(e)).toList();
    }on FirebaseException catch(e){
      throw NFirebaseException(e.code).message;
    }on NPlatformException catch(e){
      throw NPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong';
    }
  }


  /// Get the products for brand
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit =-1}) async{
    // Your existing implementation...
    try {
      final querySnapshot = limit == -1
          ? await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).get()
          : await _db.collection('Products').where('Brand.Id', isEqualTo: brandId).limit(limit).get();

      final product = querySnapshot.docs.map((doc) => ProductModel.fromSnapshot(doc)).toList();

      return product;

    }on FirebaseException catch(e){
      throw NFirebaseException(e.code).message;
    }on NPlatformException catch(e){
      throw NPlatformException(e.code).message;
    } catch(e){
      throw 'Something went wrong';
    }
  }

// Note: Your getProductsForCategory was already a good fit for the interface method.
// I've moved its logic to the @override getProductsByCategory method.
// You can remove the original getProductsForCategory method if it's no longer called directly.


///upload dummy data to the clod Firebase
// Keep this if needed for admin panel or other Firebase-specific tasks
}