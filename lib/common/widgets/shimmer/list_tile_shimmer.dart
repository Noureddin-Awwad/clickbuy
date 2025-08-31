import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NListTileShimmer extends StatelessWidget {
  const NListTileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            NShimmerEffect(width: 50, height: 50,radius: 50,),
            SizedBox(width: NSizes.spaceBtwItems,),
            Column(children: [
              NShimmerEffect(width: 100, height: 15),
              SizedBox(height: NSizes.spaceBtwItems /2,),
              NShimmerEffect(width: 80, height: 12),
            ],)
          ],
        )
      ],
    );
  }
}
