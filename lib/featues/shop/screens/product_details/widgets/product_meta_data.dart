import 'package:e_commerce/common/widgets/images/n_circular_image.dart';
import 'package:e_commerce/common/widgets/products/product_price_text.dart';
import 'package:e_commerce/common/widgets/texts/brand_title_text_with_icon.dart';
import 'package:e_commerce/common/widgets/texts/product_title_text.dart';
import 'package:e_commerce/featues/shop/controllers/product/product_controller.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/utils/constants/enums.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class NProductMetaData extends StatelessWidget {
  const NProductMetaData({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();
    final salePercentage = controller.calculateSalePercentage(product.price, product.salePrice);
    final dark = NHelperFumctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Price & Sale Price
        Row(
          children: [
            ///Sale Tag
            NRoundedContainer(
              radius: NSizes.sm,
              backgroundColor: NColors.secondary.withOpacity(0.8) ,
              padding: EdgeInsets.symmetric(horizontal: NSizes.sm , vertical: NSizes.xs),
              child: Text('$salePercentage%',style: Theme.of(context).textTheme.labelLarge!.apply(color: NColors.black),),
            ),
            SizedBox(width: NSizes.spaceBtwItems,),

            ///Price
            if(product.productType == ProductType.single.toString() && product.salePrice > 0.0)
            Text('\$${product.price}',style: Theme.of(context).textTheme.titleSmall!.apply(decoration: TextDecoration.lineThrough ),),
            if(product.productType == ProductType.single.toString() && product.salePrice > 0.0)
            SizedBox(width: NSizes.spaceBtwItems,),
            NProductPriceText(price: controller.getProductPrice(product), isLarge: true,),
          ],
        ),
        SizedBox(height: NSizes.spaceBtwItems / 1.5,),
        /// Title
        NProductTitleText(title: product.title),
        SizedBox(height: NSizes.spaceBtwItems/1.5,),
        /// Stock Status
        Row(
          children: [
            NProductTitleText(title: 'Status'),
            SizedBox(width: NSizes.spaceBtwItems,),
            Text(controller.getProductStock(product.stock),style: Theme.of(context).textTheme.titleMedium ,),
          ],
        ),
        SizedBox(height: NSizes.spaceBtwItems/1.5,),
        /// Brand

        Row(
          children: [
            NCircularImage(
              image: product.brand != null ? product.brand!.image : '',
              isNetworkImage: true,
              width: 32,
              height: 32,
              overlayColor: dark ?NColors.white : NColors.black,
            ),
            SizedBox(width: NSizes.spaceBtwItems/1.5,),
            NBrandTitleTextWithVerificationIcon(title: product.brand != null ? product.brand!.name : '', brandTextSize: TextSizes.medium,),

          ],
        ),
        SizedBox(height: NSizes.spaceBtwItems/1.5,),

      ],
    );
  }
}
