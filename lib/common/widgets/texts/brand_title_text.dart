import 'package:flutter/material.dart';
import '../../../utils/constants/enums.dart';

class NBrandTitleText extends StatelessWidget {
  const NBrandTitleText({
    super.key,
    required this.title,
    this.color,
    this.maxLines =1,
    this.textAlign = TextAlign.center,
    this.brandTextSize = TextSizes.small,

  });
  final String title;
  final Color? color;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;


  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      overflow: TextOverflow.ellipsis ,
      maxLines: maxLines,
      // Check which brandSize is required and set that style.
      style: brandTextSize==TextSizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color:color)
          : brandTextSize == TextSizes.medium
          ?Theme.of(context).textTheme.bodyLarge!.apply(color: color)
          :brandTextSize == TextSizes.large
          ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
          : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
    );
  }
}