// File: lib/common/widgets/products/sortable/sortable_products.dart

import 'package:e_commerce/featues/shop/controllers/product/all_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/product/product_repository_interface.dart';
import '../../../../featues/shop/models/product_model.dart';
import '../../../../utils/constants/sizes.dart';
import '../../layouts/grid_layout.dart';
import '../product_cards/product_card_vertical.dart'; // Import the interface

class NSortableProducts extends StatelessWidget {
  const NSortableProducts({
    super.key, required this.products,
  });

  final List<ProductModel> products;

  @override
  Widget build(BuildContext context) {
    // FIX 1: Pass the required IProductRepository and the initial products list
    final controller = Get.put(
      AllProductsController(
        Get.find<IProductRepository>(), // Get the currently registered repository
        initialProducts: products, // Pass the initial products list
        // No query needed as we are providing the products directly
      ),
    );

    // FIX 2: Remove the call to assignProducts, as initialization happens in the constructor
    // controller.assignProducts(products); // REMOVE THIS LINE

    return Column(
      children: [
        /// Dropdown
        Obx( // Wrap DropdownButtonFormField with Obx to react to selectedSortOption changes
              () => DropdownButtonFormField(
            decoration: InputDecoration(prefixIcon: Icon(Iconsax.sort)),
            value: controller.selectedSortOption.value,
            onChanged: (value) {
              // Sort products based on the selected option
              controller.sortProducts(value!);
            },
            items: [
              'Name',
              'Higher Price',
              'Lower Price',
              'Sale',
              'Newest',
              'Popularity'
            ]
                .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
          ),
        ),
        SizedBox(height: NSizes.spaceBtwSections,),

        /// Products
        // This Obx is already correctly reacting to controller.products changes
        Obx(() => NGridLayout(
            itemCount: controller.products.length,
            itemBuilder: (_, index) => NProductCardVertical(product: controller.products[index])))
      ],
    );
  }
}