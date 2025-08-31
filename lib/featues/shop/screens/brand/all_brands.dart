import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/layouts/grid_layout.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:e_commerce/featues/shop/screens/brand/brand_products.dart';
import 'package:e_commerce/featues/shop/screens/store/widgets/brand_card.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/shimmer/brands_shimmer.dart';
import '../../controllers/product/brand_controller.dart';

class AllBrandsScreen extends StatelessWidget {
  const AllBrandsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Remove Get.find() from the top level build method
    // final brandController = Get.find<BrandController>(); // REMOVE

    return Scaffold(
      appBar: NAppBar(
        title: Text('Brand'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            children: [
              ///Heading
              NSectionHeading(
                title: 'Brands',
                showActionButton: false,
              ),
              SizedBox(
                height: NSizes.spaceBtwItems,
              ),

              ///Brands
              // Use GetBuilder to ensure BrandController is available before building the brands list
              GetBuilder<BrandController>(
                init: Get.find<BrandController>(), // Initialize GetBuilder by finding the controller
                builder: (brandController) {
                  // This builder only runs once the BrandController is successfully found.
                  // Use an Obx here to react to the observable state within the controller
                  return Obx(() {
                    if (brandController.isLoading.value) return NBrandsShimmer();

                    if (brandController.allBrands.isEmpty) {
                      return Center(
                        child: Text(
                          'No Data Found!',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .apply(color: Colors.white),
                        ),
                      );
                    }

                    return NGridLayout(
                      mainAxisExtent: 80,
                      itemCount: brandController.allBrands.length,
                      itemBuilder: (_, index) {
                        final brand = brandController.allBrands[index];

                        return NBrandCard(
                          showBorder: true,
                          brand: brand,
                          onTap: () => Get.to(() => BrandProducts(brand: brand)),
                        );
                      },
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}