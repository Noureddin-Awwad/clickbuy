import 'dart:convert';
import 'package:e_commerce/common/widgets/loaders/loaders.dart';
import 'package:e_commerce/data/repositories/product/product_repository_interface.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:get/get.dart';
import 'package:e_commerce/utils/local_storage/storage_utility.dart'; // Make sure this path is correct

class FavouritesController extends GetxController {
  final IProductRepository productRepository;

  FavouritesController(this.productRepository);

  /// Variables
  final favorites = <String, bool>{}.obs;
  final favoriteProducts = <ProductModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initFavourites();
    fetchFavoriteProducts();
  }

  // Method to initialize favourites by reading from storage
  void initFavourites() {
    print('Initializing favorites...');

    // ✅ Pass bucket name to instance()
    final json = NLocalStorage.instance('favorites').readData<String>('favorites');

    print('Read from storage: $json');
    if (json != null) {
      try {
        final storedFavorites = jsonDecode(json) as Map<String, dynamic>;
        print('Decoded stored favorites: $storedFavorites');
        favorites.assignAll(storedFavorites.map((key, value) => MapEntry(key, value as bool)));
        print('Favorites assigned from storage: $favorites');
      } catch (e) {
        print('Error decoding or assigning stored favorites: $e');
        // Consider clearing favorites or handling the error if storage data is corrupt
      }
    } else {
      print('No favorites found in storage.');
    }
    print('Favorites initialized.');
  }

  bool isFavourite(String productId) {
    return favorites[productId] ?? false;
  }

  void toggleFavouriteProduct(String productId) async {
    print('toggleFavouriteProduct called for product ID: $productId');
    print('Favorites before toggle: $favorites'); // Check state before logic

    if (!favorites.containsKey(productId)) {
      print('Product $productId not favorited. Adding.');
      favorites[productId] = true;
      print('Favorites after adding: $favorites'); // Check state after adding
      saveFavouritesToStorage();
      NLoaders.customToast(message: 'Product has been added to the Wishlist.');
      print('Calling fetchFavoriteProducts after adding...');
      await fetchFavoriteProducts(); // Await the fetch
      print('fetchFavoriteProducts completed after adding.');
    } else {
      print('Product $productId already favorited. Removing.');
      favorites.remove(productId);
      print('Favorites after removing: $favorites'); // Check state after removing
      saveFavouritesToStorage();
      favorites.refresh(); // Refresh the observable map
      NLoaders.customToast(message: 'Product has been removed from the Wishlist.');
      print('Calling fetchFavoriteProducts after removing...');
      await fetchFavoriteProducts(); // Await the fetch
      print('fetchFavoriteProducts completed after removing.');
    }
    print('toggleFavouriteProduct finished for product ID: $productId');
  }

  void saveFavouritesToStorage() {
    final encodedFavorites = json.encode(favorites);

    // ✅ Pass bucket name
    NLocalStorage.instance('favorites').saveData('favorites', encodedFavorites);
  }

  Future<void> fetchFavoriteProducts() async {
    print('fetchFavoriteProducts called...');
    try {
      isLoading.value = true;
      print('isLoading set to true');

      // Use the injected repository (which is an IProductRepository instance)
      print('Fetching favorite products using the injected repository...');

      // Pass the list of favorite product IDs from the 'favorites' map
      final favoriteProductIds = favorites.keys.toList();
      print('Fetching favorite products for IDs: $favoriteProductIds');

      final products = await productRepository.getFavouriteProducts(favoriteProductIds);

      print('Fetched ${products.length} favorite products.');
      favoriteProducts.assignAll(products);
      print('favoriteProducts updated. Current list size: ${favoriteProducts.length}');
    } catch (e) {
      print('Error fetching favorite products: $e');
      NLoaders.errorSnackBar(title: 'Oh Snap', message: 'Failed to fetch favorite products: ${e.toString()}');
      favoriteProducts.clear();
    } finally {
      isLoading.value = false;
      print('isLoading set to false');
      print('fetchFavoriteProducts finished.');
    }
  }
}