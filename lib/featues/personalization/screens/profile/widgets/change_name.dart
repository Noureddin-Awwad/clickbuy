import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/constants/texts_strings.dart';
import 'package:e_commerce/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/update_name_controller.dart';

class ChangeName extends StatelessWidget {
  const ChangeName({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateNameController());
    return Scaffold(
      /// Custom AppBar
      appBar: NAppBar(
        showBackArrow: true,
        title: Text('Change Name',style: Theme.of(context).textTheme.headlineSmall,),
      ),
      body: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Headline
            Text(
              'Use real name for easy verification. This will appear on several pages.',
              style: Theme.of(context).textTheme.labelMedium,
            ),
            SizedBox(height: NSizes.spaceBtwSections,),

            /// Text field and Button
            Form(
              key: controller.updateUserNameFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.firstName,
                      validator: (value) => NValidator.validateEmptyText('First name', value),
                      expands: false,
                      decoration: InputDecoration(labelText: NTexts.firstName, prefixIcon: Icon(Iconsax.user)),
                    ),
                    SizedBox(height: NSizes.spaceBtwInputFields,),
                    TextFormField(
                      controller: controller.lastName,
                      validator: (value) => NValidator.validateEmptyText('Last name', value),
                      expands: false,
                      decoration: InputDecoration(labelText: NTexts.lastName, prefixIcon: Icon(Iconsax.user)),
                    ),
                  ],
                )
            ),
            SizedBox(height: NSizes.spaceBtwSections,),
            
            /// Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: () => controller.updateUserName(), child: Text('Save')),
            )
          ],
        ),
      ),
    );
  }
}
