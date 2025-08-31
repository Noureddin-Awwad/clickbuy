// File: lib/featues/shop/screens/store/widgets/category_tab.dart

import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore
import 'package:e_commerce/common/widgets/layouts/grid_layout.dart';
import 'package:e_commerce/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:e_commerce/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/shop/controllers/category_cotroller.dart';
import 'package:e_commerce/featues/shop/models/category_model.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/featues/shop/screens/all_products/all_products.dart';
import 'package:e_commerce/featues/shop/screens/store/widgets/brand_showcase.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/helpers/cloud_helper_functions.dart';
import 'category_brands.dart';

class NCategoryTab extends StatelessWidget {
  const NCategoryTab({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    // FIX 1: Get the CategoryController instance using Get.find()
    final controller = Get.find<CategoryController>();

    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            children: [
              /// Brands
              CategoryBrands(category: category,),
              SizedBox(height: NSizes.spaceBtwItems,),


              /// Products
              // FIX 2: Specify the expected type for FutureBuilder
              FutureBuilder<List<ProductModel>>(
                  future: controller.getCategoryProducts(categoryId: category.id),
                  builder: (context, snapshot) {

                    /// Handle Loader , No Record , or Error Message
                    // Now checkMultiRecordState receives AsyncSnapshot<List<ProductModel>>
                    final response = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: NVerticalProductShimmer());
                    if(response != null) return response;

                    /// Record Found!
                    // FIX 3 & 4: snapshot.data! is now correctly typed as List<ProductModel>
                    final products = snapshot.data!;

                    return  Column(
                      children: [
                        NSectionHeading(title: 'You might like',
                          onPressed: () => Get.to(
                            AllProducts(
                              title: category.name,
                              // FIX: Pass the category ID using the new categoryId parameter
                              categoryId: category.id,
                              // Pass null for the query since we are now using categoryId
                              query: null,
                            ),
                          ),
                          buttonTitle: 'View all',
                        ),
                        SizedBox(height: NSizes.spaceBtwItems,),
                        // Now products.length and products[index] are valid
                        NGridLayout(itemCount: products.length, itemBuilder: (_,index) => NProductCardVertical(product: products[index]))
                      ],
                    );
                  }
              ),

            ],
          ),
        ),
      ],);
  }
}