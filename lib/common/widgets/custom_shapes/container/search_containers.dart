
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/device/device_utility.dart';
import '../../../../utils/helpers/helper_functions.dart';

class NSearchContainer extends StatelessWidget {
  const NSearchContainer({
    super.key,
    required this.text,
    this.icon=Iconsax.search_normal,
    this.showBackground=true,
    this.showBorder = true,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: NSizes.defaultSpace),
    this.width ,

  });

  final double? width;
  final String text;
  final IconData? icon ;
  final bool showBackground , showBorder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding ,
        child: Container(
          width: width,
          padding: EdgeInsets.all(NSizes.md),
          decoration: BoxDecoration(
            color: showBackground ? dark ? NColors.dark : NColors.light : Colors.transparent,
            borderRadius: BorderRadius.circular(NSizes.cardRadiusLg),
            border: showBorder ? Border.all(color: NColors.grey,): null,
          ),
          child: Row(
            children: [
              Icon(icon,color: NColors.darkGrey,),
              const SizedBox(width: NSizes.spaceBtwItems,),
              Text(text,style: Theme.of(context).textTheme.bodySmall,)

            ],
          ),
        ),
      ),
    );
  }
}