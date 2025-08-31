import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller.dart';
import '../../../models/cart_model.dart'; // Import CartController

class AddToCartButton extends StatelessWidget {
  final String productId;
  final String title;
  final double price;
  final String thumbnail;

  const AddToCartButton({
    super.key,
    required this.productId,
    required this.title,
    required this.price,
    required this.thumbnail,
  });

  @override
  Widget build(BuildContext context) {
    // Access the CartController
    final cartController = Get.find<CartController>();

    return Obx(() {
      // Check if the product is already in the cart
      final isInCart = cartController.cartItems.any((item) => item.productId == productId);
      final cartItem = cartController.cartItems.firstWhereOrNull((item) => item.productId == productId);

      return GestureDetector(
        onTap: () {
          if (isInCart) {
            // Remove the product from the cart
            cartController.removeFromCart(productId);
            Get.snackbar('Removed', '$title has been removed from the cart.');
          } else {
            // Add the product to the cart
            final product = CartModel(
              productId: productId,
              title: title,
              price: price,
              quantity: 1,
              thumbnail: thumbnail,
            );
            cartController.addToCart(product);
            Get.snackbar('Added', '$title has been added to the cart.');
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isInCart ? Colors.red : NColors.primary, // Change color based on cart state
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(NSizes.cardRadiusMd),
              bottomRight: Radius.circular(NSizes.productImageRadius),
            ),
          ),
          child: SizedBox(
            width: NSizes.iconLg * 1.2,
            height: NSizes.iconLg * 1.2,
            child: Center(
              child: isInCart
                  ? Text(
                cartItem?.quantity.toString() ?? '1',
                style: TextStyle(color: NColors.white, fontWeight: FontWeight.bold),
              )
                  : Icon(Iconsax.add, color: NColors.white),
            ),
          ),
        ),
      );
    });
  }
}