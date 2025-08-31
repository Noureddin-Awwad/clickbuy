


import 'package:e_commerce/featues/authentications/screens/onboarding/onboarding.dart';
import 'package:e_commerce/featues/authentications/screens/password_configuration/forget_password.dart';
import 'package:e_commerce/featues/authentications/screens/signup/verify_email.dart';
import 'package:e_commerce/featues/personalization/screens/address/address.dart';
import 'package:e_commerce/featues/personalization/screens/profile/profile.dart';
import 'package:e_commerce/featues/shop/screens/cart/cart.dart';
import 'package:e_commerce/featues/shop/screens/checkout/checkout.dart';
import 'package:e_commerce/featues/shop/screens/order/order.dart';
import 'package:e_commerce/featues/shop/screens/product_reviews/product_reviews.dart';
import 'package:e_commerce/routes/routes.dart';
import 'package:get/get.dart';
import '../featues/personalization/screens/settings/settings.dart';
import '../featues/shop/screens/home/home.dart';
import '../featues/shop/screens/store/store.dart';
import '../featues/shop/screens/wishlist/wishlist.dart';

class AppRoutes{
  static final pages = [
    GetPage(name: NRoutes.home, page: () => const HomeScreen()),
    GetPage(name: NRoutes.store, page: () => const StoreScreen()),
    GetPage(name: NRoutes.favourites, page: () => const FavouriteScreen()),
    GetPage(name: NRoutes.settings, page: () => const SettingsScreen()),
    GetPage(name: NRoutes.productReview, page: () => const ProductReviewsScreen()),
    GetPage(name: NRoutes.orders, page: () => const OrderScreen()),
    GetPage(name: NRoutes.checkout, page: () => const CheckoutScreen()),
    GetPage(name: NRoutes.cart, page: () => const CartScreen()),
    GetPage(name: NRoutes.userProfile, page: () => const ProfileScreen()),
    GetPage(name: NRoutes.userAddress, page: () => const UserAddressScreen()),
    GetPage(name: NRoutes.signup, page: () => const UserAddressScreen()),
    GetPage(name: NRoutes.verifyEmail, page: () => const VerifyEmailScreen()),
    GetPage(name: NRoutes.signIn, page: () => const VerifyEmailScreen()),
    GetPage(name: NRoutes.forgotPassword, page: () => const ForgetPassword()),
    GetPage(name: NRoutes.onBoarding, page: () => const OnBoardingScreen()),

  ];
}