// File: lib/data/repositories/brand/firebase_brand_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:get/get.dart';

import 'i_brand_repository/i_brand_repository.dart'; // Import the interface

// Make this class implement the interface
class FirebaseBrandRepository implements IBrandRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Implement the methods from IBrandRepository
  @override
  Future<List<BrandModel>> getAllBrands() async {
    // Your existing logic to fetch all brands from Firebase
    try {
      final snapshot = await _db.collection('Brands').get();
      final list = snapshot.docs.map((document) =>
      // Explicitly cast to DocumentSnapshot<Map<String, dynamic>>
      BrandModel.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>)).toList();
      return list;
    } catch (e) {
      // Handle Firebase errors appropriately
      print('Error fetching all brands from Firebase: $e');
      // Throw a specific exception or rethrow
      throw e;
    }
  }

  @override
  Future<List<BrandModel>> getFeaturedBrands() async {
    // Your existing logic to fetch featured brands from Firebase
    try {
      final snapshot = await _db.collection('Brands').where(
          'IsFeatured', isEqualTo: true).get();
      final list = snapshot.docs.map((document) =>
      // Explicitly cast to DocumentSnapshot<Map<String, dynamic>>
      BrandModel.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>)).toList();
      return list;
    } catch (e) {
      // Handle Firebase errors appropriately
      print('Error fetching featured brands from Firebase: $e');
      throw e;
    }
  }

  @override
  Future<BrandModel?> getBrandById(String brandId) async {
    // Your logic to get a specific brand by ID from Firebase
    try {
      final documentSnapshot = await _db
          .collection('Brands')
          .doc(brandId)
          .get();
      // The documentSnapshot from a single doc.get() is usually correctly typed
      // if you initialized Firestore with converters, but explicit casting is safer.
      if (documentSnapshot.exists) {
        return BrandModel.fromSnapshot(documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      } else {
        return null; // Brand not found
      }
    } catch (e) {
      print('Error fetching brand by ID from Firebase: $e');
      throw e;
    }
  }

  @override
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    // Your existing logic for fetching brands related to a category from Firebase
    // This likely involves querying your BrandCategory collection or products.
    // Example (assuming BrandCategory collection):
    try {
      // Query BrandCategory collection to find brand IDs for the given category
      final brandCategorySnapshot = await _db.collection('BrandCategory')
          .where('categoryId', isEqualTo: categoryId)
          .get();

      // Extract brand IDs
      final brandIds = brandCategorySnapshot.docs.map((
          doc) => doc['brandId'] as String).toList();

      if (brandIds.isEmpty) {
        return []; // No brands found for this category
      }

      // Now fetch the BrandModels for these brand IDs
      // Firebase 'whereIn' query has a limit of 10. You might need to split brandIds
      // into chunks if you expect more than 10 brands per category.
      final brandsSnapshot = await _db.collection('Brands').where(
          FieldPath.documentId, whereIn: brandIds).get();

      final brands = brandsSnapshot.docs.map((doc) =>
      // Explicitly cast to DocumentSnapshot<Map<String, dynamic>>
      BrandModel.fromSnapshot(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
      return brands;
    } catch (e) {
      print('Error fetching brands for category from Firebase: $e');
      throw e;
    }
  }

  @override
  Future<List<ProductModel>> getProductsForBrand(
      {required String brandId, int limit = -1}) async {
    // Your existing logic to get products for a brand from Firebase
    // This likely involves querying the Products collection
    try {
      Query productsQuery = _db.collection('Products').where(
          'BrandId', isEqualTo: brandId);

      if (limit > 0) {
        productsQuery = productsQuery.limit(limit);
      }

      final snapshot = await productsQuery.get();
      final products = snapshot.docs
          .map((document) =>
      // Explicitly cast to DocumentSnapshot<Map<String, dynamic>>
      ProductModel.fromSnapshot(document as DocumentSnapshot<Map<String, dynamic>>))
          .toList(); // Assuming ProductModel has fromSnapshot
      return products;
    } catch (e) {
      print('Error fetching products for brand from Firebase: $e');
      throw e;
    }
  }

}