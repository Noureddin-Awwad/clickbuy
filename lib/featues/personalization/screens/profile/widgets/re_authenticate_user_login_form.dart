import 'package:e_commerce/featues/personalization/controllers/user_controller.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/constants/texts_strings.dart';
import 'package:e_commerce/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ReAuthLoginForm extends StatelessWidget {
  const ReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: AppBar(title: Text('Re-Authenticate User'),),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Form(
            key: controller.reAuthFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ///Email
                    TextFormField(
                      controller: controller.verifyEmail,
                      validator: NValidator.validateEmail,
                      decoration: InputDecoration(prefixIcon: Icon(Iconsax.direct_right), labelText: NTexts.email),
                    ),
                    SizedBox(height: NSizes.spaceBtwInputFields,),

                    ///Password
                    Obx(
                          () => TextFormField(
                              controller: controller.verifyPassword,
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
                    SizedBox(height: NSizes.spaceBtwSections,),

                    /// LogIn Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(onPressed: () => controller.reAuthenticateEmailAndPasswordUser(),
                          child: Text('Verify'),
                      ),
                    )
                  ],
              ),
          ),
        ),
      ),
    );
  }
}
