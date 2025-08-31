// File: lib/featues/shop/controllers/product/all_products_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../../data/repositories/product/product_repository_interface.dart';
import '../../../../featues/shop/models/product_model.dart';

class AllProductsController extends GetxController {
  final IProductRepository _injectedRepository;

  // Added categoryId to the controller
  final String? categoryId;

  // We still store the query passed to the constructor (for other filtering use cases)
  final Query? _query;

  // Modify the constructor to accept the injected repository, categoryId, and query
  AllProductsController(
      this._injectedRepository, {
        this.categoryId, // Accept categoryId
        Query? query,
        List<ProductModel>? initialProducts,
      }) : _query = query {
    // Initialize the products list with the provided initialProducts if available
    if (initialProducts != null) {
      products.assignAll(initialProducts);
      sortProducts(selectedSortOption.value); // Apply current sort on initialization
    }
  }

  final RxString selectedSortOption = 'Name'.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

  final isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    // Only fetch products if no initial products were provided.
    // The decision of *what* to fetch (based on categoryId, query, or default) happens in fetchProducts.
    if (products.isEmpty) {
      fetchProducts();
    }
    super.onInit();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      errorMessage.value = ''; // Clear any previous error message

      List<ProductModel> fetchedProducts = [];

      print('AllProductsController: Attempting to fetch products...');

      // --- MODIFIED LOGIC TO PRIORITIZE categoryId ---
      if (categoryId != null) {
        // If categoryId is provided, fetch category-specific products using the injected repository
        print('AllProductsController: Fetching products for categoryId: $categoryId using injected repository.');
        fetchedProducts = await _injectedRepository.getProductsForCategory(categoryId!);
        print('AllProductsController: getProductsForCategory returned ${fetchedProducts.length} products.');

      } else if (_query != null) {
        // If no categoryId but a Query is provided, use the tagged Firebase repository
        // This is for specific Firebase queries not related to category fetching in this context.
        print('AllProductsController: Query provided, attempting to use Firebase repository.');
        try {
          final firebaseRepository = Get.find<IProductRepository>(tag: 'firebase');
          fetchedProducts = await firebaseRepository.fetchProductByQuery(_query!);
          print('AllProductsController: fetchProductByQuery returned ${fetchedProducts.length} products.');
        } catch (e) {
          print('AllProductsController: Error using Firebase repository or executing query: $e');
          errorMessage.value = 'Failed to fetch products with query: ${e.toString()}';
          rethrow; // Re-throw the original error
        }

      } else {
        // If no categoryId and no Query, fetch all products using the default injected repository
        print('AllProductsController: No categoryId or query provided, using injected repository to fetch default/all products.');
        fetchedProducts = await _injectedRepository.getProducts(); // Assuming getProducts() exists and fetches a default list
        print('AllProductsController: getProducts returned ${fetchedProducts.length} products.');
      }
      // --- END OF MODIFIED LOGIC ---


      // Assign the fetched products to the observable list
      products.assignAll(fetchedProducts); // Use assignAll to replace the list

      // Apply the currently selected sort option after fetching
      sortProducts(selectedSortOption.value);

      if (products.isEmpty && errorMessage.isEmpty) {
        print('AllProductsController: Fetch completed, but no products found and no explicit error.');
        // errorMessage.value = 'No products available matching the criteria.'; // Optional: Set a no data message
      }

    } catch (e) {
      print('AllProductsController (Outer Catch): Error fetching products: $e');
      errorMessage.value = e.toString(); // Set the error message
      products.clear(); // Ensure products list is empty on error

    } finally {
      isLoading.value = false;
      print('AllProductsController: isLoading set to false.');
    }
  }

  void sortProducts(String sortOption) {
    selectedSortOption.value = sortOption;

    // Create a mutable copy for sorting
    List<ProductModel> currentProducts = List.from(products);

    switch (sortOption) {
      case 'Name':
        currentProducts.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
        break;
      case 'Higher Price':
        currentProducts.sort((a, b) => (b.price ?? 0.0).compareTo(a.price ?? 0.0));
        break;
      case 'Lower Price':
        currentProducts.sort((a, b) => (a.price ?? 0.0).compareTo(b.price ?? 0.0));
        break;
      case 'Newest':
      // Assuming ProductModel has a creation date/timestamp field (e.g., 'date')
      // If your data doesn't have this, this sort might not work reliably.
        currentProducts.sort((a, b) {
          // Handle null dates gracefully
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return 1; // Nulls sort last
          if (b.date == null) return -1; // Nulls sort last
          return b.date!.compareTo(a.date!); // Newest first
        });
        break;
      case 'Sale':
      // Assuming ProductModel has a salePrice field.
      // Sort by sale price, items with no sale price come last.
        currentProducts.sort((a, b) {
          final aSale = a.salePrice ?? 0.0;
          final bSale = b.salePrice ?? 0.0;

          if (aSale > 0 && bSale > 0) {
            return bSale.compareTo(aSale); // Higher sale price first
          } else if (aSale > 0) {
            return -1; // a has sale, b doesn't, a comes first
          } else if (bSale > 0) {
            return 1; // b has sale, a doesn't, b comes first
          } else {
            return 0; // Neither has sale or both don't
          }
        });
        break;
      default:
      // Fallback to sorting by title if sort option is unrecognized
        currentProducts.sort((a, b) => (a.title ?? '').compareTo(b.title ?? ''));
        break;
    }
    // Assign the sorted list back to the observable products list
    products.assignAll(currentProducts);
  }
}