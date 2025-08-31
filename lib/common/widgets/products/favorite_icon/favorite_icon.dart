import 'package:e_commerce/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import '../../../../data/repositories/product/product_repository_interface.dart';
import '../../../../featues/shop/controllers/product/favourite_controller.dart';
import '../../icons/n_circular_icon.dart';

class NFavouriteIcon extends StatelessWidget {
  const NFavouriteIcon({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavouritesController(Get.find<IProductRepository>()));
    return Obx(() =>  NCircularIcon(
          icon: controller.isFavourite(productId) ? Iconsax.heart5 : Iconsax.heart,
          color: controller.isFavourite(productId) ? NColors.error : null,

          onPressed: () =>  controller.toggleFavouriteProduct(productId),
    ));
  }
}
