import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/products/sortable/sortable_products.dart';
import '../../../../../data/repositories/product/product_repository_interface.dart';
import '../../../../../utils/helpers/cloud_helper_functions.dart';
import 'package:e_commerce/data/repositories/product/product_repository.dart'; // Import the ProductRepository

class CategoryProductsScreen extends StatelessWidget {
  const CategoryProductsScreen({
    super.key,
    required this.title, // Title for the app bar
    required this.categoryId, // We need the category ID now
    // Removed 'this.query' and 'this.futureMethod' as we'll use the repository directly
  });

  final String title;
  final String categoryId; // Pass the category ID here

  @override
  Widget build(BuildContext context) {
    // Get the appropriate ProductRepository instance (will be Firebase or FakeStore based on bindings)
    final productRepository = Get.find<IProductRepository>(); // Or IProductRepository if you prefer

    return Scaffold(
      /// AppBar
      appBar: NAppBar(
        title: Text(title), // Use the passed title
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: FutureBuilder(
            // Call the repository method to get products for the given categoryId
            // This call will be dispatched to the correct repository implementation
            // (Firebase or Fake Store) based on GetX bindings.
            future: productRepository.getProductsForCategory(categoryId),
            builder: (context, snapshot) {
              // Check the State of the future builder
              const loader = NVerticalProductShimmer();
              final widget = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);

              // Return appropriate widget based on snapshot state (loading, error, no data)
              if (widget != null) return widget;

              // Products Found - Extract the data safely
              final products = snapshot.data!; // snapshot.data is List<ProductModel>

              // Ensure products is not null and is a list before passing to NSortableProducts
              if (products.isEmpty) {
                return Center(child: Text('No products found for this category.', style: Theme.of(context).textTheme.bodyMedium));
              }

              // Display the products using your sorting widget
              return NSortableProducts(products: products);
            },
          ),
        ),
      ),
    );
  }
}