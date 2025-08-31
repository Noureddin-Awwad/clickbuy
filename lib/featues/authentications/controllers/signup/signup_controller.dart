import 'package:e_commerce/common/widgets/loaders/loaders.dart';
import 'package:e_commerce/data/repositories/repository.authentication/authentication_repository.dart';
import 'package:e_commerce/data/repositories/user/user_repository.dart';
import 'package:e_commerce/featues/authentications/models/user_model.dart';
import 'package:e_commerce/featues/authentications/screens/signup/verify_email.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/popups/full_screen_loader.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../../utils/network/network_manager.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  ///Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final email = TextEditingController(); //Controller for email input
  final lastName = TextEditingController(); //Controller for last name input
  final username = TextEditingController(); //Controller for username input
  final password = TextEditingController(); //Controller for password input
  final firstName = TextEditingController(); //Controller for first name input
  final phoneNumber = TextEditingController(); //Controller for phone number input
  GlobalKey<FormState> signupFormKey = GlobalKey<
      FormState>(); // Form key for form validation


  /// --SignUp
  void signup() async {
    try {

      // Start Loading
      NFullScreenLoader.openLoadingDialog(
          'We are processing your information ...', NImage.docerAnimation);


      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) return;


      //Form Validation
      if (!signupFormKey.currentState!.validate()){
        NFullScreenLoader.stopLoading();
        return; }

        //Privacy Policy Check
        if (!privacyPolicy.value) {
          NLoaders.warningSnackBar(
            title: 'Accept Privacy Policy',
            message: 'In order to create account , you must have to read and accept the Privacy Policy & Terms of use.',
          );
          return;
        }


        //Register user in the Firebase Authentication & Save user data in the Firebase
        final userCredential = await AuthenticationRepository.instance
            .registerWithEmailAndPassword(
            email.text.trim(), password.text.trim());


        //Save Authenticated user data in the Firebase Firestore
        final newUser = UserModel(
          id: userCredential.user!.uid,
          firstName: firstName.text.trim(),
          lastName: lastName.text.trim(),
          username: username.text.trim(),
          email: email.text.trim(),
          phoneNumber: phoneNumber.text.trim(),
          profilePicture: '',
        );

        final userRepository = Get.put(UserRepository());
        await userRepository.saveUserRecord(newUser);

        //Remove loader
        NFullScreenLoader.stopLoading();

        //Show Success Message
        NLoaders.successSnackBar(title: 'Congratulations', message: 'Your account has been created! Verify email to continue.');


        //Move to Verify Email Screen
        Get.to(() => VerifyEmailScreen(email: email.text.trim(),));
    } catch (e) {
      // Remove loader
      NFullScreenLoader.stopLoading();

      //show some Generic Error to the user
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
