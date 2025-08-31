import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loaders/animation_loader.dart';

/// A utility class for managing a full-screen loading dialog
class NFullScreenLoader {
  ///open a full-screen loading dialog with a given text and animation .
  ///This method doesn't return anything
  ///
  /// Parameters:
  ///   -text: The text to be displayed in the loading dialog
  ///   -animation: The Lottie animation to be shown.

  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,
        barrierDismissible: false,
        builder: (_) => PopScope(
            canPop: false,
            child: Container(
              color: NHelperFumctions.isDarkMode(Get.context!) ? NColors.dark : NColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  SizedBox(height: 250,),
                  NAnimationLoaderWidget(text: text, animation: animation)
                ],
              ),
            )
        )
    );
  }

  /// Stop the currently open loading dialog
/// this method doesn't return anything
  static stopLoading(){
    Navigator.of(Get.overlayContext!).pop();
  }
}
