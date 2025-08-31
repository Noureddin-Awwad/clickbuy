import 'package:e_commerce/featues/authentications/controllers/login/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';


///For Social Buttons


class NSocialButtons extends StatelessWidget {
  const NSocialButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(border: Border.all(color: NColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: () => controller.googleSignIn(),
            icon: Image(
              width: NSizes.iconMd,
              height: NSizes.iconMd,
              image: AssetImage(NImage.google),
            ),
          ),
        ),
        const SizedBox(width: NSizes.spaceBtwItems,),
        Container(
          decoration: BoxDecoration(border: Border.all(color: NColors.grey), borderRadius: BorderRadius.circular(100)),
          child: IconButton(
            onPressed: (){},
            icon: Image(
              width: NSizes.iconMd,
              height: NSizes.iconMd,
              image: AssetImage(NImage.facebook),
            ),
          ),
        ),
      ],
    );
  }
}