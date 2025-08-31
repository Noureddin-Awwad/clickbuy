import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

/// A widget for displaying an animated loading indicator with optional text and action button .
class NAnimationLoaderWidget extends StatelessWidget {
  /// Default constructor for the NAnimationLoaderWidget
  ///
  /// Parameters:
  ///  -text: the text to be displayed below the animation
  ///  -animation: the path to the lottie animation file
  ///  - showAction : Whether to show am action button below the text
  ///  - actionText : The text to be displayed on the action button.
  ///  -onActionPressed : Callback function to be executed when the action button is pressed
  const NAnimationLoaderWidget({super.key,
    required this.text,
    required this.animation,
    this.showAction = false,
    this.actionText,
    this.onActionPressed});

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: MediaQuery
              .of(context)
              .size
              .width * 0.8), // Display Lottie animation
          SizedBox(height: NSizes.defaultSpace,),
          Text(
            text,
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: NSizes.defaultSpace,),
          showAction
              ? SizedBox(
            width: 250,
            child: OutlinedButton(onPressed: onActionPressed, // Correctly passing the callback
              style: OutlinedButton.styleFrom(backgroundColor: NColors.dark),
              child: Text(actionText!, style: Theme.of(context).textTheme.bodyMedium!.apply(color: NColors.light),),
            ),
          ) : SizedBox(),
        ],
      ),
    );
  }
}