import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NHorizontalProductShimmer extends StatelessWidget {
  const NHorizontalProductShimmer({super.key,  this.itemCount=4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: NSizes.spaceBtwSections),
      height: 120,
      child: ListView.separated(
        itemCount: itemCount,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          separatorBuilder: (context , index) => SizedBox(width: NSizes.spaceBtwItems,),
        itemBuilder: (_,__) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ///Image
            NShimmerEffect(width: 120, height: 120),
            SizedBox(width: NSizes.spaceBtwItems,),

            ///Text
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: NSizes.spaceBtwItems / 2,),
                NShimmerEffect(width: 160, height: 15),
                SizedBox(height: NSizes.spaceBtwItems / 2,),
                NShimmerEffect(width: 110, height: 15),
                SizedBox(height: NSizes.spaceBtwItems / 2,),
                NShimmerEffect(width: 80, height: 15),
                Spacer(),
              ],
            )
          ],
        ),
      ),
    );
  }
}
