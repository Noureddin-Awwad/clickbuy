import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts_strings.dart';

class NLoginHeader extends StatelessWidget {
  const NLoginHeader({
    super.key,
    required this.dark,
  });

  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image(
          height: 200,
          image: AssetImage(dark ? NImage.lightAppLogo : NImage.darkAppLogo),
        ),
        Text(NTexts.loginTitle,style: Theme.of(context).textTheme.headlineMedium, ),
        const SizedBox(height: NSizes.sm,),
        Text(NTexts.loginSubTitle,style: Theme.of(context).textTheme.bodyMedium, ),
        const SizedBox(height: NSizes.spaceBtwSections,),
      ],
    );
  }
}