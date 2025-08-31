import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/featues/shop/screens/cart/widgets/cart_items.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../checkout/checkout.dart';
import '../../controllers/cart_controller.dart'; // Import the CartController

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access the CartController
    final cartController = Get.put(CartController());

    return Scaffold(
      appBar: NAppBar(
        showBackArrow: true,
        title: Text(
          'Cart',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(NSizes.defaultSpace),
        child: Obx(() {
          // Check if the cart is empty
          if (cartController.cartItems.isEmpty) {
            return Center(
              child: Text(
                'Your cart is empty.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }

          // Display cart items using NCartItems
          return NCartItems();
        }),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(NSizes.defaultSpace),
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the CheckoutScreen
            Get.to(() => CheckoutScreen());
          },
          child: Text('Checkout \$${cartController.totalPrice}'),
        ),
      ),
    );
  }
}