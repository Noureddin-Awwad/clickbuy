

import 'package:e_commerce/common/widgets/layouts/grid_layout.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NVerticalProductShimmer extends StatelessWidget {
  const NVerticalProductShimmer({super.key, this.itemCount =4});

  final int itemCount;


  @override
  Widget build(BuildContext context) {
    return NGridLayout(
        itemCount: itemCount,
        itemBuilder: (_,__) => SizedBox(
          width: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image
              NShimmerEffect(width: 180, height: 180),
              SizedBox(height: NSizes.spaceBtwItems,),

              /// Text
              NShimmerEffect(width: 160, height: 15),
              SizedBox(height: NSizes.spaceBtwItems / 2,),
              NShimmerEffect(width: 110, height: 15),
            ],
          ),
        )
    );
  }
}
