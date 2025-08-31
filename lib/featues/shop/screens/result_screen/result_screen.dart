import 'dart:io';
import 'package:e_commerce/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:e_commerce/featues/shop/screens/result_screen/widgets/result_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/shimmer/vertical_product_shimmer.dart';
import '../../../../utils/constants/sizes.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    super.key,
    required this.imageFile,
  });

  final File? imageFile;

  @override
  Widget build(BuildContext context) {
    // Use Get.find to avoid reinitializing the controller
    final controller = Get.put(ResultScreenController());

    // Debug log for the image file
    print("Image file path: ${imageFile?.path}");

    // Start processing when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.processImageAndFetchProducts(imageFile);
    });

    return Scaffold(
      appBar: NAppBar(
        title: Text('AI Search Results'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Obx(() {
            // Debug logs for reactive updates
            print("isLoading: ${controller.isLoading.value}");
            print("Matching products count: ${controller.matchingProducts.length}");

            if (controller.isLoading.value) {
              return const NVerticalProductShimmer();
            }

            if (controller.matchingProducts.isEmpty) {
              return Center(
                child: Text(
                  'No products found.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              );
            }

            return NGridLayout(
              itemCount: controller.matchingProducts.length,
              mainAxisExtent: 288,
              itemBuilder: (context, index) {
                try {
                  final product = controller.matchingProducts[index];
                  print("Rendering product at index $index: ${product.title}");
                  return NProductCardVertical(product: product);
                } catch (error) {
                  print("Error rendering product at index $index: $error");
                  return Center(child: Text("Failed to load product."));
                }
              },
            );
          }),
        ),
      ),
    );
  }
}