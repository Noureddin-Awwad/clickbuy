import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/products/sortable/sortable_products.dart';
import 'package:e_commerce/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:e_commerce/featues/shop/screens/store/widgets/brand_card.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/product/brand_controller.dart';

class BrandProducts extends StatelessWidget {
  const BrandProducts({super.key, required this.brand});

  final BrandModel brand;

  @override
  Widget build(BuildContext context) {
    // Do NOT call Get.find() directly here.
    // final controller = Get.find<BrandController>(); // REMOVE

    return Scaffold(
      appBar: NAppBar(title: Text(brand.name)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            children: [
              ///Brand Details
              NBrandCard(showBorder: true, brand: brand),
              SizedBox(height: NSizes.spaceBtwSections),

              // Wrap the FutureBuilder in a GetBuilder to ensure BrandController is available
              GetBuilder<BrandController>(
                init: Get.find<BrandController>(), // Initialize GetBuilder with the controller instance
                builder: (controller) {
                  // This builder will only run once the BrandController is found.
                  // 'controller' here is the instance of BrandController.
                  print('BrandProducts Debug: BrandController available in GetBuilder.');

                  return FutureBuilder(
                    future: controller.getBrandProducts(brandId: brand.id),
                    builder: (context, snapshot) {
                      /// Handle Loader , No Record , Or Error Message
                      const loader = NVerticalProductShimmer();
                      final widget = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot, loader: loader);
                      if (widget != null) return widget;

                      /// Record Found
                      final brandProducts = snapshot.data!;
                      return NSortableProducts(products: brandProducts);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}