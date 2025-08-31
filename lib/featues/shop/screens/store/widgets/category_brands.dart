import 'package:e_commerce/featues/shop/models/category_model.dart';
import 'package:e_commerce/featues/shop/screens/store/widgets/brand_showcase.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/shimmer/boxes_shimmer.dart';
import '../../../../../common/widgets/shimmer/list_tile_shimmer.dart';
import '../../../controllers/product/brand_controller.dart';

class CategoryBrands extends StatelessWidget {
  const CategoryBrands({super.key, required this.category});

  final CategoryModel category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BrandController>();
    return FutureBuilder(
        future: controller.getBrandsForCategory(category.id),
        builder: (context, snapshot) {

          /// Handle loader , No record , or Error Message
          const loader = Column(
            children: [
              NListTileShimmer(),
              SizedBox(height: NSizes.spaceBtwItems),
              NBoxesShimmer(),
              SizedBox(height: NSizes.spaceBtwItems,)
            ],
          );

          final widget = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
          if(widget != null) return widget;


          /// Record Found!
          final brands = snapshot.data!;


          return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: brands.length,
              itemBuilder: (_, index) {
                final brand = brands[index];
                return FutureBuilder(
                    future: controller.getBrandProducts(brandId: brand.id, limit: 3),
                    builder: (context, snapshot) {

                      /// Handle Loader , No Record , or Error Message
                      final widget = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot,loader: loader);
                      if(widget != null) return widget;

                      /// Record Found!
                      final products = snapshot.data!;

                      return NBrandShowcase(brand: brand,images: products.map((e)=> e.thumbnail).toList());
                    }
                    );
              },
          );
        }
    );
  }
}
