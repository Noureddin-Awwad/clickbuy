import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/common/styles/shadows.dart';
import 'package:e_commerce/common/widgets/images/n_rounded_image.dart';
import 'package:e_commerce/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:e_commerce/common/widgets/texts/product_title_text.dart';
import 'package:e_commerce/featues/shop/controllers/product/product_controller.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/featues/shop/screens/product_details/product_details.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../icons/n_circular_icon.dart';
import '../../texts/brand_title_text_with_icon.dart';
import '../product_price_text.dart';

class NProductCardVertical extends StatelessWidget {
  const NProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = NHelperFumctions.isDarkMode(context);
    ///Container with side paddings,color,edges,radius and shadow
    return GestureDetector(
      onTap: () => Get.to(() => ProductDetails(product: product,)),
      child: Container(
        width: 180,
        padding: EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [NShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(NSizes.productImageRadius),
          color: dark ? NColors.darkerGrey : NColors.white,
        ),
        child: Column(
          children: [
            /// Thumbnail, Wishlist Button, Discount Tag
            NRoundedContainer(
              height: 180,
              width: 180,
              padding: const EdgeInsets.all(NSizes.sm),
              backgroundColor: NColors.white,
              child: Stack(
                children: [
                  /// Thumbnail image
                  Center(child: NRoundedImage(imageUrl: product.thumbnail , applyImageRadius: true,isNetworkImage: true,)),

                  /// Sale Tag
                  if(salePercentage != null)
                  Positioned(
                    top: 12,
                    child: NRoundedContainer(
                      radius: NSizes.sm,
                      backgroundColor: NColors.secondary.withOpacity(0.8) ,
                      padding: EdgeInsets.symmetric(horizontal: NSizes.sm , vertical: NSizes.xs),
                      child: Text('$salePercentage%',style: Theme.of(context).textTheme.labelLarge!.apply(color: NColors.black),),
                    ),
                  ),

                  /// Favourite Icon Button
                  Positioned(
                      right: 0,
                      top:   0,
                      child:NFavouriteIcon(productId: product.id),
                  ),
                ],
              ),
            ),

            const SizedBox(height: NSizes.spaceBtwItems / 2,),
            ///  Details
            Padding(
                padding: EdgeInsets.only(left: NSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  NProductTitleText(title: product.title,smallSize: true,),
                  const SizedBox(height: NSizes.spaceBtwItems / 2,),
                  NBrandTitleTextWithVerificationIcon(title: product.brand?.name ?? 'ClickBuy',),

                ],
              ),
            ),
            Spacer(),
            /// Price Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                /// Price
                Flexible(
                  child: Column(
                    children: [
                      if(product.productType == ProductType.single.toString() && product.salePrice > 0)
                        Padding(
                            padding: const EdgeInsets.only(left: NSizes.sm),
                          child: Text(
                            product.price.toString(),
                            style: Theme.of(context).textTheme.labelMedium!.apply(decoration: TextDecoration.lineThrough),
                          )
                        ),


                      /// Price , Show Sale price as main price if sale exist
                      Padding(
                        padding: const EdgeInsets.only(left: NSizes.sm),
                        child: NProductPriceText(price: controller.getProductPrice(product),),
                      ),
                    ],
                  ),
                ),
                /// Add to Cart Button
                Container(
                  decoration: BoxDecoration(
                    color: NColors.dark,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(NSizes.cardRadiusMd),
                      bottomRight: Radius.circular(NSizes.productImageRadius),
                    ),
                  ),
                  child: SizedBox(
                      width: NSizes.iconLg * 1.2,
                      height: NSizes.iconLg * 1.2,
                      child: Center(child: Icon(Iconsax.add , color: NColors.white))),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}








