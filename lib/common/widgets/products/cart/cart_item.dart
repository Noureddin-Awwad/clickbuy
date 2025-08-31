import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../images/n_rounded_image.dart';
import '../../texts/brand_title_text_with_icon.dart';
import '../../texts/product_title_text.dart';


class NCartItem extends StatelessWidget {
  const NCartItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NRoundedImage(
          imageUrl: NImage.productImage1,
          width: 60,
          height: 60,
          padding: EdgeInsets.all(NSizes.sm),
          backgroundColor: NHelperFumctions.isDarkMode(context) ? NColors.darkerGrey : NColors.light,
        ),
        SizedBox(width: NSizes.spaceBtwItems,),


        /// Title, Price, Size
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NBrandTitleTextWithVerificationIcon(title: 'Nike'),
              Flexible(child: NProductTitleText(title: 'Black Sports Shoes', maxLines: 1,)),
              /// Atribute
              Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(text: 'Color ' , style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(text: 'Green ' , style: Theme.of(context).textTheme.bodyLarge),
                        TextSpan(text: 'Size ' , style: Theme.of(context).textTheme.bodySmall),
                        TextSpan(text: 'Uk 08' , style: Theme.of(context).textTheme.bodyLarge),
                      ]
                  )
              )
            ],
          ),
        )
      ],
    );
  }
}
