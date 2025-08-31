import 'package:e_commerce/common/widgets/images/n_circular_image.dart';
import 'package:flutter/material.dart';

import '../../../featues/shop/models/category_model.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';

class NVerticalImageText extends StatelessWidget {
  const NVerticalImageText({
    super.key,
    required this.image,
    required this.title,
    required this.imageType,
    this.textColor = NColors.white,
    this.backgroundColor ,
    this.onTap,
  });

  final String image,title;
  final ImageSourceType imageType;
  final Color textColor;
  final Color? backgroundColor;
  final void Function()? onTap;

  bool get isNetworkImage => imageType == ImageSourceType.network;

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(right: NSizes.spaceBtwItems),
        child: Column(
          children: [
            /// Circular Icon
            NCircularImage(
              image: image,
              fit: BoxFit.fitWidth,
              padding: NSizes.sm * 1.4,
              isNetworkImage: isNetworkImage,
              backgroundColor: backgroundColor,
              overlayColor: NHelperFumctions.isDarkMode(context) ? NColors.light:NColors.dark,
            ),

            /// Text
            const SizedBox(height: NSizes.spaceBtwItems / 2,),
            SizedBox(width: 55 ,
              child: Text(
                title,
                style: Theme.of(context).textTheme.labelMedium!.apply(color: textColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),)
          ],
        ),
      ),
    );
  }
}