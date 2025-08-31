import 'package:e_commerce/featues/personalization/screens/settings/settings.dart';
import 'package:e_commerce/featues/shop/screens/home/home.dart';
import 'package:e_commerce/featues/shop/screens/store/store.dart';
import 'package:e_commerce/featues/shop/screens/wishlist/wishlist.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import 'data/repositories/product/product_repository.dart';
import 'featues/shop/controllers/product/favourite_controller.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = NHelperFumctions.isDarkMode(context);


    return Scaffold(
      bottomNavigationBar: Obx(
          () => NavigationBar(
          height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            backgroundColor: darkMode ? NColors.black : Colors.white,
            indicatorColor: darkMode ? NColors.white.withOpacity(0.1) : NColors.black.withOpacity(0.1),
        
            destinations: [
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.shop), label: 'Store'),
              NavigationDestination(icon: Icon(Iconsax.heart), label: 'Wishlist'),
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
        
            ]),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = const [
     HomeScreen(),
     StoreScreen(),
     FavouriteScreen(),
     SettingsScreen(),
  ];
}

