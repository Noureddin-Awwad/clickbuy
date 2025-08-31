import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../../../models/product_model.dart';

class ImageUploadController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  final isLoading = true.obs; // Loading state
  final matchingProducts = <ProductModel>[].obs;

  // Step 1: Pick an image from the gallery
  Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) {
        print("⚠️ User canceled image selection or no image was picked.");
        return null;
      }
      print("✅ Image successfully picked from gallery: ${pickedFile.path}");
      return File(pickedFile.path);
    } catch (error) {
      print("❌ Error picking image from gallery: $error");
      return null;
    }
  }

  Future<String?> uploadImage() async {
    try {
      final File? imageFile = await pickImageFromGallery();
      if (imageFile == null) {
        print("⚠️ No image selected for upload.");
        return null;
      }

      print("🖼️ Reading image file for base64 encoding...");
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      print("✅ Image successfully encoded to base64. Length: ${base64Image.length}");
      return base64Image;
    } catch (error) {
      print("❌ Error uploading image: $error");
      return null;
    }
  }

  // Step 3: Process the image with AI (Cloud Function)
  Future<List<Map<String, dynamic>>> processImage(File imageFile) async {
    try {
      // Fetch the base64 image from the upload step
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      print("🚀 Sending request to Cloud Function with base64 image...");
      const cloudFunctionUrl =
          'https://us-central1-clickbuy-e9657.cloudfunctions.net/searchProductsByImage';
      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'imageBase64': base64Image}),
      );

      print("🌐 Received response from Cloud Function. Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Cloud Function response: ${jsonEncode(data)}");

        final List<dynamic> products = data['products'];
        if (products.isEmpty) {
          print("ℹ️ No products found in the Cloud Function response.");
        }
        return products.cast<Map<String, dynamic>>();
      } else {
        print("❌ Cloud Function returned an error. Status Code: ${response.statusCode}, Body: ${response.body}");
        throw Exception('Failed to fetch products: ${response.body}');
      }
    } catch (error) {
      print("❌ Error processing image: $error");
      return [];
    }
  }

  // Step 4: Search for matching products using the Cloud Function
  Future<List<Map<String, dynamic>>> searchProducts() async {
    try {
      // Step 1: Pick an image from the gallery
      final File? imageFile = await pickImageFromGallery();
      if (imageFile == null) {
        print("⚠️ No image selected for product search.");
        throw Exception('No image selected.');
      }

      // Step 2: Process the image with the Cloud Function
      final products = await processImage(imageFile);
      return products;
    } catch (error) {
      print("❌ Error searching products: $error");
      return [];
    }
  }}