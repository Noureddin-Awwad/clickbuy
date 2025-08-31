// File: lib/data/services/fake_store_api/fake_store_api_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class FakeStoreApiService {
  final http.Client _httpClient = http.Client();
  final String _baseUrl = 'https://fakestoreapi.com';

  // --- Product related raw data fetch methods ---
  Future<List<dynamic>> getAllProductsRaw() async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/products'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('FakeStoreApiService: Failed to load raw products: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('FakeStoreApiService: Error fetching raw products: $e');
    }
  }

  Future<Map<String, dynamic>> getProductRawById(String id) async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/products/$id'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        return {}; // Indicate not found by returning an empty map
      } else {
        throw Exception('FakeStoreApiService: Failed to load raw product $id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('FakeStoreApiService: Error fetching raw product $id: $e');
    }
  }

  Future<List<dynamic>> getProductsRawForCategory(String categoryName) async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/products/category/$categoryName'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 404) {
        // print('FakeStoreApiService: Warning: Category "$categoryName" not found, returning empty list.');
        return []; // Indicate category not found by returning an empty list
      }
      else {
        throw Exception('FakeStoreApiService: Failed to load raw products for category $categoryName: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('FakeStoreApiService: Error fetching raw products for category $categoryName: $e');
    }
  }

  // --- Category related raw data fetch methods ---
  Future<List<String>> getAllCategoriesRaw() async {
    try {
      final response = await _httpClient.get(Uri.parse('$_baseUrl/products/categories'));

      if (response.statusCode == 200) {
        List<dynamic> jsonList = json.decode(response.body);
        List<String> categories = jsonList.cast<String>().toList();
        return categories;
      } else {
        throw Exception('FakeStoreApiService: Failed to load raw categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('FakeStoreApiService: Error fetching raw categories: $e');
    }
  }

  // Optional: Add a method to close the http client
  void closeClient() {
    _httpClient.close();
  }
}