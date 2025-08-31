import 'package:e_commerce/featues/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/image_strings.dart';
import '../images/n_circular_image.dart';
import '../shimmer/shimmer_effect.dart';

class NUserProfileTile extends StatelessWidget {
  const NUserProfileTile({
    super.key, required this.onPressed,
  });
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final controller= UserController.instance;
    return ListTile(
      leading: Column(
        children: [
          Obx((){
            final networkImage = controller.user.value.profilePicture;
            final image = networkImage.isNotEmpty ? networkImage: NImage.user;
            return controller .imageUploading.value
                ? NShimmerEffect(width: 80, height: 80, radius: 80,)
                : NCircularImage(image: image,width: 50,height: 50, isNetworkImage: networkImage.isNotEmpty,);
          } ),
        ],
      ),
      title: Text(controller.user.value.fullName, style: Theme.of(context).textTheme.headlineSmall!.apply(color: NColors.white),),
      subtitle: Text(controller.user.value.email, style: Theme.of(context).textTheme.bodyMedium!.apply(color: NColors.white),),
      trailing: IconButton(onPressed: onPressed, icon: Icon(Iconsax.edit, color: NColors.white,)),
    );
  }
}