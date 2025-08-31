import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/featues/shop/controllers/banner_controller.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/widgets/custom_shapes/container/circular_container.dart';
import '../../../../../common/widgets/images/n_rounded_image.dart';
import '../../../../../utils/constants/sizes.dart';

class NPromoSlider extends StatelessWidget {
  const NPromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BannerController());

    return Obx(
        () {
          // Loader
          if (controller.isLoading.value) return NShimmerEffect(width: double.infinity, height: 190);

          // No data found
          if (controller.banners.isEmpty){
            return Center(child: Text('No Data Found!'));
          }else{
            return Column(
              children: [
                CarouselSlider(
                    options: CarouselOptions(
                        viewportFraction: 1,
                        autoPlay: false,
                        onPageChanged: (index, _) =>
                            controller.updatePageIndicator(index)),
                    items: controller.banners
                        .map((banner) => NRoundedImage(
                      imageUrl:  banner.imageUrl,
                      isNetworkImage: true,
                      onPressed: () =>Get.toNamed(banner.targetScreen),
                    ))
                        .toList()),
                const SizedBox(
                  height: NSizes.spaceBtwItems,
                ),
                Obx(
                      () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < controller.banners.length; i++)
                        NCircularContainer(
                          width: 20,
                          height: 4,
                          margin: EdgeInsets.only(right: 10),
                          backgroundColor: controller.carousalCurrentIndex.value == i
                              ? NColors.primary
                              : NColors.grey,
                        ),
                    ],
                  ),
                )
              ],
            );
          }
        }
    );
  }
}
