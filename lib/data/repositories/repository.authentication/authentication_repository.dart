import 'package:e_commerce/data/repositories/user/user_repository.dart';
import 'package:e_commerce/featues/authentications/screens/login/login.dart';
import 'package:e_commerce/featues/authentications/screens/onboarding/onboarding.dart';
import 'package:e_commerce/featues/authentications/screens/signup/verify_email.dart';
import 'package:e_commerce/navigation_menu.dart';
import 'package:e_commerce/utils/local_storage/storage_utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  ///Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;

  /// Get Auth User Data
  User? get authUser => _auth.currentUser;

  ///Called from main.dart on app launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    screenRedirect();
  }

  /// Function to Show Relevant Screen
  void screenRedirect() async {
    final user= _auth.currentUser;

    if (user != null) {
      // If the user is logged in
      if (user.emailVerified) {

        // Initialize User Specific Storage
        await NLocalStorage.init(user.uid);

        // If the user's email is verified, navigate to the navigation menu
        Get.offAll(() => NavigationMenu());
      } else {
        // If the user's email is not verified, navigate to the email verification screen
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email,));
      }
    } else {
      //Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      // Check if it is the first time launching the app
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => LoginScreen())
          : Get.offAll(() => OnBoardingScreen());
    }
  }

    /*---------------------------Email & Password sign-in-----------------------*/

    /// [EmailAuthentication] - Sign In
    Future<UserCredential> loginWithEmailAndPassword(String email,String password) async {
    try {
     return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw NFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const NFormatException();
    } on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


    /// [EmailAuthentication] - Register
    Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
      try {
        return await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        throw NFirebaseAuthException(e.code).message;
      } on FirebaseException catch (e) {
        throw NFirebaseException(e.code).message;
      } on FormatException catch (_) {
        throw const NFormatException();
      } on PlatformException catch (e) {
        throw NPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }

    /// [ReAuthenticate] - ReAuthenticate User
    Future<void> reAuthenticateWithEmailAndPassword(String email , String password) async {
    try {
      // Create a credential
      AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

      //ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw NFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const NFormatException();
    } on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

    /// [EmailVerification] - Mail Verification
    Future<void> sendEmailVerification() async {
      try {
        await _auth.currentUser?.sendEmailVerification();
      } on FirebaseAuthException catch (e) {
        throw NFirebaseAuthException(e.code).message;
      } on FirebaseException catch (e) {
        throw NFirebaseException(e.code).message;
      } on FormatException catch (_) {
        throw const NFormatException();
      } on PlatformException catch (e) {
        throw NPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }

    /// [EmailAuthentication] - Forget Password
    Future<void> sendPasswordResetEmail(String email) async {
      try {
        await _auth.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException catch (e) {
        throw NFirebaseAuthException(e.code).message;
      } on FirebaseException catch (e) {
        throw NFirebaseException(e.code).message;
      } on FormatException catch (_) {
        throw const NFormatException();
      } on PlatformException catch (e) {
        throw NPlatformException(e.code).message;
      } catch (e) {
        throw 'Something went wrong. Please try again';
      }
    }

    /*---------------------------Federated identity & social sign-in-----------------------*/

    /// [GoogleAuthentication] - Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the auth flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth= await userAccount?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in , return UserCredential
      return await _auth.signInWithCredential(credential);

    } on FirebaseAuthException catch (e) {
      throw NFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const NFormatException();
    } on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
    /// [FacebookAuthentication] - Facebook


    /*---------------------------./end Federated identity & social sign-in-----------------------*/

    ///[logoutUser] - Valid for any authentication.
  Future<void> logout() async {
    try {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
      Get.offAll(()=> LoginScreen());
    } on FirebaseAuthException catch (e) {
      throw NFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const NFormatException();
    } on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  ///[logoutUser] - Valid for any authentication.
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw NFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const NFormatException();
    } on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
  }
