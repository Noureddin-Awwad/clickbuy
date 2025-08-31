import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/shop/screens/product_details/widgets/bottom_add_to_cart_widget.dart';
import 'package:e_commerce/featues/shop/screens/product_details/widgets/product_attributes.dart';
import 'package:e_commerce/featues/shop/screens/product_details/widgets/product_detail_image_slider.dart';
import 'package:e_commerce/featues/shop/screens/product_details/widgets/product_meta_data.dart';
import 'package:e_commerce/featues/shop/screens/product_details/widgets/rating_and_share.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:readmore/readmore.dart';

import '../../../../utils/constants/enums.dart';
import '../../models/product_model.dart';
import '../product_reviews/product_reviews.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key,required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NBottomAddToCart(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Product Image Slider
            NProductImageSlider(product: product),


            /// Product Details
            Padding(
                padding: EdgeInsets.only(right: NSizes.defaultSpace,left: NSizes.defaultSpace,bottom: NSizes.defaultSpace),
              child: Column(
                children: [
                  /// Rating and Share
                  NRatingAndShare(),
                  /// Price , Title , Stock and Brand
                  NProductMetaData(product: product,),
                  /// Attributes
                  if(product.productType == ProductType.variable.toString())
                  NProductAttributes(product: product,),
                  if(product.productType == ProductType.variable.toString())
                  SizedBox(height: NSizes.spaceBtwSections,),
                  /// Checkout Button
                  SizedBox(width: double.infinity,child: ElevatedButton(onPressed: (){}, child: Text('Checkout'))),
                  SizedBox(height: NSizes.spaceBtwSections,),

                  /// Description
                  NSectionHeading(title: 'Description',showActionButton: false,),
                  SizedBox(height: NSizes.spaceBtwItems,),
                  ReadMoreText(
                    product.description ?? '',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: ' Show more ',
                    trimExpandedText: ' Less ',
                    moreStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),
                    lessStyle: TextStyle(fontSize: 14,fontWeight: FontWeight.w800),
                  ),
                  /// Reviews
                  Divider(),
                  SizedBox(height: NSizes.spaceBtwItems,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NSectionHeading(title: 'Reviews(199)', showActionButton: false,),
                      IconButton(onPressed: () => Get.to(() => ProductReviewsScreen()), icon: Icon(Iconsax.arrow_right_3,size: 18,)),
                    ],
                  ),
                  SizedBox(height: NSizes.spaceBtwSections,)
                ],
              ),
            )

          ],
        ),
      ),
    );
  }
}



