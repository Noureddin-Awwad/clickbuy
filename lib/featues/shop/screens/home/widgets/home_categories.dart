import 'package:e_commerce/featues/shop/controllers/category_cotroller.dart';
import 'package:e_commerce/featues/shop/screens/sub_category/sub_category.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/image_text_widgets/vertical_image_text.dart';
import '../../../../../common/widgets/shimmer/category_shimmer.dart';
import '../../../models/category_model.dart';
import 'category_product_screen.dart';

class NHomeCategories extends StatelessWidget {
  const NHomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.find<CategoryController>();

    return Obx(() {
      if (categoryController.isLoading.value) return NCategoryShimmer();

      if (categoryController.featuredCategories.isEmpty) {
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
      return SizedBox(
        height: 80,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: categoryController.featuredCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {

              final category = categoryController.featuredCategories[index];
              return NVerticalImageText(
                image: category.image,
                title: category.name,
                imageType: category.imageType,
                onTap: () =>
                    Get.to(() => CategoryProductsScreen(
                      title: category.name, // Pass the category name
                      categoryId: category.id, // Pass the category ID
                    )),
              );
            }),
      );
    });
  }
}
