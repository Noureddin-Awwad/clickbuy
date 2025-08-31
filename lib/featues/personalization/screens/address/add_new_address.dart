// AddNewAddress.dart
import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/featues/personalization/controllers/address_controller.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class AddNewAddress extends StatelessWidget {
  const AddNewAddress({super.key});

  // Keep the key here
  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = AddressController.instance;

    return Scaffold(
      appBar: NAppBar(
        showBackArrow: true,
        title: Text('Add new Address'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Form(
            key: _formKey, // Assign the key here
            child: Column(
              children: [
                TextFormField(
                  controller: controller.name,
                  validator: (value) => NValidator.validateEmptyText('Name', value),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.user), labelText: 'Name'),
                ),
                SizedBox(height: NSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.phoneNumber,
                  validator: NValidator.validatePhoneNumber,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.mobile), labelText: 'Phone Number'),
                ),
                SizedBox(height: NSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.street,
                        validator: (value) => NValidator.validateEmptyText('Street', value),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.building_31), labelText: 'Street'),
                      ),
                    ),
                    SizedBox(width: NSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.postalCode,
                        validator: (value) => NValidator.validateEmptyText('Postal Code', value),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.code), labelText: 'Postal Code'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: NSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.city,
                        validator: (value) => NValidator.validateEmptyText('City', value),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.building), labelText: 'City'),
                      ),
                    ),
                    SizedBox(width: NSizes.spaceBtwInputFields),
                    Expanded(
                      child: TextFormField(
                        controller: controller.state,
                        validator: (value) => NValidator.validateEmptyText('State', value),
                        decoration: InputDecoration(
                            prefixIcon: Icon(Iconsax.activity), labelText: 'State'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: NSizes.spaceBtwInputFields),
                TextFormField(
                  controller: controller.country,
                  validator: (value) => NValidator.validateEmptyText('Country', value),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Iconsax.global), labelText: 'Country'),
                ),
                SizedBox(height: NSizes.defaultSpace),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Pass the key to the controller method
                      controller.addNewAddresses(_formKey);
                    },
                    child: Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}