import 'dart:async';

import 'package:e_commerce/featues/shop/controllers/category_cotroller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../common/widgets/loaders/loaders.dart';
import '../../featues/shop/controllers/product/brand_controller.dart';
import '../../featues/shop/controllers/product/product_controller.dart';
import '../../featues/shop/controllers/product/favourite_controller.dart';

import '../repositories/fake_store_category/i_category_repository.dart';
import '../repositories/i_brand_repository/i_brand_repository.dart';
import '../repositories/product/product_repository_interface.dart';

class ProductDataSourceController extends GetxController {
  static ProductDataSourceController get instance => Get.find();

  late final GetStorage _localStorage;
  final RxBool useFakeApi = false.obs;

  // Completers to signal when setup completes
  final Completer<void> _repositoriesInitializedCompleter = Completer<void>();
  late Completer<void> _controllersReinitializedCompleter;

  // Expose active repositories
  IProductRepository get activeProductRepository => Get.find<IProductRepository>();
  ICategoryRepository get activeCategoryRepository => Get.find<ICategoryRepository>();
  IBrandRepository get activeBrandRepository => Get.find<IBrandRepository>();

  String get activeDataSourceTag => useFakeApi.value ? 'fake' : 'firebase';

  ProductDataSourceController() {
    _controllersReinitializedCompleter = Completer<void>();
  }

  @override
  Future<void> onInit() async {
    print("🔄 [ProductDataSourceController] onInit started");
    _localStorage = GetStorage();
    print("✅ FavouritesController: GetStorage initialized");
    await _loadInitialPreferenceAndSetRepositories();
    super.onInit();
  }

  Future<void> _loadInitialPreferenceAndSetRepositories() async {
    try {
      final initialPreference = await _localStorage.read('useFakeApi');
      useFakeApi.value = initialPreference ?? false;
      print("✅ Initial data source: ${useFakeApi.value ? 'Fake' : 'Firebase'}");

      await _setDefaultRepositories(useFakeApi.value);
      if (!_repositoriesInitializedCompleter.isCompleted) {
        _repositoriesInitializedCompleter.complete();
      }
    } catch (e) {
      if (!_repositoriesInitializedCompleter.isCompleted) {
        _repositoriesInitializedCompleter.completeError(e);
      }
      rethrow;
    }
  }

  Future<void> _setDefaultRepositories(bool useFake) async {
    print("🔄 [_setDefaultRepositories] Setting up repositories for: ${useFake ? 'Fake' : 'Firebase'}");

    // --- Delete old default INTERFACE bindings ---
    print("🗑️ Deleting old repository/controller instances...");
    if (Get.isRegistered<IProductRepository>()) Get.delete<IProductRepository>(force: true);
    if (Get.isRegistered<ICategoryRepository>()) Get.delete<ICategoryRepository>(force: true);
    if (Get.isRegistered<IBrandRepository>()) Get.delete<IBrandRepository>(force: true);

    if (Get.isRegistered<ProductController>()) Get.delete<ProductController>(force: true);
    if (Get.isRegistered<CategoryController>()) Get.delete<CategoryController>(force: true);
    if (Get.isRegistered<FavouritesController>()) Get.delete<FavouritesController>(force: true);
    if (Get.isRegistered<BrandController>()) Get.delete<BrandController>(force: true);

    // --- Bind new default INTERFACE based on useFake value ---
    IProductRepository defaultProductRepo =
    Get.find<IProductRepository>(tag: useFake ? 'fake' : 'firebase');
    ICategoryRepository defaultCategoryRepo =
    Get.find<ICategoryRepository>(tag: useFake ? 'fake' : 'firebase');
    IBrandRepository defaultBrandRepo =
    Get.find<IBrandRepository>(tag: useFake ? 'fake' : 'firebase');

    Get.put<IProductRepository>(defaultProductRepo, permanent: true);
    Get.put<ICategoryRepository>(defaultCategoryRepo, permanent: true);
    Get.put<IBrandRepository>(defaultBrandRepo, permanent: true);
    print("✅ New default repositories bound");

    // --- Re-put controllers with updated dependencies ---
    print("✅ Putting new controllers...");
    Get.put(ProductController(defaultProductRepo), permanent: true);
    Get.put(CategoryController(defaultCategoryRepo), permanent: true);
    Get.put(FavouritesController(defaultProductRepo), permanent: true);
    Get.put(
      BrandController(
        brandRepository: defaultBrandRepo,
        productRepository: defaultProductRepo,
      ),
      permanent: true,
    );
    print("✅ Controllers re-registered with new dependencies");

    // --- Trigger fetches ---
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      await Get.find<CategoryController>().fetchCategories();
      await Get.find<ProductController>().fetchFeaturedProducts();
      await Get.find<BrandController>().fetchAllBrands();
      print("✅ Fetches triggered");
    } catch (e) {
      print("⚠️ Error during fetch calls: $e");
    }

    NLoaders.successSnackBar(title: 'Data Source Changed', message: 'Refreshing data...');
    await Future.delayed(const Duration(milliseconds: 500));
    Get.back();

    _controllersReinitializedCompleter.complete();
  }

  Future<void> toggleDataSource(bool value) async {
    print('DEBUG: Entering toggleDataSource with value: $value');
    if (useFakeApi.value == value) {
      print('DEBUG: Value did not change (${useFakeApi.value}). No action taken.');
      return;
    }

    useFakeApi.value = value;
    _localStorage.write('useFakeApi', value);
    print('DEBUG: useFakeApi preference written to storage: $value');

    _controllersReinitializedCompleter = Completer(); // Reset completer
    await _setDefaultRepositories(value);

    print('DEBUG: Exiting toggleDataSource.');
  }

  /// Future that resolves when repositories are set
  Future<void> get repositoriesInitialized => _repositoriesInitializedCompleter.future;

  /// Future that resolves when controllers are reinitialized
  Future<void> get controllersReinitialized => _controllersReinitializedCompleter.future;
}