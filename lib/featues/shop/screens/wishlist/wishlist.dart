

import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/icons/n_circular_icon.dart';
import 'package:e_commerce/common/widgets/layouts/grid_layout.dart';
import 'package:e_commerce/common/widgets/loaders/animation_loader.dart';
import 'package:e_commerce/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:e_commerce/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:e_commerce/featues/shop/screens/home/home.dart';
import 'package:e_commerce/navigation_menu.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
// We no longer need CloudHelperFunctions here
// import 'package:e_commerce/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/product/favourite_controller.dart';
// We no longer need to import ProductModel here if we only use the list from the controller
// import '../../models/product_model.dart';


class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the FavouritesController instance
    // Use Get.put if this is the first time the controller is accessed in this screen,
    // otherwise use Get.find()
    final controller = Get.find<FavouritesController>(); // Assuming you want to create/find it here


    return Scaffold(
      appBar: NAppBar(
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          NCircularIcon(
            icon: Iconsax.add,
            // Navigate to a screen where users can add products to the wishlist.
            // Consider navigating to a more appropriate screen to add products.
            onPressed: () => Get.to(() => HomeScreen()),
          )
        ],
      ),
      /// Body
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),

          /// Product Grid (Wrapped in Obx to react to favoriteProducts and isLoading changes)
          child: Obx(
                  () {
                // This Obx now directly accesses observable variables from the controller

                // Show loader while loading
                if (controller.isLoading.value) {
                  return const NVerticalProductShimmer(itemCount: 6); // Show shimmer while loading
                }

                // Get the list of favorite products from the observable list in the controller.
                final favoriteProducts = controller.favoriteProducts;

                // Show empty state if the favoriteItems list is empty
                if (favoriteProducts.isEmpty) {
                  return NAnimationLoaderWidget(
                      text: 'Whoops! Wishlist is Empty...',
                      animation: NImage.pencilAnimation, // Ensure this path is correct
                      showAction: true,
                      actionText: 'Let\'s add some',
                      // Navigate to the main app navigation menu.
                      onActionPressed: () => Get.offAll(() => NavigationMenu())
                  );
                }

                // If data is available and not empty, display the grid layout.
                return NGridLayout(
                    itemCount: favoriteProducts.length,
                    // Use the ProductCardVertical to display each product.
                    itemBuilder: (_, index) => NProductCardVertical(product: favoriteProducts[index])
                );
              }
          ),
        ),
      ),
    );
  }
}