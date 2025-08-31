import 'package:e_commerce/common/widgets/loaders/loaders.dart';
import 'package:e_commerce/data/repositories/repository.authentication/authentication_repository.dart';
import 'package:e_commerce/data/repositories/user/user_repository.dart';
import 'package:e_commerce/featues/authentications/models/user_model.dart';
import 'package:e_commerce/featues/authentications/screens/login/login.dart';
import 'package:e_commerce/featues/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/network/network_manager.dart';
import 'package:e_commerce/utils/popups/full_screen_loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  final profileLoading = false.obs;
  Rx<UserModel> user = UserModel.empty().obs;

  final hidePassword = false.obs;
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepository = Get.put(UserRepository());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();


  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
  }

  Future<void> fetchUserRecord() async{
    try{
      profileLoading.value= true;
      final user = await userRepository.fetchUserDetails();
      this.user(user);
    } catch(e){
      user(UserModel.empty());
    }finally{
      profileLoading.value =false;
    }
  }

  /// Save user Record from any Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      // Refresh User Record
      await fetchUserRecord();

      // If no record already stored
      if (user.value.id.isEmpty) {
        if (userCredentials != null) {
          //Convert Name to First and Last Name
          final nameParts = UserModel.nameParts(
              userCredentials.user!.displayName ?? '');
          final username = UserModel.generateUsername(
              userCredentials.user!.displayName ?? '');

          // Map Data
          final user = UserModel(id: userCredentials.user!.uid,
              firstName: nameParts[0],
              lastName: nameParts.length > 1
                  ? nameParts.sublist(1).join(' ')
                  : '',
              username: username,
              email: userCredentials.user!.email ?? '',
              phoneNumber: userCredentials.user!.phoneNumber ?? '',
              profilePicture: userCredentials.user!.photoURL ?? '');

          // Save user data
          await userRepository.saveUserRecord(user);
        }
      } }catch (e){
    NLoaders.warningSnackBar(
    title: 'Data Not saved',
    message: 'Something went wrong while saving your information.You can re-save your data in your profile');
    }
  }

  /// Delete Account Warning
  void deleteAccountWarningPopup(){
    Get.defaultDialog(
      contentPadding: EdgeInsets.all(NSizes.md),
      title: 'Delete Account',
      middleText:
        'Are you sure you want to delete your account permanently? This action is not reversible and all of your data will be removed permanently.',
      confirm: ElevatedButton(
          onPressed: () async => deleteUserAccount(),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red, side: BorderSide(color: Colors.red)),
          child: Padding(padding: EdgeInsets.symmetric(horizontal: NSizes.lg), child: Text('Delete'),)
      ),
        cancel: OutlinedButton(
        onPressed: () => Navigator.of(Get.overlayContext!).pop(),
            child: Text('Cancel'),
    )
    );
  }

  /// Delete User Account
  void deleteUserAccount() async{
    try{
      NFullScreenLoader.openLoadingDialog('Processing', NImage.docerAnimation);

      /// First re-auth user
      final auth = AuthenticationRepository.instance;
      final provider= auth.authUser!.providerData.map((e) => e.providerId).first;

      if (provider.isNotEmpty){
        // Re verify auth Email
        if (provider == 'google.com'){
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          NFullScreenLoader.stopLoading();
          Get.offAll(()=> LoginScreen());
        }else if (provider == 'password'){
          NFullScreenLoader.stopLoading();
          Get.to(()=> ReAuthLoginForm());
        }
      }
    }catch (e){
      NFullScreenLoader.stopLoading();
      NLoaders.warningSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  /// Re- Authenticate before deleting
  Future <void> reAuthenticateEmailAndPasswordUser() async{
    try{
      NFullScreenLoader.openLoadingDialog('Processing', NImage.docerAnimation);

      // Check Internet
      final isConnected = await NetworkManager.instance.isConnected();
      if(!isConnected) {
        NFullScreenLoader.stopLoading();
        return;
      }
      if(!reAuthFormKey.currentState!.validate()){
        NFullScreenLoader.stopLoading();
        return;
      }

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(),verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      NFullScreenLoader.stopLoading();
      Get.offAll(()=> LoginScreen());
    }catch(e){
      NFullScreenLoader.stopLoading();
      NLoaders.warningSnackBar(title: 'Oh Snap!',message: e.toString());
    }
  }

  /// Upload Profile Image
  uploadUserProfilePicture() async{
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery,imageQuality: 70,maxHeight: 512,maxWidth: 512);
      if (image != null){
        imageUploading.value=true;
        // Upload Image
        final imageUrl = await userRepository.uploadImage('Users/Images/Profile/', image);

        //Update User Image Record
        Map<String,dynamic> json ={'ProfilePicture' : imageUrl};
        await userRepository.updateSingleField(json);

        user.value.profilePicture =imageUrl;
        user.refresh();

        NLoaders.successSnackBar(title: 'Congratulations',message: 'Your Profile Image has been updated!');

      }
    } catch (e) {
     NLoaders.errorSnackBar(title: 'Oh Snap',message: 'Something went wrong : $e');
    }
    finally{
      imageUploading.value= false;
    }
  }
}

