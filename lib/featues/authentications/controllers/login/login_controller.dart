

import 'package:e_commerce/featues/personalization/controllers/user_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loaders.dart';
import '../../../../data/repositories/repository.authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/network/network_manager.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class LoginController extends GetxController{

  ///Variables
  final localStorage = GetStorage();
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final userController = Get.put(UserController());


//  @override
//    void onInit() {
//    email.text = localStorage.read('REMEMBER_ME_EMAIL');
//     super.onInit();
// }

  /// --Email and password signIn
  Future<void> emailAndPasswordSignIn() async {
    try {

      // Start Loading
      NFullScreenLoader.openLoadingDialog(
          'Logging you in ....', NImage.docerAnimation);


      //Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {NFullScreenLoader.stopLoading(); return;}


      //Form Validation
      if (loginFormKey.currentState != null && !loginFormKey.currentState!.validate()){
        NFullScreenLoader.stopLoading();
        return; }

      //Save Data if Remember me is selected
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }


      //Login user using email and password auth
      final userCredential = await AuthenticationRepository.instance
          .loginWithEmailAndPassword(
          email.text.trim(), password.text.trim());



      //Remove loader
      NFullScreenLoader.stopLoading();


      //Redirect
      AuthenticationRepository.instance.screenRedirect();
    } catch (e) {
      // Remove loader
      NFullScreenLoader.stopLoading();

      //show some Generic Error to the user
      NLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  ///Google SignIn Auth
  Future<void> googleSignIn() async {
    try {
      // Start Loading
      NFullScreenLoader.openLoadingDialog('Logging you in...', NImage.docerAnimation);

      // Check Internet Connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected){
        NFullScreenLoader.stopLoading();
        return;
      }

      // Google Auth
      final userCredentials = await AuthenticationRepository.instance.signInWithGoogle();

      //Save user Record
      await userController.saveUserRecord(userCredentials);//

      // Remove Loader
      NFullScreenLoader.stopLoading();

      // Redirect
      AuthenticationRepository.instance.screenRedirect();
    }catch(e){
      // Remove Loader
      NFullScreenLoader.stopLoading();

      NLoaders.errorSnackBar(title: 'Oh Snap', message: e.toString());
    }
  }
}