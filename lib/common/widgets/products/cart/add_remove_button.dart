import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../icons/n_circular_icon.dart';

class NProductQntWithAddRemove extends StatelessWidget {
  const NProductQntWithAddRemove({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NCircularIcon(
          icon: Iconsax.minus,
          width: 32,
          height: 32,
          size: NSizes.md,
          color: NHelperFumctions.isDarkMode(context)
              ? NColors.white
              : NColors.black,
          backgroundColor: NHelperFumctions.isDarkMode(context)
              ? NColors.darkerGrey
              : NColors.light,
        ),
        SizedBox(width: NSizes.spaceBtwItems,),
        Text('2',style: Theme.of(context).textTheme.titleSmall,),
        SizedBox(width: NSizes.spaceBtwItems,),
        NCircularIcon(
          icon: Iconsax.add,
          width: 32,
          height: 32,
          size: NSizes.md,
          color: NColors.white,
          backgroundColor: NColors.primary,
        ),
      ],
    );
  }
}
