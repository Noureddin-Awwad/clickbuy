import 'package:e_commerce/featues/authentications/controllers/login/login_controller.dart';
import 'package:e_commerce/featues/authentications/screens/password_configuration/forget_password.dart';
import 'package:e_commerce/featues/authentications/screens/signup/signup.dart';
import 'package:e_commerce/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts_strings.dart';

class NLoginForm extends StatelessWidget {
  const NLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Form(
      child: Column(
        children: [
          ///Email
          TextFormField(
            controller: controller.email,
            validator: (value) => NValidator.validateEmail(value),
            decoration: InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: NTexts.email),
          ),

          const SizedBox(
            height: NSizes.spaceBtwInputFields,
          ),

          ///Password
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => NValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: NTexts.password,
                prefixIcon: const Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye)),
              ),
            ),
          ),

          const SizedBox(height: NSizes.spaceBtwInputFields / 2),

          ///Remember Me & Forget Password
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// Remember me
              Row(
                children: [
                  Obx(() => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) => controller.rememberMe.value = !controller.rememberMe.value)
                  ),
                  const Text(NTexts.rememberMe),
                ],
              ),

              /// Forget Password
              TextButton(
                  onPressed: () => Get.to(() => const ForgetPassword()),
                  child: const Text(NTexts.forgetPassword)),
            ],
          ),

          const SizedBox(
            height: NSizes.spaceBtwInputFields,
          ),

          ///Sign In Button
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () =>  controller.emailAndPasswordSignIn(),
                  child: Text(NTexts.signIn))),

          const SizedBox(
            height: NSizes.spaceBtwItems,
          ),

          ///Create Account Button
          SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  onPressed: () => Get.to(() => const SignupScreen()),
                  child: Text(NTexts.createAccount))),

          const SizedBox(
            height: NSizes.spaceBtwSections,
          ),
        ],
      ),
    );
  }
}
