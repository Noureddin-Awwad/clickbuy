import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
// Import image strings if you use a default/placeholder asset
// import '../../../utils/constants/image_strings.dart';


class NCircularImage extends StatelessWidget {
  const NCircularImage({
    super.key,
    this.fit,
    required this.image, // Still required, but handle cases where it might be invalid content
    this.isNetworkImage = false,
    this.overlayColor,
    this.backgroundColor,
    this.width =56,
    this.height =56,
    this.padding = NSizes.sm,
  });

  final BoxFit? fit;
  final String image; // Can be network URL or asset path depending on isNetworkImage
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: backgroundColor ?? (NHelperFumctions.isDarkMode(context)? NColors.black : NColors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Center(
          // Check if the image string is not empty before attempting to load
          child: image.isNotEmpty
              ? isNetworkImage
              ? CachedNetworkImage(
            fit: fit,
            color: overlayColor,
            imageUrl: image, // Use the provided network URL
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                NShimmerEffect(width: width - padding*2, height: height - padding*2, radius: (width - padding*2) / 2), // Adjust shimmer size
            errorWidget: (context,url,error) => const Icon(Icons.error), // Use const
          )
              : Image(
            fit: fit,
            // Ensure the image string is a local asset path here
            // Although we check image.isNotEmpty, you might want to
            // add further validation if you anticipate non-empty but
            // invalid asset paths. For now, image.isNotEmpty is sufficient
            // to prevent the empty string error. The main issue is passing
            // a network URL here.
            image:  AssetImage(image) , // Use the provided asset path
            color: overlayColor,
            errorBuilder: (context, error, stackTrace) {
              // Handle asset loading errors if the path is invalid
              print('Error loading asset image in CircularImage: $image');
              return const Icon(Icons.error); // Or a default asset icon
            },
          )
              : const SizedBox.shrink(), // Display an empty box if the image string is empty
        ),
      ),
    );
  }
}