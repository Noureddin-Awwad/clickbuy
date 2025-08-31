import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NBoxesShimmer extends StatelessWidget {
  const NBoxesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          children: [
            Expanded(child: NShimmerEffect(width: 150, height: 110)),
            SizedBox(width: NSizes.spaceBtwItems,),
            Expanded(child: NShimmerEffect(width: 150, height: 110)),
            SizedBox(width: NSizes.spaceBtwItems,),
            Expanded(child: NShimmerEffect(width: 150, height: 110)),
          ],
        )
      ],
    );
  }
}
