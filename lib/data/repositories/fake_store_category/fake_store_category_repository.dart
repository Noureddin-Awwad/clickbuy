// File: lib/data/repositories/fake_store_category/fake_store_category_repository.dart

import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:get/get.dart'; // For dependency injection
import 'package:e_commerce/featues/shop/models/category_model.dart'; // Your CategoryModel


import '../fake_store_api_service/fake_store_api_service.dart';
import 'i_category_repository.dart'; // The API Service

class FakeStoreCategoryRepository implements ICategoryRepository {
  // Get the instance of the FakeStoreApiService injected by GetX
  // This repository depends on the service for making API calls.
  final FakeStoreApiService _fakeStoreApiService = Get.find<FakeStoreApiService>();

  // Optional: Simple cache for categories to avoid repeated API calls within the same session
  List<CategoryModel>? _cachedCategories;
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = const Duration(minutes: 5); // Cache expires after 5 minutes

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    print('FakeStoreCategoryRepository: getAllCategories called');
    try {
      final rawCategories = await _fakeStoreApiService.getAllCategoriesRaw(); // rawCategories is List<String>
      print('FakeStoreCategoryRepository: Fetched raw categories: $rawCategories');

      // Map raw category strings to CategoryModel
      final List<String> fakeStoreFeaturedNames = ['electronics', 'jewelery', "men's clothing", "women's clothing"]; // Decide which are featured for your UI
      final List<CategoryModel> categories = rawCategories.map((categoryName) {
        // Use the helper function to get the image based on the category name
        String categoryImage = _getCategoryImageUrl(categoryName);

        return CategoryModel(
          id: categoryName,
          name: categoryName.capitalizeFirst ?? categoryName,
          image: categoryImage, // Use the image from your helper function
          imageType: ImageSourceType.asset, // Assuming _getCategoryImageUrl provides asset paths
          isFeatured: fakeStoreFeaturedNames.contains(categoryName), // Mark based on the list
          parentId: '',
        );
      }).toList();

      print('FakeStoreCategoryRepository: Successfully mapped ${categories.length} categories.');
      return categories;

    } catch (e) {
      print('FakeStoreCategoryRepository: Error fetching or mapping categories: $e');
      throw 'Failed to fetch Fake Store categories: $e';
    }
  }

  // Helper function to determine an image URL or asset path based on the category name
  String _getCategoryImageUrl(String categoryName) {
    // --- Implement your image logic here ---
    // You can use a placeholder image, or if you have category-specific assets,
    // you can map the category name to an asset path.
    // Example: Using a placeholder
     // Make sure this asset exists!

    // Example: Mapping specific category names to assets (requires more code)
     switch (categoryName.toLowerCase()) {
       case 'electronics': return NImage.electronicsIcon;
       case 'jewelery': return NImage.jeweleryIcon;
       case "men's clothing": return NImage.clothIcon;
       case "women's clothing": return NImage.cosmeticsIcon;
      // Add more cases for other categories
       default: return 'assets/images/placeholders/category_placeholder.png'; // Default placeholder
    }

    // Example: If images were available from the API, you'd parse them in the mapping logic
    // and wouldn't need this helper function for the image URL itself.
  }

  @override
  Future<List<CategoryModel>> getSubCategories(String parentId) async {
    // Fake Store API doesn't have subcategories.
    print('FakeStoreCategoryRepository: getSubCategories called, but Fake Store API does not support subcategories. Returning empty list.');
    return Future.value([]); // Return an empty list
  }

// Implement any other methods defined in ICategoryRepository
// Since Fake Store API is read-only and has a simple category structure,
// methods like createCategory, updateCategory, deleteCategory would likely
// not be supported and you might throw an UnsupportedError or return a Future.error.
}

