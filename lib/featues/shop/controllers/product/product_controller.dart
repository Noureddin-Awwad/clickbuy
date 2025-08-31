
import 'package:e_commerce/common/widgets/loaders/loaders.dart';
import 'package:get/get.dart';

// Import the IProductRepository interface

import '../../../../data/repositories/product/product_repository_interface.dart';


import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';

class ProductController extends GetxController {
  // Remove the static instance getter

  final IProductRepository _productRepository; // Declare the dependency

  // Add the constructor to inject the dependency
  ProductController(this._productRepository);
  final isLoading = false.obs;
  // Remove the direct repository instance variable here
  // final IProductRepository _productRepository = Get.find<IProductRepository>();

  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  // You might have other product lists here, e.g., RxList<ProductModel> allProducts = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Initial fetch when the controller is created
    fetchFeaturedProducts();
    // If you have other lists that need initial loading:
    // fetchAllProducts();
  }

  // Method to fetch featured products
  Future<void> fetchFeaturedProducts() async{
    try{
      isLoading.value = true;
      print('ProductController Debug: Starting fetchFeaturedProducts...');

      // Clear existing lists BEFORE fetching
      featuredProducts.clear(); // <-- Add this
      print('ProductController Debug: Cleared existing featured products list.');

      // Simply get the default repository binding
      final IProductRepository productRepository = Get.find<IProductRepository>();
      print('ProductController Debug: Using repository instance: ${productRepository.runtimeType}');

      // Fetch products
      final products = await productRepository.getFeaturedProducts();

      // Assign Products
      featuredProducts.assignAll(products);
      print('ProductController: Fetched ${featuredProducts.length} featured products.');

    }catch (e){
      NLoaders.errorSnackBar(title:'Oh Snap',message: 'Error fetching featured products: $e');
      print('ProductController: Error fetching featured products: $e');
    }finally{
      isLoading.value = false;
      print('ProductController: isLoading set to false');
    }
  }

  // fetchAllProducts would also need clearing if you use it to display a list somewhere
  Future<List<ProductModel>> fetchAllProducts() async{
    try{
      final IProductRepository productRepository = Get.find<IProductRepository>();
      print('ProductController Debug: Using repository instance for all products: ${productRepository.runtimeType}');
      final products = await productRepository.getProducts();
      print('ProductController Debug: fetchAllProducts fetched ${products.length} products.');
      return products;
    }catch (e){
      NLoaders.errorSnackBar(title:'Oh Snap',message: 'Error fetching all products: $e');
      print('ProductController: Error fetching all products: $e');
      return [];
    }
  }

  Future<List<ProductModel>> fetchProductsForCategory(String categoryId) async {
    try {
      print('ProductController Debug: fetchProductsForCategory called for categoryId: $categoryId'); // <-- Keep this print
      final IProductRepository productRepository = Get.find<IProductRepository>(); // <-- Simplified
      print('ProductController Debug: Using repository instance for specific category products: ${productRepository.runtimeType}'); // <-- Add print to verify instance type
      final products = await productRepository.getProductsForCategory(categoryId);
      print('ProductController Debug: fetchProductsForCategory fetched ${products.length} products.'); // <-- Add print for product count
      return products;
    } catch (e) {
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: 'Error fetching products for category $categoryId: $e');
      print('ProductController: Error fetching products for category $categoryId: $e'); // Add logging
      return [];
    }
  }

  // The following methods (getProductTypeEnum, getProductPrice,
  // calculateSalePercentage, getProductStock) do not directly interact
  // with the repository, so they do not need changes related to Get.find().
  // Keep them as they are.

  // In getProductTypeEnum:
  ProductType getProductTypeEnum(String? typeString) {
    // ... existing logic ...
    if (typeString == null) {
      return ProductType.single;
    }
    switch (typeString.toLowerCase()) {
      case 'single':
        return ProductType.single;
      case 'variable':
        return ProductType.variable;
      default:
        return ProductType.single; // Returning default
    }
  }

  // In getProductPrice:
  String getProductPrice(ProductModel product){
    // ... existing logic ...
    double smallestPrice = double.infinity;
    double largestPrice = 0.0;

    final productType = getProductTypeEnum(product.productType); // Call the conversion function

    switch (productType) {
      case ProductType.single:
        double price = (product.salePrice ?? 0.0) > 0 ? (product.salePrice ?? 0.0) : (product.price ?? 0.0);
        return price.toStringAsFixed(2);

      case ProductType.variable:
        if (product.productVariations != null && product.productVariations!.isNotEmpty) {
          // Logic to find smallest and largest price from variations
          for (var variation in product.productVariations!) {
            double price = (variation.salePrice ?? 0.0) > 0 ? (variation.salePrice ?? 0.0) : (variation.price ?? 0.0);
            if (price < smallestPrice) smallestPrice = price;
            if (price > largestPrice) largestPrice = price;
          }
          if (smallestPrice.isInfinite) { // Handle case with no valid prices in variations
            return 'Price Unavailable';
          } else if (smallestPrice == largestPrice) {
            return smallestPrice.toStringAsFixed(2);
          } else {
            return '${smallestPrice.toStringAsFixed(2)} - ${largestPrice.toStringAsFixed(2)}';
          }
        } else {
          print('Warning: Variable product ${product.id} has no variations.');
          return 'Price Unavailable';
        }

      default:
        print('Warning: Unknown product type for Product ID: ${product.id}, Type: ${product.productType}');
        double price = (product.salePrice ?? 0.0) > 0 ? (product.salePrice ?? 0.0) : (product.price ?? 0.0);
        return price.toStringAsFixed(2);
    }
  }


  /// -- Calculate Discount Percentage
  String? calculateSalePercentage(double originalPrice, double? salePrice){
    // ... existing logic ...
    if(salePrice == null || salePrice <= 0.0) return null;
    if(originalPrice <= 0.0) return null;

    double discountPercentage = ((originalPrice - salePrice) / originalPrice) * 100;
    return discountPercentage.toStringAsFixed(0);
  }

  /// -- Check Product Stock
  String getProductStock(int stock){
    // ... existing logic ...
    return stock > 0 ? 'In Stock' : 'Out of Stock';
  }
}