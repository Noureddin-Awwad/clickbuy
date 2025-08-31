// File: lib/featues/shop/screens/sub_category/sub_category.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/images/n_rounded_image.dart';
import 'package:e_commerce/common/widgets/products/product_cards/product_card_horizontal.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/shop/controllers/category_cotroller.dart';
import 'package:e_commerce/featues/shop/models/category_model.dart';
import 'package:e_commerce/featues/shop/screens/all_products/all_products.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/shimmer/horizontal_product_shimmer.dart';
import '../../models/product_model.dart';

class SubCategoriesScreen extends StatelessWidget {
  const SubCategoriesScreen({super.key, required this.category});

  final CategoryModel category ;

  @override
  Widget build(BuildContext context) {
    // FIX 1: Get the CategoryController instance using Get.find()
    final controller = Get.find<CategoryController>();

    return Scaffold(
        appBar: NAppBar(
          showBackArrow: true,
          title: Text(category.name),
        ),
        body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(NSizes.defaultSpace),
    child: Column(
    children: [
    ///Banner
    NRoundedImage(
    imageUrl: NImage.promoBanner3,
    applyImageRadius: true,
    width: double.infinity,
    ),

    SizedBox(
    height: NSizes.spaceBtwSections,
    ),

    /// Sub Categories
    // FIX 2: Specify the expected type for the outer FutureBuilder
    FutureBuilder<List<CategoryModel>>(
    future: controller.getSubCategories(category.id),
    builder: (context, snapshot){

    /// Handle Loader , No Record,  Or Error Message
    const loader = NHorizontalProductShimmer();
    // checkMultiRecordState now receives AsyncSnapshot<List<CategoryModel>>
    final widget = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
    if (widget != null) return widget;

    /// Record Found
    // snapshot.data! is now correctly typed as List<CategoryModel>
    final subCategories = snapshot.data! ;

    return ListView.builder(
    shrinkWrap: true,
    itemCount: subCategories.length, // length is now defined
    physics:  NeverScrollableScrollPhysics(),
    itemBuilder: (_, index){

    final subCategory = subCategories[index]; // [] is now defined

    // FIX 5: Specify the expected type for the inner FutureBuilder
    return FutureBuilder<List<ProductModel>>(
    future: controller.getCategoryProducts(categoryId: subCategory.id),
    builder: (context , snapshot){

    /// Handle Loader , No Record,  Or Error Message
    // checkMultiRecordState now receives AsyncSnapshot<List<ProductModel>>
    final widget = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
    if (widget != null) return widget;

    /// Record Found
    // snapshot.data! is now correctly typed as List<ProductModel>
    final products = snapshot.data! ;

    return Column(
    children: [
    /// Heading
    NSectionHeading(
    title: subCategory.name,
    onPressed: () => Get.to(
    () => AllProducts(
    title: subCategory.name ,
    // This futureMethod might need adjustment later
    // as part of making AllProducts data source independent.
      query: FirebaseFirestore.instance.collection('Products').where('CategoryId', isEqualTo: subCategory.id),
    )
    ),
    ),
    SizedBox(
    height: NSizes.spaceBtwItems / 2,
    ),

    ///Products
      SizedBox(
        height: 120,
        child: ListView.separated(
            itemCount: products.length, // length is now defined
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context,index) => SizedBox(width: NSizes.spaceBtwItems,),
            itemBuilder: (context, index) => NProductCardHorizontal(product: products[index]) // [] is now defined
        ),
      ),
    ],
    );
    },

    );
    }
    );
    }
    )
    ],
    ),
        ),
        ),
    );
  }
}