// File: lib/featues/shop/controllers/category_cotroller.dart

import 'package:e_commerce/data/repositories/fake_store_category/i_category_repository.dart'; // Import the interface
import 'package:get/get.dart';
import '../../../common/widgets/loaders/loaders.dart';
// Import the CategoryRepository implementation if needed for Firebase-specific tasks outside the interface
// import '../../../data/repositories/categories/category_repository.dart';
import '../../../data/repositories/product/product_repository_interface.dart'; // Needed for getCategoryProducts
import '../models/category_model.dart';
import '../models/product_model.dart';


class CategoryController extends GetxController{
  // Removed the problematic static instance getter

  final ICategoryRepository _categoryRepository; // Declare the main dependency

  // Add the constructor to inject the dependency
  CategoryController(this._categoryRepository);


  final isLoading = false.obs;

  RxList<CategoryModel> allCategories = <CategoryModel>[].obs;
  RxList<CategoryModel> featuredCategories = <CategoryModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchCategories(); // Initial fetch
  }

  /// -- Load category data
  Future<void> fetchCategories() async{
    try{
      isLoading.value=true;
      print('CategoryController Debug: Starting fetchCategories...');

      // Clear existing lists BEFORE fetching
      allCategories.clear();
      featuredCategories.clear();
      print('CategoryController Debug: Cleared existing category lists.');

      // Use the injected repository instance
      print('CategoryController Debug: Using repository instance: ${_categoryRepository.runtimeType}');

      // Fetch categories
      final categories = await _categoryRepository.getAllCategories();

      // Update the Categories list
      allCategories.assignAll(categories);
      print('CategoryController: Fetched ${allCategories.length} categories.');

      // Filter featured categories
      featuredCategories.assignAll(allCategories.where((category) => category.isFeatured && category.parentId.isEmpty).take(8).toList());
      print('CategoryController: Filtered ${featuredCategories.length} featured categories.');

    }catch (e){
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      print('CategoryController: Error fetching categories: $e');
    }finally{
      isLoading.value=false;
      print('CategoryController: isLoading set to false');
    }
  }

  /// -- Load selected category data
  Future<List<CategoryModel>> getSubCategories(String categoryId) async {
    try{
      // Use the injected repository instance
      print('CategoryController Debug: Using repository instance for subcategories: ${_categoryRepository.runtimeType}');
      final subCategories = await _categoryRepository.getSubCategories(categoryId);
      return subCategories;
    } catch (e){
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      return [];
    }
  }

  /// Get Category or Sub-Category Products
  Future<List<ProductModel>> getCategoryProducts({required String categoryId, int limit = 4}) async {
    try{
      print('CategoryController Debug: getCategoryProducts called for categoryId: $categoryId');
      // This still gets the default IProductRepository, which is fine
      final IProductRepository productRepository = Get.find<IProductRepository>();
      print('CategoryController Debug: Using repository instance for category products: ${productRepository.runtimeType}');

      final products = await productRepository.getProductsForCategory(categoryId);
      print('CategoryController Debug: getCategoryProducts fetched ${products.length} products.');
      return products;
    } catch (e) {
      NLoaders.errorSnackBar(title: 'Oh Snap !', message: e.toString());
      print('CategoryController: Error in getCategoryProducts for category $categoryId: $e');
      return[];
    }
  }
}