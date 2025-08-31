// File: lib/featues/shop/controllers/brand_controller.dart

// Remove unnecessary imports if you are not using them directly in the controller
// import 'package:e_commerce/common/widgets/loaders/loaders.dart';
// import 'package:e_commerce/data/repositories/product/product_repository.dart';
// import 'package:e_commerce/featues/shop/models/product_model.dart';

import 'package:get/get.dart';

// Import the interface instead of the concrete implementation
import '../../../../data/repositories/i_brand_repository/i_brand_repository.dart';
import '../../../../data/repositories/product/product_repository_interface.dart'; // You'll need ProductRepository for getBrandProducts
import '../../models/brand_model.dart';
import '../../models/product_model.dart'; // Import ProductModel

// Make sure you have your Loaders imported if you use them for error handling
import 'package:e_commerce/common/widgets/loaders/loaders.dart';


class BrandController extends GetxController{
  // Remove the static instance getter if you are injecting via Get.put/Get.find elsewhere
  // static BrandController get instance => Get.find();

  // Inject the interface
  final IBrandRepository brandRepository;
  // Inject the ProductRepository interface as well, as getBrandProducts uses it
  final IProductRepository productRepository;


  // Modify the constructor to accept the injected repositories
  BrandController({required this.brandRepository, required this.productRepository});


  RxBool isLoading = false.obs;
  final RxList<BrandModel> featuredBrands = <BrandModel>[].obs;
  final RxList<BrandModel> allBrands = <BrandModel>[].obs;

  // Remove the direct Get.put here
  // final brandRepository = Get.put(BrandRepository());

  @override
  void onInit() {
    // Fetch all brands and then filter for featured
    fetchAllBrands();
    super.onInit();
  }

  /// - Load All Brands and filter Featured Brands
  Future<void> fetchAllBrands() async {
    try{
      // Show loader while loading Brands
      isLoading.value = true;

      // Use the injected repository
      final brands = await brandRepository.getAllBrands();

      allBrands.assignAll(brands);

      // Filter for featured brands from the fetched list
      featuredBrands.assignAll(allBrands.where((brand) => brand.isFeatured ?? false).take(4).toList()); // Add .toList() here

    }catch (e){
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('Error fetching all brands: $e'); // Add print for debugging
    }finally{
      isLoading.value = false;
    }
  }

  /// - Load Featured Brands Directly (Alternative if getAllBrands is too heavy)
  /// If fetching *all* brands is very inefficient just to get featured ones,
  /// you could keep a separate fetch for featured brands:
  /*
   Future<void> fetchFeaturedBrands() async {
       try{
         isLoading.value = true;
         final brands = await brandRepository.getFeaturedBrands();
         featuredBrands.assignAll(brands);
       }catch(e){
          NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
          print('Error fetching featured brands: $e');
       }finally{
         isLoading.value = false;
       }
   }
   */


  /// -- Get Brands For Category
  Future<List<BrandModel>> getBrandsForCategory(String categoryId) async {
    try {
      // Use the injected repository
      final brands = await brandRepository.getBrandsForCategory(categoryId);
      return brands;
    } catch (e) {
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('Error fetching brands for category: $e'); // Add print for debugging
      return [];
    }
  }

  /// Get Brand Specific Products from your data source
  Future<List<ProductModel>> getBrandProducts({required String brandId, int limit = -1}) async {
    try{
      // Use the injected ProductRepository interface
      final products = await productRepository.getProductsForBrand(brandId : brandId, limit: limit); // Pass limit
      return products;
    }catch(e){
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('Error fetching products for brand: $e'); // Add print for debugging
      return [];
    }
  }

  // Add a method to fetch all brands if you need to call it explicitly later
  Future<void> fetchAllBrandsExplicitly() async {
    await fetchAllBrands(); // Simply call the existing fetchAllBrands method
  }
}