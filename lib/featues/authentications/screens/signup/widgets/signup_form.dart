import 'package:e_commerce/featues/authentications/controllers/signup/signup_controller.dart';
import 'package:e_commerce/featues/authentications/screens/signup/widgets/terms_and_conditions.dart';
import 'package:e_commerce/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/texts_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class NSignupForm extends StatelessWidget {
  const NSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignupController());
    NHelperFumctions.isDarkMode(context);
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      NValidator.validateEmptyText('First name', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: NTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
              const SizedBox(
                width: NSizes.spaceBtwInputFields,
              ),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      NValidator.validateEmptyText('Last name', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: NTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),

          const SizedBox(
            height: NSizes.spaceBtwInputFields,
          ),

          ///Username
          TextFormField(
            controller: controller.username,
            validator: (value) =>
                NValidator.validateEmptyText('Username', value),
            expands: false,
            decoration: const InputDecoration(
                labelText: NTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),

          const SizedBox(
            height: NSizes.spaceBtwInputFields,
          ),

          ///Email
          TextFormField(
            controller: controller.email,
            validator: (value) => NValidator.validateEmail(value),
            decoration: const InputDecoration(
                labelText: NTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),

          const SizedBox(
            height: NSizes.spaceBtwInputFields,
          ),

          ///Phone Number
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => NValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
                labelText: NTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
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
                    onPressed: () => controller.hidePassword.value = !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value ? Iconsax.eye_slash :Iconsax.eye)),
              ),
            ),
          ),

          const SizedBox(
            height: NSizes.spaceBtwInputFields,
          ),

          ///Terms&Conditions Checkbox
          const NTermsAndConditions(),

          const SizedBox(
            height: NSizes.spaceBtwSections,
          ),

          ///Sign Up Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => controller.signup(),
                child: const Text(NTexts.createAccount)),
          ),
        ],
      ),
    );
  }
}
