import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/featues/personalization/controllers/address_controller.dart';
import 'package:e_commerce/featues/personalization/screens/address/widgets/single_address.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/cloud_helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'add_new_address.dart';

class UserAddressScreen extends StatelessWidget {
  const UserAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddressController());
    
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: ()=>Get.to(() => AddNewAddress()),
      child: Icon(Iconsax.add,color:NColors.white,),
      ),
      appBar: NAppBar(
        showBackArrow: true,
        title: Text('Addresses',style: Theme.of(context).textTheme.headlineSmall,),
      ),


      body: SingleChildScrollView(
        child: Padding(padding: EdgeInsets.all(NSizes.defaultSpace),
        child: Obx(
          () =>  FutureBuilder(
            key: Key(controller.refreshData.value.toString()),
            future: controller.allUserAddresses(),
            builder: (context, snapshot){

              final response = NCloudHelperFunctions.checkMultiRecordState(snapshot: snapshot);
              if(response != null) return response;


              final addresses = snapshot.data!;
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_,index) => NSingleAddress(
                    address: addresses[index],
                    onTap: () => controller.selectAddress(addresses[index]),
                  )
              );
            },
          ),
        )
        ),
      ),
    );
  }
}
