import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NCategoryShimmer extends StatelessWidget {
  const NCategoryShimmer({super.key,  this.itemCount=6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
          itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (_,__) => SizedBox(width: NSizes.spaceBtwItems,),
        itemBuilder: (_,__){
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Image
                NShimmerEffect(width: 55, height: 55, radius: 55,),
                SizedBox(height: NSizes.spaceBtwItems/2,),

                /// Text
                NShimmerEffect(width: 55,height: 8,),
              ],
            );
        },

      ),
    );
  }
}
