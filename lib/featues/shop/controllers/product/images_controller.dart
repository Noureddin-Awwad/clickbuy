

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagesController extends GetxController{
  static ImagesController get instance => Get.find();


  /// Variables
  RxString selectedProductImage = ''.obs;

  /// -- Get All Images from product and Variations
  List<String> getAllProductImages(ProductModel product){
    Set<String> images ={};

    // load thumbnail image - ONLY IF NOT NULL OR EMPTY
    if (product.thumbnail != null && product.thumbnail.isNotEmpty) {
      images.add(product.thumbnail);
      // Assign Thumbnail as Selected Image - ONLY IF VALID
      selectedProductImage.value = product.thumbnail;
    } else {
      // If thumbnail is invalid, initialize selectedProductImage to an empty string
      // and it will be handled by the UI checks below.
      selectedProductImage.value = '';
    }


    // Get all images from the Product Model if not null - AND CHECK EACH IMAGE URL
    if (product.images != null){
      for (String? imageUrl in product.images!) { // Use nullable string type to be safe
        if (imageUrl != null && imageUrl.isNotEmpty) {
          images.add(imageUrl);
        }
      }
    }

    // Get all images from the Product Variations if not null. - AND CHECK EACH VARIATION IMAGE URL
    if(product.productVariations != null && product.productVariations!.isNotEmpty){ // Add null check for productVariations
      for (var variation in product.productVariations!) {
        if (variation.image != null && variation.image.isNotEmpty) {
          images.add(variation.image);
        }
      }
    }

    // Ensure selectedProductImage has a valid value if it's still empty
    // If no valid images were found, selectedProductImage remains ''.
    if (selectedProductImage.value.isEmpty && images.isNotEmpty) {
      selectedProductImage.value = images.first; // Set to the first valid image if available
    }


    return images.toList();
  }

  /// -- Show Image popup
  void showEnlargedImage(String image){
    Get.to(
      fullscreenDialog: true,
        ()=> Dialog.fullscreen(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(vertical: NSizes.defaultSpace*2 , horizontal: NSizes.defaultSpace),
                child: CachedNetworkImage(imageUrl: image),
              ),
              SizedBox(height: NSizes.spaceBtwSections,),
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  width: 150,
                  child: OutlinedButton(onPressed: () => Get.back(), child: Text('Close')),
                ),
              )
            ],
          ),
        )
    );
  }
}