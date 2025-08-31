import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class NOrderListItems extends StatelessWidget {
  const NOrderListItems({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return ListView.separated(
      shrinkWrap: true,
      itemCount: 10,
      separatorBuilder: (_,__) => SizedBox(height: NSizes.spaceBtwItems,),
      itemBuilder:(_,index) => NRoundedContainer(
        padding: EdgeInsets.all(NSizes.md),
        showBorder: true,
        backgroundColor: dark ? NColors.dark : NColors.light,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Row 1
            Row(
              children: [
                /// icon
                Icon(Iconsax.ship),
                SizedBox(
                  width: NSizes.spaceBtwItems / 2,
                ),

                /// Status & Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize:MainAxisSize.min ,
                    children: [
                      Text(
                        'Processing',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .apply(color: NColors.primary, fontWeightDelta: 1),
                      ),
                      Text('07 Nov 2025', style: Theme.of(context).textTheme.headlineSmall,),
                    ],
                  ),
                ),

                /// Icon
                IconButton(onPressed: (){}, icon: Icon(Iconsax.arrow_right_34,size: NSizes.md)),
              ],
            ),
            SizedBox(height: NSizes.spaceBtwItems/2,),

            ///Row 2
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      /// icon
                      Icon(Iconsax.tag),
                      SizedBox(
                        width: NSizes.spaceBtwItems / 2,
                      ),

                      /// Status & Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:MainAxisSize.min ,
                          children: [
                            Text(
                              'Order',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(color: NColors.primary, fontWeightDelta: 1),
                            ),
                            Text('[#256f2]', style: Theme.of(context).textTheme.titleMedium,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      /// icon
                      Icon(Iconsax.calendar),
                      SizedBox(
                        width: NSizes.spaceBtwItems / 2,
                      ),

                      /// Status & Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize:MainAxisSize.min ,
                          children: [
                            Text(
                              'Shipping Date',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(color: NColors.primary, fontWeightDelta: 1),
                            ),
                            Text('03 Feb 2025]', style: Theme.of(context).textTheme.titleMedium,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
