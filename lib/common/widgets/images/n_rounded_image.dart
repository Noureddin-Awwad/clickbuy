import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';
// Import your image strings if you use a placeholder asset here
// import '../../../utils/constants/image_strings.dart';

class NRoundedImage extends StatelessWidget {
  const NRoundedImage({
    super.key,
    this.width,
    this.height,
    this.imageUrl, // Can be network URL or asset path
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false, // Indicates if imageUrl is a network URL
    this.onPressed,
    this.borderRadius = NSizes.md,
  });

  final double? width, height;
  final String? imageUrl; // Can be network URL or asset path
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage; // Flag to distinguish between network and asset
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    // Determine the image widget based on isNetworkImage and imageUrl
    Widget imageWidget;
    if (imageUrl != null && imageUrl!.isNotEmpty) { // Check if imageUrl is not null or empty
      if (isNetworkImage) {
        // Use CachedNetworkImage for network images
        imageWidget = CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: fit,
          progressIndicatorBuilder:
              (context, url, downloadProgress) =>
              NShimmerEffect(
                  width: width ?? double.infinity,
                  height: height ?? 158),
          errorWidget: (context, url, error) => const Icon(Icons.error), // Add error widget
        );
      } else {
        // Use Image with AssetImage for local assets
        imageWidget = Image(
          fit: fit,
          image: AssetImage(imageUrl!), // Use AssetImage for asset paths
          errorBuilder: (context, error, stackTrace) {
            // Optional: Add an error builder for asset loading failures
            print('Error loading asset image: $imageUrl');
            return const Icon(Icons.error); // Or a specific placeholder asset
          },
        );
      }
    } else {
      // Display a placeholder or empty box if imageUrl is null or empty
      // You could return a specific placeholder asset here if needed
      imageWidget = Image(image: AssetImage(NImage.productImage1));
      imageWidget = const SizedBox(); // Or an empty container
    }


    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
            borderRadius: applyImageRadius
                ? BorderRadius.circular(borderRadius)
                : BorderRadius.zero,
            // Use the determined imageWidget
            child: imageWidget),
      ),
    );
  }
}