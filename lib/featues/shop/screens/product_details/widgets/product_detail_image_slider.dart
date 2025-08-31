import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:e_commerce/featues/shop/controllers/product/images_controller.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart'; // Assuming you still need GetStorage somewhere
import 'package:iconsax/iconsax.dart'; // Assuming you still need Iconsax somewhere

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import '../../../../../common/widgets/icons/n_circular_icon.dart'; // Assuming you still need this
import '../../../../../common/widgets/images/n_rounded_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart'; // Make sure this file exists and has NImages.productPlaceholder
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class NProductImageSlider extends StatelessWidget {
  const NProductImageSlider({
    super.key,
    required this.product,
  });

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    // Using Get.put to create or find the ImagesController instance
    final controller = Get.put(ImagesController());

    // Get all available product images (will now filter out empty/null URLs)
    final List<String> images = controller.getAllProductImages(product);

    final dark = NHelperFumctions.isDarkMode(context);

    return NCurvedEdgeWidget(
      child: Container(
        // Use a safe background color
        color: dark ? NColors.darkerGrey : NColors.light,
        child: Stack(
          children: [
            /// Main Large Image
            SizedBox(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(NSizes.productImageRadius * 2),
                child: Center(
                  child: Obx(
                        () {
                      final image = controller.selectedProductImage.value;
                      // Check if the selected image URL is valid before attempting to load
                      if (image.isNotEmpty) {
                        return GestureDetector(
                          onTap: () => controller.showEnlargedImage(image),
                          child: CachedNetworkImage(
                            imageUrl: image,
                            progressIndicatorBuilder: (_, __, downloadProgress) =>
                                CircularProgressIndicator(
                                  value: downloadProgress.progress,
                                  color: NColors.primary,
                                ),
                            // Add an error widget for network loading failures
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error_outline, size: 60, color: Colors.red),
                          ),
                        );
                      } else {
                        // Display a placeholder asset image if the selected image URL is empty
                        // IMPORTANT: Replace 'assets/images/placeholders/product_placeholder.png'
                        // with the actual path to your placeholder image asset.
                        // Ensure this asset is listed in your pubspec.yaml.
                        // Using NImages.productPlaceholder assumes you have defined it.
                        return Image(image: AssetImage(NImage.nikeLogo));
                      }
                    },
                  ),
                ),
              ),
            ),

            /// Image Slider (Thumbnail Images)
            Positioned(
              right: 0,
              bottom: 30,
              left: NSizes.defaultSpace,
              child: SizedBox(
                height: 80,
                child: ListView.separated(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const AlwaysScrollableScrollPhysics(), // Use const
                  separatorBuilder: (_, __) => const SizedBox( // Use const
                    width: NSizes.spaceBtwItems,
                  ),
                  itemCount: images.length,
                  itemBuilder: (_, index) {
                    final imageItemUrl = images[index]; // Get the image URL for this item

                    // Only display if the image URL for this item is not empty
                    if (imageItemUrl.isNotEmpty) {
                      final imageSelected = controller.selectedProductImage.value == imageItemUrl;
                      return NRoundedImage(
                        width: 80,
                        isNetworkImage: true,
                        backgroundColor: dark ? NColors.dark : NColors.white,
                        border: Border.all(
                            color: imageSelected
                                ? NColors.primary
                                : Colors.transparent),
                        padding: const EdgeInsets.all(NSizes.sm), // Use const
                        onPressed: () {
                          // Only update selected image if the tapped image URL is not empty
                          if (imageItemUrl.isNotEmpty) {
                            controller.selectedProductImage.value = imageItemUrl;
                          } else {
                            // Handle tap on an unexpected empty entry if needed
                            print('Attempted to select an empty image URL from the slider.');
                          }
                        },
                        imageUrl: imageItemUrl, // Pass the individual item's image URL
                      );
                    } else {
                      // Return an empty container or a placeholder for empty entries if necessary,
                      // though the updated getAllProductImages should prevent empty strings.
                      return const SizedBox.shrink(); // Or a small placeholder
                    }
                  },
                ),
              ),
            ),

            /// Appbar
             NAppBar( // Use const if possible
              showBackArrow: true,
              actions: [
                NFavouriteIcon(productId: product.id,)
              ],
            )
          ],
        ),
      ),
    );
  }
}