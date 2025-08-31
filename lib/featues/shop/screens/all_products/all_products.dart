// File: lib/featues/shop/screens/all_products/all_products.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // Still needed for Query type
import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/products/sortable/sortable_products.dart';
import '../../../../data/repositories/product/product_repository_interface.dart';
import '../../../../utils/helpers/cloud_helper_functions.dart'; // Still potentially useful for error/empty states
import '../../controllers/product/all_products_controller.dart';


class AllProducts extends StatelessWidget {
  const AllProducts({
    super.key,
    required this.title,
    this.query,
    this.categoryId,
    // futureMethod is less needed now as controller handles fetching
    // this.futureMethod // Consider removing this if not strictly required
  });

  final String title;
  final Query? query;
  final String? categoryId;
  // final Future<List<ProductModel>>? futureMethod; // Consider removing

  @override
  Widget build(BuildContext context) {


    // FIX: Get the *currently bound* IProductRepository directly using Get.find()
    // The ProductDataSourceController manages WHICH repository is bound here.
    final IProductRepository currentProductRepository = Get.find<IProductRepository>();



    // Use Get.put to create and register the AllProductsController instance
    // Pass the currently active IProductRepository and the query
    // Add logging before and after Get.put
    print('AllProducts: Attempting to put AllProductsController...');
    final allProductsController = Get.put(
      AllProductsController(
        currentProductRepository, // Pass the repository obtained via Get.find()
        query: query, // Pass the query
        categoryId: categoryId,
      ),
    );
    print('AllProducts: AllProductsController put successfully.');
    print('AllProducts: Passed Query to controller: $query');


    return Scaffold(
      /// AppBar
      appBar: NAppBar(
        title: Text(title), // Use the title passed to the widget
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          // Use Obx to react to changes in the controller's state
          child: Obx(
                () {
              // Add logging inside Obx to track state changes
              print('AllProducts Obx: isLoading: ${allProductsController.isLoading.value}, products count: ${allProductsController.products.length}');

              // Check the loading state first
              if (allProductsController.isLoading.value) {
                print('AllProducts Obx: Showing shimmer loader.');
                return const NVerticalProductShimmer();
              }


              // Check if products list is empty
              if (allProductsController.products.isEmpty) {
                print('AllProducts Obx: Products list is empty, showing "No Products Found".');
                // You can use NCloudHelperFunctions or a custom widget for No Data Found state
                return Center(
                  child: Text(
                    'No Products Found',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              }

              // Products are available, display the sortable products
              print('AllProducts Obx: Products found, rendering sortable products.');
              return NSortableProducts(products: allProductsController.products);
            },
          ),
        ),
      ),
    );
  }
}