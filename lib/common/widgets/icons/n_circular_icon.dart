import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class NCircularIcon extends StatelessWidget {
  /// A custom circular shape with an icon
  /// Properties are :
  /// width , height , background , Icon's size color onPressed ,

  const NCircularIcon({
    super.key,
    this.width,
    this.height,
    this.size,
    required this.icon,
    this.color,
    this.backgroundColor,
    this.onPressed,

  });

  final double? width ,height ,size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onPressed;



  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: backgroundColor != null
          ? backgroundColor !
        : dark? NColors.black.withOpacity(0.9) : NColors.white.withOpacity(0.9),
      ),
      child: IconButton(onPressed: onPressed, icon: Icon(icon , color: color, size: size,)),
    );
  }
}