

import 'package:e_commerce/common/widgets/loaders/loaders.dart';
import 'package:e_commerce/data/repositories/repository.authentication/authentication_repository.dart';
import 'package:e_commerce/featues/authentications/screens/password_configuration/reset_password.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/network/network_manager.dart';
import 'package:e_commerce/utils/popups/full_screen_loader.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController{
  static ForgetPasswordController get instance => Get.find();

  /// Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordFormKey = GlobalKey<FormState>();

  /// Send Reset Password Email
  sendPasswordResetEmail() async{
    try {
      // Start Loading
      NFullScreenLoader.openLoadingDialog('Processing your request ...', NImage.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {NFullScreenLoader.stopLoading();return;}

      // Form Validation
      if(!forgetPasswordFormKey.currentState!.validate()){
        NFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.sendPasswordResetEmail(email.text.trim());

      //Remove Loader
      NFullScreenLoader.stopLoading();

      // Show Success Screen
      NLoaders.successSnackBar(title: 'Email Sent',message: 'Email Link to Reset your Password'.tr);

      // Redirect
      Get.to (() => ResetPassword(email: email.text.trim()));
    }catch (e){
      //Remove Loader
      NFullScreenLoader.stopLoading();
      NLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async{
    try {
      // Start Loading
      NFullScreenLoader.openLoadingDialog('Processing your request ...', NImage.docerAnimation);

      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {NFullScreenLoader.stopLoading();return;}


      await AuthenticationRepository.instance.sendPasswordResetEmail(email);

      //Remove Loader
      NFullScreenLoader.stopLoading();

      // Show Success Screen
      NLoaders.successSnackBar(title: 'Email Sent',message: 'Email Link to Reset your Password'.tr);

    }catch (e){
      //Remove Loader
      NFullScreenLoader.stopLoading();
      NLoaders.errorSnackBar(title: 'Oh Snap',message: e.toString());
    }
  }
}