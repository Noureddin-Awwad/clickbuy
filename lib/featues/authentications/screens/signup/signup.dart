import 'package:e_commerce/featues/authentications/screens/signup/widgets/signup_form.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/constants/texts_strings.dart';
import 'package:flutter/material.dart';
import '../../../../common/widgets/form_divider.dart';
import '../../../../common/widgets/social_buttons.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
              Text(NTexts.signupTitle, style:  Theme.of(context).textTheme.headlineMedium,),

              const SizedBox(height: NSizes.spaceBtwSections,),

              /// Form
              NSignupForm(),
              ///Divider
              const SizedBox(height: NSizes.spaceBtwSections,),
              NFormDivider(dividerText: NTexts.orSignUpWith,),

              /// Social Buttons
              const SizedBox(height: NSizes.spaceBtwSections,),
              const NSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}

