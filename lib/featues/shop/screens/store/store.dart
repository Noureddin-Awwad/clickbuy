// File: lib/featues/shop/screens/store/store.dart

import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/appbar/tabbar.dart';
import 'package:e_commerce/common/widgets/custom_shapes/container/search_containers.dart';
import 'package:e_commerce/common/widgets/layouts/grid_layout.dart';
import 'package:e_commerce/common/widgets/product_cart/cart_menu_icon.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/shop/controllers/category_cotroller.dart';
import 'package:e_commerce/featues/shop/screens/brand/all_brands.dart';
import 'package:e_commerce/featues/shop/screens/brand/brand_products.dart';
import 'package:e_commerce/featues/shop/screens/store/widgets/brand_card.dart';
import 'package:e_commerce/featues/shop/screens/store/widgets/category_tab.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/shimmer/brands_shimmer.dart';
import '../../controllers/product/brand_controller.dart'; // Ensure this import is correct

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: Get the BrandController instance using Get.find()
    // The BrandController should be put elsewhere in the app's lifecycle
    // where its dependencies (repositories) are available.
    final brandController = Get.find<BrandController>();

    // Get the CategoryController instance using Get.find()
    final categoryController = Get.find<CategoryController>();
    final categories = categoryController.featuredCategories;


    return DefaultTabController(
      length: categories.length,
      child: Scaffold(
        appBar: NAppBar(
          title: Text('Store', style: Theme.of(context).textTheme.headlineMedium,),
          actions: [
            NCartCounterIcon(onPressed: (){},)
          ],
        ),
        body: NestedScrollView(headerSliverBuilder: (_,innerBoxIsScrolled){
          return [
            SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: NHelperFumctions.isDarkMode(context)? NColors.black : NColors.white,
                expandedHeight: 440,

                flexibleSpace: Padding(
                  padding: const EdgeInsets.all(NSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const  NeverScrollableScrollPhysics(),
                    children: [
                      /// Search bar
                      SizedBox(height: NSizes.spaceBtwItems,),
                      NSearchContainer(text: 'Search in Store' , showBorder: true,showBackground: false,padding: EdgeInsets.zero,),
                      SizedBox(height: NSizes.spaceBtwSections,),

                      /// Featured Brands
                      NSectionHeading(title: 'Featured Brands' , onPressed: () => Get.to(()=> AllBrandsScreen()),),
                      SizedBox(height: NSizes.spaceBtwItems / 1.5,),

                      Obx(
                              (){
                            if(brandController.isLoading.value) return NBrandsShimmer();

                            if (brandController.featuredBrands.isEmpty){
                              // Consider adding a check for error message too

                                return Center(
                                  child: Text(
                                    'No Data Found!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(color: Theme.of(context).textTheme.bodyMedium!.color),
                                  ),
                                );

                            }

                            return NGridLayout(
                                mainAxisExtent: 80,
                                itemCount: brandController.featuredBrands.length,
                                itemBuilder: (_,index){
                                  final brand = brandController.featuredBrands[index];

                                  return NBrandCard(showBorder: true, brand: brand,onTap: ()=> Get.to(()=> BrandProducts(brand: brand,)),);
                                }
                            );
                          }
                      ),

                    ],
                  ),
                ),

                /// Tabs
                // Access categories from the retrieved controller instance
                bottom: NTabBar(tabs: categories.map((category) => Tab(child: Text(category.name))).toList(),)
            ),
          ];
        },
          // Access categories from the retrieved controller instance
          body: TabBarView(
              children: categories.map((category) => NCategoryTab(category: category,)).toList()),),
      ),
    );
  }
}