import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../models/product_model.dart';

class ResultScreenController extends GetxController {
  final isLoading = true.obs; // Loading state
  final matchingProducts = <ProductModel>[].obs; // List of matching products

  /// Process the image and fetch matching products
  Future<void> processImageAndFetchProducts(File? imageFile) async {
    try {
      isLoading.value = true;

      if (imageFile == null) {
        throw Exception('No image selected.');
      }

      // Encode the image to Base64
      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      // Send the Base64 image to the Cloud Function
      const cloudFunctionUrl =
          'https://us-central1-clickbuy-e9657.cloudfunctions.net/searchProductsByImage';
      final response = await http.post(
        Uri.parse(cloudFunctionUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'imageBase64': base64Image}),
      );

      // Check the response status
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("✅ Cloud Function response: ${jsonEncode(data)}");

        final List<dynamic> rawProducts = data['products'];
        if (rawProducts.isEmpty) {
          print("ℹ️ No products found in the Cloud Function response.");
          return;
        }

        // Parse raw products into ProductModel objects
        final products = rawProducts.map((map) {
          final product = ProductModel.fromCloudFunctionResponse(map);
          print("Parsed ProductModel: ${product.toJson()}");
          return product;
        }).toList();

        // Assign the matched products to the observable list
        matchingProducts.assignAll(products);
      } else {
        print("❌ Cloud Function returned an error. Status Code: ${response.statusCode}, Body: ${response.body}");
        throw Exception('Failed to fetch products: ${response.body}');
      }
    } catch (error) {
      print('❌ Error processing image or fetching products: $error');
      Get.snackbar('Error', 'An error occurred: $error');
    } finally {
      isLoading.value = false;
    }
  }}