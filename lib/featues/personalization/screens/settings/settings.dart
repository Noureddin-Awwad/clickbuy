import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/common/widgets/custom_shapes/container/primary_header_container.dart';
import 'package:e_commerce/common/widgets/list_tiles/setting_menu_tile.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/personalization/screens/address/address.dart';
import 'package:e_commerce/featues/personalization/screens/profile/profile.dart';
import 'package:e_commerce/featues/shop/screens/order/order.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/widgets/list_tiles/user_profile_tile.dart';
import '../../../../data/data_controller/product_data_source_controller.dart';
import '../../../../data/repositories/repository.authentication/authentication_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataSourceController = Get.put(ProductDataSourceController()); // Or Get.find() if already put elsewhere

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            NPrimaryHeaderContainer(
              child: Column(
                children: [
                  NAppBar(
                    title: Text(
                      'Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .apply(color: NColors.white),
                    ),
                  ),
                  SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),

                  /// User Profile Card
                  NUserProfileTile(
                    onPressed: () => Get.to(() => ProfileScreen()),
                  ),
                  SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),
                ],
              ),
            ),

            /// Body
            Padding(
              padding: EdgeInsets.all(NSizes.defaultSpace),
              child: Column(
                children: [
                  /// Account Setting
                  NSectionHeading(
                    title: 'Account Settings',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: NSizes.spaceBtwItems,
                  ),

                  NSettingsMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'My Addresses',
                    subTitle: 'Set Shopping delivery address',
                    onTap: () => Get.to(() => UserAddressScreen()),
                  ),
                  NSettingsMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'My Cart',
                    subTitle: 'Add, remove products and move to checkout',
                    onTap: () {},
                  ),
                  NSettingsMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'My Orders',
                    subTitle: 'In-progress and Completed Orders',
                    onTap: () => Get.to(()=> OrderScreen()),
                  ),
                  NSettingsMenuTile(
                    icon: Iconsax.bank,
                    title: 'Bank Account',
                    subTitle: 'Withdraw balance to registered bank account',
                    onTap: () {},
                  ),
                  NSettingsMenuTile(
                    icon: Iconsax.discount_shape,
                    title: 'My Coupons',
                    subTitle: 'List of all the discounted coupons',
                    onTap: () {},
                  ),
                  NSettingsMenuTile(
                    icon: Iconsax.notification,
                    title: 'Notifications',
                    subTitle: 'Set any kind of notification message',
                    onTap: () {},
                  ),
                  NSettingsMenuTile(
                    icon: Iconsax.security_card,
                    title: 'Account Privacy',
                    subTitle: 'Manage data usage and connected accounts',
                    onTap: () {},
                  ),

                  /// -- App Settings
                  SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),
                  NSectionHeading(
                    title: 'App Settings',
                    showActionButton: false,
                  ),
                  SizedBox(
                    height: NSizes.spaceBtwItems,
                  ),
                  // Data Source Switch Tile
                  Obx(() => NSettingsMenuTile(
                    icon: Iconsax.image, // Or your preferred icon
                    title: 'Use Fake Store Data',
                    subTitle: 'Toggle to use Fake Store API data instead of Firebase.',
                    trailing: Switch(
                      value: dataSourceController.useFakeApi.value,
                      onChanged: (value) {
                        dataSourceController.toggleDataSource(value);
                        // Handle post-toggle actions (e.g., reload data, show message)
                      },
                    ),
                  )),

                  /// Logout Button
                  SizedBox(
                    height: NSizes.spaceBtwSections,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed:  () => AuthenticationRepository.instance.logout(),
                      child: Text('Logout'),
                    ),
                  ),
                  SizedBox(
                    height: NSizes.spaceBtwSections * 2.5,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
