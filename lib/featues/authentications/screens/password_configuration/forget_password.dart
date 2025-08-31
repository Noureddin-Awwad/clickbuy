import 'package:e_commerce/featues/authentications/controllers/forget_password/forget_password_controller.dart';
import 'package:e_commerce/utils/constants/texts_strings.dart';
import 'package:e_commerce/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/sizes.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Headings
            Text(NTexts.forgetPasswordTitle,style: Theme.of(context).textTheme.headlineMedium,),
            const SizedBox(height: NSizes.spaceBtwItems,),
            Text(NTexts.forgetSubPasswordTitle,style: Theme.of(context).textTheme.labelMedium,),
            const SizedBox(height: NSizes.spaceBtwSections * 2,),
            ///Text fields
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: NValidator.validateEmail,
                decoration: InputDecoration(
                  labelText: NTexts.email,
                  prefixIcon: Icon(Iconsax.direct_right),
                ),
              ),
            ),
            SizedBox(height: NSizes.spaceBtwSections,),
            ///Submit Button
            SizedBox(width:double.infinity,child: ElevatedButton(onPressed: () => controller.sendPasswordResetEmail(), child: Text(NTexts.submit))),
          ],
        ),
      ),
    );
  }
}
