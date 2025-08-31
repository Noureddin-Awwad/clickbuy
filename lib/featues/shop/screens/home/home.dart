
import 'package:e_commerce/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:e_commerce/featues/shop/screens/all_products/all_products.dart';
import 'package:e_commerce/featues/shop/screens/home/widgets/home_appbar.dart';
import 'package:e_commerce/featues/shop/screens/home/widgets/home_categories.dart';
import 'package:e_commerce/featues/shop/screens/home/widgets/image_upload_controller.dart';
import 'package:e_commerce/featues/shop/screens/home/widgets/promo_slider.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../common/widgets/custom_shapes/container/primary_header_container.dart';
import '../../../../common/widgets/custom_shapes/container/search_containers.dart';
import '../../../../common/widgets/layouts/grid_layout.dart';
import '../../../../common/widgets/shimmer/vertical_product_shimmer.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../controllers/product/product_controller.dart';
import '../result_screen/result_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Get the ProductController instance using Get.find()
    final controller = Get.find<ProductController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Header
            NPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// AppBar
                  NHomeAppBar(),

                  const SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),

                  /// Searchbar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          NSearchContainer(
                            text: 'Search in Store',
                            width: 250,
                            padding: EdgeInsets.only(left: NSizes.defaultSpace),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: NSizes.spaceBtwItems,
                      ),
                      /// Camera Icon for AI Search
                      Column(
                        children: [
                          IconButton(
                            onPressed: () async {
                              final imageFile = await ImageUploadController().pickImageFromGallery();
                              if (imageFile != null) {
                                Get.to(() => ResultScreen(imageFile: imageFile));
                              }
                            },
                            icon: Icon(Iconsax.camera, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: NSizes.spaceBtwItems,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),

                  /// Heading Categories
                  Padding(
                    padding: EdgeInsets.only(left: NSizes.defaultSpace),
                    child: Column(
                      children: [
                        NSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        const SizedBox(
                          height: NSizes.spaceBtwItems,
                        ),

                        /// Categories
                        NHomeCategories(),
                        const SizedBox(
                          height: NSizes.spaceBtwSections,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            /// Body

            Padding(
              padding: const EdgeInsets.all(NSizes.defaultSpace),
              child: Column(
                children: [
                  /// Promo Slider
                  NPromoSlider(),
                  SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),

                  /// Product Heading
                  NSectionHeading(
                    title: 'Popular Products',
                    onPressed: () => Get.to(() => AllProducts(
                      title: 'Popular Products',
                      query: null
                    )),
                    buttonTitle: 'View all',
                  ),
                  SizedBox(
                    height: NSizes.spaceBtwItems,
                  ),

                  /// Popular Products
                  Obx(() {
                    if (controller.isLoading.value) {
                      return NVerticalProductShimmer();
                    }
                    if (controller.featuredProducts.isEmpty) {
                      return Center(
                          child: Text(
                            'No Products Found',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ));
                    }
                    return NGridLayout(
                      itemCount: controller.featuredProducts.length,
                      itemBuilder: (_, index) => NProductCardVertical( product: controller.featuredProducts[index]),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}