// File: lib/data/repositories/fake_store_product/fake_store_product_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart'; // For dependency injection
import 'package:e_commerce/featues/shop/models/product_model.dart'; // Your ProductModel
import 'package:e_commerce/data/repositories/product/product_repository_interface.dart'; // Product interface


import '../fake_store_api_service/fake_store_api_service.dart'; // The new API Service

class FakeStoreProductRepository implements IProductRepository {
  // Get the instance of the FakeStoreApiService injected by GetX
  // This repository depends on the service for making API calls.
  final FakeStoreApiService _fakeStoreApiService = Get.find<FakeStoreApiService>();

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      // Call the service to get the raw product data (List<dynamic> JSON)
      final List<dynamic> jsonList = await _fakeStoreApiService.getAllProductsRaw();

      // Map the raw JSON data to your ProductModel
      return jsonList.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      // Handle exceptions from the API service or mapping
      // You might want more specific error handling or logging here
      print('Error fetching or mapping Fake Store products in repository: $e');
      throw e; // Re-throw the exception for the caller to handle
    }
  }

  @override
  Future<ProductModel?> getProductById(String id) async {
    try {
      // Call the service to get the raw product data (Map<String, dynamic> JSON)
      final Map<String, dynamic> jsonResponse = await _fakeStoreApiService.getProductRawById(id);

      if (jsonResponse.isEmpty) {
        return null; // Indicates 404 or not found from the service
      }

      // Map the raw JSON data to your ProductModel
      return ProductModel.fromJson(jsonResponse);
    } catch (e) {
      print('Error fetching or mapping Fake Store product $id in repository: $e');
      throw e;
    }
  }


  @override
  Future<List<ProductModel>> getProductsForCategory(String categoryId) async {
    print('FakeStoreProductRepository: getProductsForCategory called with Fake Store categoryId: $categoryId');
    try {
      // Call the raw fetch method from the API service
      // Pass the categoryId directly, assuming it's the category name (string)
      final rawProductsData = await _fakeStoreApiService.getProductsRawForCategory(categoryId);

      // Map the raw List<dynamic> JSON data to a List<ProductModel>
      final List<ProductModel> products = rawProductsData.map((item) {
        // Assuming your ProductModel has a factory constructor or a method
        // to create an instance from a JSON map (Map<String, dynamic>)
        return ProductModel.fromJson(item as Map<String, dynamic>); // Adjust if your mapping method is different
      }).toList();

      print('FakeStoreProductRepository: Successfully fetched and mapped ${products.length} products for categoryId: $categoryId');
      return products;

    } catch (e) {
      print('FakeStoreProductRepository: Error fetching products for category $categoryId: $e');
      // Re-throw a specific exception or a generic one as needed
      throw 'Failed to fetch Fake Store products for category $categoryId: $e';
    }
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      // Fake Store API doesn't have a dedicated "featured" endpoint.
      // We'll use the service to get all products and take a limited number,
      // similar to your previous implementation.
      final List<dynamic> jsonList = await _fakeStoreApiService.getAllProductsRaw();

      // Limit the number of products returned for "featured"
      final limitedJsonList = jsonList.take(8).toList(); // Take the first 8 products

      // Map the raw JSON data to your ProductModel
      return limitedJsonList.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error fetching or mapping Fake Store featured products in repository: $e');
      throw e;
    }
  }

  // Implement the getFavouriteProducts method required by IProductRepository
  @override
  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds) async {
    print('FakeStoreProductRepository: getFavouriteProducts called with IDs: $productIds');
    if (productIds.isEmpty) {
      print('FakeStoreProductRepository: No product IDs provided for favorites.');
      return []; // Return empty list if no IDs are requested
    }

    try {
      print('FakeStoreProductRepository: Fetching all products to filter for favorites...');
      // Fetch ALL products from the Fake Store API
      final List<ProductModel> allProducts = await getProducts(); // Reuse the existing getProducts method

      print('FakeStoreProductRepository: Fetched ${allProducts.length} total products.');

      // Filter the list to include only products whose IDs are in the productIds list
      final List<ProductModel> favoriteProducts = allProducts.where((product) {
        // The Fake Store API uses numeric IDs. Ensure your productIds are strings.
        // Check if the product's ID is in the list of requested favorite IDs.
        // Convert product.id to String if it's not already.
        return productIds.contains(product.id);
      }).toList();

      print('FakeStoreProductRepository: Found ${favoriteProducts.length} favorite products matching IDs.');
      return favoriteProducts;

    } catch (e) {
      print('FakeStoreProductRepository: Error fetching or filtering favorite products: $e');
      // Handle exceptions (e.g., from getProducts() or filtering)
      throw 'Failed to fetch Fake Store favorite products: $e';
    }
  }
  @override
  Future<List<ProductModel>> fetchProductByQuery(Query? query) async {
    // Implement fetchProductByQuery for Fake Store API
    print('FakeStoreProductRepository: fetchProductByQuery called.');

    // The Fake Store API does not support complex queries like Firebase.
    // Depending on your needs, you could try to interpret simple queries,
    // but it's more likely this method is not directly applicable.

    // Option A: Throw UnsupportedError (Recommended)
    throw UnsupportedError('Fake Store API does not support fetching products with Firebase Firestore Query objects.');

    // Option B: Attempt to simulate basic filtering if possible (less ideal)
    // If the query is very simple (e.g., filtering by category, which you already have a method for),
    // you might try to handle it. However, this is complex and prone to errors.
    // Example (highly simplified and likely insufficient for real queries):
    // if (query != null && query is YourCustomFakeStoreQueryRepresentation) {
    //   // Attempt to use the FakeStoreApiService with the query information
    //   // This would require defining a way to represent queries for Fake Store.
    //   // This approach adds significant complexity and might not be feasible.
    //   // print('Attempting to interpret query for Fake Store...');
    //   // final rawProductsData = await _fakeStoreApiService.fetchProductsBasedOnQuery(query);
    //   // return rawProductsData.map((item) => ProductModel.fromJson(item as Map<String, dynamic>)).toList();
    // } else {
    //   // If no query or an unsupported query type, perhaps return all products
    //   // or throw an error depending on the expected behavior.
    //   // print('No query or unsupported query type provided. Returning all products (or throwing).');
    //   // return getProducts(); // Or throw UnsupportedError
    // }

    // Since the Fake Store API doesn't align with Firebase queries,
    // throwing UnsupportedError is the cleanest way to fulfill the interface contract
    // while being honest about the data source's capabilities.
  }

  @override
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1}) async {
    // Implement fetching products for a brand from the Fake Store API (using your workaround)
    print('FakeStoreProductRepository: getProductsForBrand called with brand ID: $brandId');
    // This is challenging as Fake Store API products don't have brand IDs.
    // You need a strategy to simulate products for a brand.
    // Example: Using the same simple arbitrary assignment as in the FakeStoreBrandRepository
    try {
      final allProductsRaw = await _fakeStoreApiService.getAllProductsRaw();
      final allProducts = allProductsRaw.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();

      List<ProductModel> brandProducts = [];
      if (brandId == '1') {
        brandProducts = allProducts.take(5).toList();
      } else if (brandId == '2') {
        brandProducts = allProducts.skip(5).take(5).toList();
      }
      // ... add more conditions for other placeholder brand IDs

      if (limit > 0) {
        brandProducts = brandProducts.take(limit).toList();
      }

      print('FakeStoreProductRepository: getProductsForBrand returning ${brandProducts.length} products for brand $brandId.');
      return brandProducts;

    } catch (e) {
      print('Error fetching products for brand from Fake Store API: $e');
      throw e;
    }
  }
}


// Implement any other methods defined in IProductRepository
// For example, if you have methods like `createProduct`, `updateProduct`, `deleteProduct`, etc.,
// you would add their implementations here, using the FakeStoreApiService to interact with the API.
// Since Fake Store API is read-only, these would likely throw UnsupportedError.
