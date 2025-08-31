import 'package:e_commerce/featues/authentications/screens/login/widgits/login_form.dart';
import 'package:e_commerce/featues/authentications/screens/login/widgits/login_header.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/constants/texts_strings.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/styles/spacing_styles.dart';
import '../../../../common/widgets/form_divider.dart';
import '../../../../common/widgets/social_buttons.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
            padding: NSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// logo , Title & SubTitle
              NLoginHeader(dark: dark),

              ///Form
              NLoginForm(),

              ///Divider
              NFormDivider(dividerText: NTexts.orSignInWith.capitalize!,),

              const SizedBox(height: NSizes.spaceBtwSections,),

              ///Footer
              NSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}







