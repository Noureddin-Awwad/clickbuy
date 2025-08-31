import 'package:e_commerce/featues/personalization/controllers/address_controller.dart';
import 'package:e_commerce/featues/personalization/models/address_model.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/styles/rounded_container.dart';
import '../../../../../utils/constants/colors.dart';

class NSingleAddress extends StatelessWidget {
  const NSingleAddress({super.key, required this.address, required this.onTap, });


  final AddressModel address;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    final dark = NHelperFumctions.isDarkMode(context);
    return Obx(
      () {
        final selectedAddressId = controller.selectedAddress.value.id;
        final selectedAddress = selectedAddressId == address.id;
        return InkWell(
        onTap: onTap,
        child: NRoundedContainer(
          padding: EdgeInsets.all(NSizes.md),
          width: double.infinity,
          showBorder: true,
          backgroundColor: selectedAddress
              ? NColors.primary.withOpacity(0.5)
              : Colors.transparent,
          borderColor: selectedAddress
              ? Colors.transparent
              : dark
                  ? NColors.darkerGrey
                  : NColors.grey,
          margin: EdgeInsets.only(bottom: NSizes.spaceBtwItems),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                top: 0,
                child: Icon(
                  selectedAddress ? Iconsax.tick_circle5 : null,
                  color: selectedAddress
                      ? dark
                          ? NColors.light
                          : NColors.dark
                      : null,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nour Awwad',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: NSizes.sm/2,),
                  Text('(+961) 76 366 384', maxLines: 1,overflow: TextOverflow.ellipsis,),
                  SizedBox(height: NSizes.sm/2,),
                  Text(
                    '82356 Timmy Coves , South Liana , Maine , 87665, USA',
                    softWrap: true,
                  ),
                ],
              )
            ],
          ),
        ),
      );}
    );
  }
}
