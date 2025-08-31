import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:e_commerce/featues/shop/screens/brand/brand_products.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/styles/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import 'brand_card.dart';

class NBrandShowcase extends StatelessWidget {
  const NBrandShowcase({
    super.key, required this.images, required this.brand,
  });

  final BrandModel brand;
  final List <String> images ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.to(() => BrandProducts(brand: brand)),
      child: NRoundedContainer(
        showBorder: true,
        borderColor: NColors.darkerGrey,
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.all(NSizes.md),
        margin: const EdgeInsets.only(bottom: NSizes.spaceBtwItems),
        child: Column(
          children: [
            ///Brand with Products count
            NBrandCard(showBorder: false, brand: brand,),

            /// Brand Top 3 Product Images
            Row(
              children: images.map((image) => brandTopProductImageWidget(image, context)).toList(),
            )
          ],
        ),
      ),
    );
  }
}
Widget brandTopProductImageWidget (String image , context){
  return Expanded(
    child: NRoundedContainer(
      height: 100,
      padding: EdgeInsets.all(NSizes.md),
      margin: EdgeInsets.only(right: NSizes.sm),
      backgroundColor: NHelperFumctions.isDarkMode(context)? NColors.darkerGrey : NColors.light,
      child: CachedNetworkImage(
        fit: BoxFit.contain,
        imageUrl: image,
        progressIndicatorBuilder: (context,url, downloadProgress) => NShimmerEffect(width: 100, height: 100),
        errorWidget: (context,url,error)=> Icon(Icons.error),
      )
    ),
  );
}
