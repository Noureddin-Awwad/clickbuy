import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/common/widgets/images/n_rounded_image.dart';
import 'package:e_commerce/common/widgets/products/favorite_icon/favorite_icon.dart';
import 'package:e_commerce/common/widgets/products/product_price_text.dart';
import 'package:e_commerce/common/widgets/texts/brand_title_text_with_icon.dart';
import 'package:e_commerce/common/widgets/texts/product_title_text.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../featues/shop/controllers/product/product_controller.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/enums.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../icons/n_circular_icon.dart';

class NProductCardHorizontal extends StatelessWidget {
  const NProductCardHorizontal({super.key, required this.product});

  final ProductModel product ;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = NHelperFumctions.isDarkMode(context);

    return Container(
      width: 310,
      padding: EdgeInsets.all(1),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(NSizes.productImageRadius),
        color: dark ? NColors.darkerGrey : NColors.lightContainer,
      ),
      child: Row(
        children: [
          /// Thumbnail
          NRoundedContainer(
            height: 130,
            padding: EdgeInsets.all(NSizes.sm),
            backgroundColor: dark ? NColors.dark : NColors.white,
            child: Stack(
              children: [
                /// ThumbNail Image
                SizedBox(
                    width: 120,
                    height: 130,
                    child: NRoundedImage(
                      imageUrl: product.thumbnail,
                      applyImageRadius: true,
                      isNetworkImage: true,
                    ),
                ),

                /// Sale Tag
                if (salePercentage != null)
                Positioned(
                  top: 1,
                  child: NRoundedContainer(
                    radius: NSizes.sm,
                    backgroundColor: NColors.secondary.withOpacity(0.8) ,
                    padding: EdgeInsets.symmetric(horizontal: NSizes.sm , vertical: NSizes.xs),
                    child: Text('$salePercentage%',style: Theme.of(context).textTheme.labelLarge!.apply(color: NColors.black),),
                  ),
                ),

                /// Favourite Icon Button
                Positioned(
                    right: 10,
                    top:   0,
                    child: NFavouriteIcon(productId: product.id)
                ),
              ],
            ),
          ),
          
          /// Details
          SizedBox(
            width: 170,
            child: Padding(
              padding: const EdgeInsets.only(top: NSizes.sm, left: NSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      NProductTitleText(title: product.title, smallSize: true,),
                      SizedBox(height: NSizes.spaceBtwItems/2,),
                      NBrandTitleTextWithVerificationIcon(title: product.brand!.name),
                    ],
                  ),
                  Spacer(),

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
          )
        ],
      ),
    );
  }
}
