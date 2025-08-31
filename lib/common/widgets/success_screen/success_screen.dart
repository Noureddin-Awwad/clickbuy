import 'package:e_commerce/common/styles/spacing_styles.dart';

import 'package:flutter/material.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/texts_strings.dart';
import '../../../utils/helpers/helper_functions.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key, required this.image, required this.title, required this.subtitle, required this.onPressed});

  final String image,title,subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: NSpacingStyle.paddingWithAppBarHeight * 2,
        child: Column(
          children: [
            /// Image
            Image(image: AssetImage(image),width: NHelperFumctions.screenWidth() * 0.6,),
            const SizedBox(height: NSizes.spaceBtwSections,),

            /// Title &Subtitle
            Text(title, style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
            const SizedBox(height: NSizes.spaceBtwItems,),
            Text(subtitle, style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
            const SizedBox(height: NSizes.spaceBtwSections,),


            /// Buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onPressed,
                  child: const Text(NTexts.nContinue)),),
          ],
        )
      ),),
    );
  }
}
