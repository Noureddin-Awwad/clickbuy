// File: lib/data/repositories/category/category_repository_interface.dart
import 'package:e_commerce/featues/shop/models/category_model.dart'; // Your CategoryModel

abstract class ICategoryRepository {
  Future<List<CategoryModel>> getAllCategories();
  Future<List<CategoryModel>> getSubCategories(String categoryId);

// Add other category-related methods here if needed (e.g., getCategoryById)
}