import 'package:e_commerce/featues/shop/models/brand_model.dart';
import 'package:flutter/material.dart';

import '../../../../../common/styles/rounded_container.dart';
import '../../../../../common/widgets/images/n_circular_image.dart';
import '../../../../../common/widgets/texts/brand_title_text_with_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/enums.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class NBrandCard extends StatelessWidget {
  const NBrandCard({
    super.key, required this.showBorder, this.onTap, required this.brand,
  });

  final BrandModel brand;
  final bool showBorder;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: NRoundedContainer(
        padding: const EdgeInsets.all(NSizes.sm),
        showBorder: showBorder,
        backgroundColor: Colors.transparent,
        child: Row(
          children: [
            /// Icon
            Flexible(
              child: NCircularImage(
                image: brand.image,
                isNetworkImage: true,
                backgroundColor: Colors.transparent,
                overlayColor: NHelperFumctions.isDarkMode(context) ? NColors.white : NColors.black,
              ),
            ),

            const SizedBox(width: NSizes.spaceBtwItems / 2),

            /// Text
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    NBrandTitleTextWithVerificationIcon(title: brand.name, brandTextSize: TextSizes.large,),
                  Text(
                    '${brand.productsCount ?? 0} products',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}