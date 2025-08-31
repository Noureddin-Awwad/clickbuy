import 'package:e_commerce/featues/authentications/controllers/forget_password/forget_password_controller.dart';
import 'package:e_commerce/featues/authentications/screens/login/login.dart';
import 'package:e_commerce/utils/constants/texts_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.back(), icon: Icon(CupertinoIcons.clear))
        ],
      ),
      body:  SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            children: [
              /// Image
              Image(image: AssetImage(NImage.deliveredEmailIllustration),width: NHelperFumctions.screenWidth() * 0.6,),
              const SizedBox(height: NSizes.spaceBtwSections,),

              /// Email, Title &Subtitle
              Text(email, style: Theme.of(context).textTheme.bodyMedium,textAlign: TextAlign.center,),
              const SizedBox(height: NSizes.spaceBtwItems,),
              Text(NTexts.changeYourPasswordTitle, style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
              const SizedBox(height: NSizes.spaceBtwItems,),
              Text(NTexts.changeYourPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
              const SizedBox(height: NSizes.spaceBtwSections,),


              /// Buttons
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: () => Get.offAll(() => const LoginScreen()),
                    child: const Text(NTexts.done)),),
              const SizedBox(height: NSizes.spaceBtwItems,),
              SizedBox(
                width: double.infinity,
                child: TextButton(onPressed: () => ForgetPasswordController.instance.resendPasswordResetEmail(email),
                    child: const Text(NTexts.resendEmail)),),

            ],
          ),
        ),
      ),
    );
  }
}
