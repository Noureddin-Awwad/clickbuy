import 'package:e_commerce/common/widgets/layouts/grid_layout.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:flutter/material.dart';

class NBrandsShimmer extends StatelessWidget {
  const NBrandsShimmer({super.key,  this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return NGridLayout(itemCount: itemCount, itemBuilder: (_,__) => NShimmerEffect(width: 300, height: 80));
  }
}
