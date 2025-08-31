// File: lib/data/repositories/brand/brand_repository_interface.dart

import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart'; // Assuming getProductsForBrand needs ProductModel

abstract class IBrandRepository {
  Future<List<BrandModel>> getAllBrands();
  Future<List<BrandModel>> getFeaturedBrands();
  Future<BrandModel?> getBrandById(String brandId);
  Future<List<BrandModel>> getBrandsForCategory(String categoryId);
  Future<List<ProductModel>> getProductsForBrand({required String brandId, int limit = -1});
}