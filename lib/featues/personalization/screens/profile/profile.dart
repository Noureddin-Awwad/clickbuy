import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/images/n_circular_image.dart';
import 'package:e_commerce/common/widgets/shimmer/shimmer_effect.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/personalization/screens/profile/widgets/profile_menu.dart';
import 'package:e_commerce/featues/personalization/screens/profile/widgets/change_name.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/user_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller= UserController.instance;
    return Scaffold(
      appBar: NAppBar(
        showBackArrow: true,
        title: Text('Profile'),
      ),
      ///Body
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            children: [
              /// Profile Picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx((){
                      final networkImage = controller.user.value.profilePicture;
                      final image = networkImage.isNotEmpty ? networkImage: NImage.user;
                      return controller .imageUploading.value
                        ? NShimmerEffect(width: 80, height: 80, radius: 80,)
                        : NCircularImage(image: image,width: 80,height: 80, isNetworkImage: networkImage.isNotEmpty,);
                    } ),
                    TextButton(onPressed: () => controller.uploadUserProfilePicture(), child: Text('Change Profile Picture'))
                  ],
                ),
              ),

              ///Details
              SizedBox(height: NSizes.spaceBtwItems / 2,),
              Divider(),
              SizedBox(height: NSizes.spaceBtwItems,),



              /// Heading Profile Info
              NSectionHeading(title: 'Profile Information',showActionButton: false,),
              SizedBox(height: NSizes.spaceBtwItems,),

              NProfileMenu(title: 'Name', value: controller.user.value.fullName,onPressed: () => Get.to(()=>ChangeName()),),
              NProfileMenu(title: 'Username', value: controller.user.value.username,onPressed: (){},),

              SizedBox(height: NSizes.spaceBtwItems ,),
              Divider(),
              SizedBox(height: NSizes.spaceBtwItems,),

              /// Heading Profile Info
              NSectionHeading(title: 'Personal Information',showActionButton: false,),
              SizedBox(height: NSizes.spaceBtwItems,),

              NProfileMenu(title: 'User Id', value: controller.user.value.id,onPressed: (){},icon: Iconsax.copy,),
              NProfileMenu(title: 'E-mail', value: controller.user.value.email,onPressed: (){},),
              NProfileMenu(title: 'Phone Number', value: controller.user.value.phoneNumber,onPressed: (){},),
              NProfileMenu(title: 'Gender', value: 'Male',onPressed: (){},),
              NProfileMenu(title: 'Date of Birth', value: '1 Aug , 2002',onPressed: (){},),
              Divider(),
              SizedBox(height: NSizes.spaceBtwItems,),

              Center(
                child: TextButton(
                    onPressed: () => controller.deleteAccountWarningPopup(),
                    child: Text('Close Account' , style: TextStyle(color: Colors.red),),
                ),
              )

            ],
          ),

        ),

      ),
    );
  }
}


