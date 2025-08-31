// File: lib/data/repositories/brand/fake_store_brand_repository.dart

import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:get/get.dart';

import '../fake_store_api_service/fake_store_api_service.dart';
import '../i_brand_repository/i_brand_repository.dart';

class FakeStoreBrandRepository implements IBrandRepository {
  final FakeStoreApiService _fakeStoreApiService = FakeStoreApiService(); // Assuming you have this service

  // Placeholder static brands
  final List<BrandModel> _placeholderBrands = [
    BrandModel(id: '1', name: 'Fake Brand A', image: 'assets/logos/fake_logo_a.png', isFeatured: true, productsCount: 10),
    BrandModel(id: '2', name: 'Fake Brand B', image: 'assets/logos/fake_logo_b.png', isFeatured: true, productsCount: 15),
    BrandModel(id: '3', name: 'Fake Brand C', image: 'assets/logos/fake_logo_c.png', isFeatured: false, productsCount: 8),
    BrandModel(id: '4', name: 'Fake Brand D', image: 'assets/logos/fake_logo_d.png', isFeatured: false, productsCount: 20),
  ];

  @override
  Future<List<BrandModel>> getAllBrands() async {
    print('FakeStoreBrandRepository: getAllBrands called, returning placeholder brands.');
    // Return the static placeholder brands
    return Future.value(_placeholderBrands);
  }

  @override
  Future<List<BrandModel>> getFeaturedBrands() async {
    print('FakeStoreBrandRepository: getFeaturedBrands called, returning featured placeholder brands.');
    // Return featured placeholder brands
    return Future.value(_placeholderBrands.where((brand) => brand.isFeatured ?? false).toList());
  }

  @override
  Future<BrandModel?> getBrandById(String brandId) async {
    print('FakeStoreBrandRepository: getBrandById called with ID: $brandId');
    // Find a brand by ID from the placeholder list
    return Future.value(_placeholderBrands.firstWhereOrNull((brand) => brand.id == brandId));
  }

  @override
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    print('FakeStoreBrandRepository: getBrandsForCategory called with category ID: $categoryId');
    // This is difficult with Fake Store API.
    // Option 1: Return all placeholder brands (simple but not accurate)
    // return Future.value(_placeholderBrands);
    // Option 2: Return an empty list (more accurate given API limitations)
    return Future.value([]);
    // Option 3: Map categories to specific brands (requires predefined mapping)
    // e.g., if categoryId == 'electronics', return Brand A and Brand B
  }

  @override
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1}) async {
    print('FakeStoreBrandRepository: getProductsForBrand called with brand ID: $brandId');
    // This is challenging as Fake Store API products don't have brand IDs.
    // You need a strategy to simulate products for a brand.
    // Option 1: Return a subset of ALL products based on some criteria (e.g., title contains brand name)
    // Option 2: Return a fixed set of products for each placeholder brand ID
    // Option 3: Fetch ALL products and filter them - potentially inefficient.

    // Let's go with a simple approach for demonstration:
    // Fetch all products and arbitrarily assign some to placeholder brands based on index or category.
    // This is a workaround, not a true representation.
    try {
      final allProductsRaw = await _fakeStoreApiService.getAllProductsRaw();
      final allProducts = allProductsRaw.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();

      // Simple arbitrary filtering based on brandId for demonstration:
      List<ProductModel> brandProducts = [];
      if (brandId == '1') {
        // Assign first few products to Brand A
        brandProducts = allProducts.take(5).toList();
      } else if (brandId == '2') {
        // Assign next few products to Brand B
        brandProducts = allProducts.skip(5).take(5).toList();
      }
      // ... add more conditions for other placeholder brand IDs

      if (limit > 0) {
        brandProducts = brandProducts.take(limit).toList();
      }

      print('FakeStoreBrandRepository: getProductsForBrand returning ${brandProducts.length} products for brand $brandId.');
      return brandProducts;

    } catch (e) {
      print('Error fetching products for brand from Fake Store API: $e');
      throw e; // Re-throw the exception
    }
  }
}