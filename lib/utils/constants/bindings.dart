// File: lib/utils/constants/bindings.dart (Updated for LazyPut)

import 'package:e_commerce/data/repositories/brand_repository.dart';
import 'package:get/get.dart';
import '../../data/data_controller/product_data_source_controller.dart';
import '../../data/repositories/categories/category_repository.dart';
import '../../data/repositories/fake_store_api_service/fake_store_api_service.dart';
import '../../data/repositories/fake_store_brand_repository/fake_store_brand_repository.dart';
import '../../data/repositories/fake_store_category/i_category_repository.dart';
import '../../data/repositories/i_brand_repository/i_brand_repository.dart';
import '../../data/repositories/product/product_repository_interface.dart';
import '../../data/repositories/fake_store_product/fake_store_product_repository.dart';
import '../../data/repositories/product/product_repository.dart';
import '../../data/repositories/fake_store_category/fake_store_category_repository.dart';
import '../network/network_manager.dart';

// Import controllers here
import '../../featues/shop/controllers/product/brand_controller.dart';
import '../../featues/shop/controllers/category_cotroller.dart';
import '../../featues/shop/controllers/product/product_controller.dart';
import '../../featues/shop/controllers/product/favourite_controller.dart';


class AppBindings extends Bindings {
  @override
  void dependencies() {
    print("🔄 [AppBindings] Starting dependency registration...");

    Get.put(NetworkManager(), permanent: true);
    print("✅ NetworkManager registered");

    final pdc = ProductDataSourceController();
    Get.put<ProductDataSourceController>(pdc, permanent: true);
    print("✅ ProductDataSourceController registered");

    Get.put(FakeStoreApiService(), permanent: true);
    print("✅ FakeStoreApiService registered");

    // Tagged Repositories
    Get.put<IProductRepository>(FakeStoreProductRepository(), permanent: true, tag: 'fake');
    Get.put<ICategoryRepository>(FakeStoreCategoryRepository(), permanent: true, tag: 'fake');
    Get.put<IBrandRepository>(FakeStoreBrandRepository(), permanent: true, tag: 'fake');

    Get.put<IProductRepository>(ProductRepository(), permanent: true, tag: 'firebase');
    Get.put<ICategoryRepository>(CategoryRepository(), permanent: true, tag: 'firebase');
    Get.put<IBrandRepository>(FirebaseBrandRepository(), permanent: true, tag: 'firebase');
    print("✅ Fake & Firebase repositories registered");

    // Lazy Put Controllers
    Get.lazyPut<ProductController>(() => ProductController(Get.find()));
    Get.lazyPut<CategoryController>(() => CategoryController(Get.find()));
    Get.lazyPut<FavouritesController>(() => FavouritesController(Get.find()));
    Get.lazyPut<BrandController>(() => BrandController(
      brandRepository: Get.find(),
      productRepository: Get.find(),
    ));
    print("✅ Controllers lazy-put");

    print("🔄 [AppBindings] Dependency registration completed");
  }
}