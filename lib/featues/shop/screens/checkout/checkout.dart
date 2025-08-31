import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/common/widgets/success_screen/success_screen.dart';
import 'package:e_commerce/featues/shop/screens/checkout/widgets/billing_address_section.dart';
import 'package:e_commerce/featues/shop/screens/checkout/widgets/billing_ammount_section.dart';
import 'package:e_commerce/featues/shop/screens/checkout/widgets/billing_payment_section.dart';
import 'package:e_commerce/navigation_menu.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/products/cart/coupon_widget.dart';
import '../../../../utils/constants/sizes.dart';
import '../cart/widgets/cart_items.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return Scaffold(
      appBar: NAppBar(
        showBackArrow: true,
        title: Text(
          'Order Review',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            children: [
              NCartItems(
                showAddRemoveButtons: false,
              ),
              SizedBox(
                height: NSizes.spaceBtwSections,
              ),

              /// Coupon Text Field
              NCouponCode(),
              SizedBox(
                height: NSizes.spaceBtwSections,
              ),

              /// Billing Section
              NRoundedContainer(
                showBorder: true,
                padding: EdgeInsets.all(NSizes.md),
                backgroundColor: dark ? NColors.black : NColors.white,
                child: Column(
                  children: [
                    ///Pricing
                    NBillingAmmountSection(),
                    SizedBox(
                      height: NSizes.spaceBtwItems,
                    ),

                    ///Divider
                    Divider(),
                    SizedBox(
                      height: NSizes.spaceBtwItems,
                    ),

                    ///Payment Methods
                    NBillingPaymentSection(),
                    SizedBox(
                      height: NSizes.spaceBtwItems,
                    ),

                    ///Address
                    NBillingAddressSection(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

      ///Checkout Button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(NSizes.defaultSpace),
        child: ElevatedButton(
            onPressed: () => Get.to(() => SuccessScreen(
                image: NImage.successfulPaymentIcon,
                title: 'Payment Success!',
                subtitle: 'Your item will be shipped soon!',
                onPressed: () => Get.offAll(() => NavigationMenu()))),
            child: Text('Checkout \$256')),
      ),
    );
  }
}
