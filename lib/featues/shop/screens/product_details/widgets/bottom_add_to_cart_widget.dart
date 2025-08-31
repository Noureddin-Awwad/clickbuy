import 'package:e_commerce/common/widgets/icons/n_circular_icon.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/helpers/helper_functions.dart';

class NBottomAddToCart extends StatelessWidget {
  const NBottomAddToCart({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: NSizes.defaultSpace,vertical: NSizes.defaultSpace/2),
      decoration: BoxDecoration(
        color: dark? NColors.darkerGrey : NColors.light,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(NSizes.cardRadiusLg),
          topRight: Radius.circular(NSizes.cardRadiusLg),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              NCircularIcon(
                  icon: Iconsax.minus,
                backgroundColor: dark? NColors.white : NColors.darkerGrey,
                width: 40,
                height: 40,
                color: dark? NColors.black : NColors.white,
              ),
              SizedBox(width: NSizes.spaceBtwItems,),
              Text('2',style: Theme.of(context).textTheme.titleSmall,),
              SizedBox(width: NSizes.spaceBtwItems,),
              NCircularIcon(
                icon: Iconsax.add,
                backgroundColor: dark? NColors.black : NColors.black,
                width: 40,
                height: 40,
                color: dark? NColors.white : NColors.white,
              ),
            ],
          ),
          ElevatedButton(
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(NSizes.md),
                backgroundColor: NColors.black,
                side: BorderSide(color: NColors.black),
              ),
              child: Text('Add to Cart'),
          )
        ],
      ),
    );
  }
}
