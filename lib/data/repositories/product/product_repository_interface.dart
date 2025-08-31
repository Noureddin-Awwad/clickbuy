// File: lib/data/repositories/products/product_repository_interface.dart

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../featues/shop/models/product_model.dart';

abstract class IProductRepository {
  /// Get all products.
  Future<List<ProductModel>> getProducts();

  /// Get a single product by its ID.
  Future<ProductModel?> getProductById(String id);

  /// Get products for a specific category.
  Future<List<ProductModel>> getProductsForCategory(String categoryId);

  Future<List<ProductModel>> getFeaturedProducts();

  Future<List<ProductModel>> getFavouriteProducts(List<String> productIds);

  Future<List<ProductModel>> fetchProductByQuery(Query? query);

  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1});


// Add other methods here that your application needs to fetch product data,
// regardless of the source (Firebase or Fake Store).
// For example:
// Future<List<ProductModel>> getFeaturedProducts();
// Future<List<ProductModel>> searchProducts(String query);
}