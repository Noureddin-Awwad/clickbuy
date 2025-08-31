import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/helpers/helper_functions.dart';

class NBillingPaymentSection extends StatelessWidget {
  const NBillingPaymentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return Column(
      children: [
        NSectionHeading(title: 'Payment Method',buttonTitle: 'Change', onPressed: (){},),
        SizedBox(height: NSizes.spaceBtwItems/2,),
        Row(
          children: [
            NRoundedContainer(
              width: 60,
              height: 35,
              backgroundColor: dark ? NColors.light : NColors.white,
              padding: EdgeInsets.all(NSizes.sm),
              child: Image(image: AssetImage(NImage.paypal),fit: BoxFit.contain,),
            ),

            SizedBox(width: NSizes.spaceBtwItems/2,),
            Text('Paypal', style: Theme.of(context).textTheme.bodyLarge,),
          ],
        )
      ],
    );
  }
}
