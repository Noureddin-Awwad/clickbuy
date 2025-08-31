import 'package:e_commerce/utils/constants/enums.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import 'brand_title_text.dart';

class NBrandTitleTextWithVerificationIcon extends StatelessWidget {
  const NBrandTitleTextWithVerificationIcon({
    super.key,
    required this.title,
    this.maxLines =1,
    this.textColor,
    this.iconColor =NColors.primary,
    this.textAlign =TextAlign.center,
    this.brandTextSize = TextSizes.small,
  });

  final String title;
  final int maxLines;
  final Color? textColor , iconColor;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: NBrandTitleText(
        title : title,
        color: textColor,
        maxLines : maxLines,
        textAlign: textAlign,
        brandTextSize : brandTextSize,
          ),
        ),
        SizedBox(width: NSizes.xs),
        Icon(Iconsax.verify5, color: iconColor, size: NSizes.iconXs,),
      ],
    );
  }
}
