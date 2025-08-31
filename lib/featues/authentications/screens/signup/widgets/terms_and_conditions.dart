import 'package:e_commerce/featues/authentications/controllers/signup/signup_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class NTermsAndConditions extends StatelessWidget {
  const NTermsAndConditions({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    final controller = SignupController.instance;
    final dark = NHelperFumctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
            width: 24,
            height: 24,
            child: Obx(() => Checkbox(value: controller.privacyPolicy.value,
                onChanged: (value) => controller.privacyPolicy.value = !controller.privacyPolicy.value))),
        const SizedBox(width: NSizes.spaceBtwItems,),
        Text.rich(
          TextSpan(
              children: [
                TextSpan(text: '${NTexts.iAgreeTo} ',style: Theme.of(context).textTheme.bodySmall),
                TextSpan(text: NTexts.privacyPolicy,style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark? NColors.white : NColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark ? NColors.white : NColors.primary,
                )),
                TextSpan(text: ' ${NTexts.and} ',style: Theme.of(context).textTheme.bodySmall),
                TextSpan(text: NTexts.termsOfUse,style: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: dark? NColors.white : NColors.primary,
                  decoration: TextDecoration.underline,
                  decorationColor: dark ? NColors.white : NColors.primary,
                ),
                ),
              ]
          ),
        ),


      ],
    );
  }
}