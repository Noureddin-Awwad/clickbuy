

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/data/repositories/repository.authentication/authentication_repository.dart';
import 'package:get/get.dart';

import '../../../featues/personalization/models/address_model.dart';

class AddressRepository extends GetxController{
  static AddressRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<AddressModel>> fetchUserAddresses() async{
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      if (userId.isEmpty) throw 'Unable to find user information';

      final result = await _db.collection('Users').doc(userId).collection('Addresses').get();
      return result.docs.map((documentSnapshot) => AddressModel.fromDocumentSnapshot(documentSnapshot)).toList();
    }catch (e){
      throw 'Something went wrong while fetching addresses';
    }
  }

  Future<void> updateSelectedField(String addressId , bool selected) async{
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      await _db.collection('Users').doc(userId).collection('Addresses').doc(addressId).update({'SelectedAddress': selected});
    }catch (e){
      throw 'Something went wrong while updating selected field';
    }
  }

  Future<String> addAddress(AddressModel address) async{
    try{
      final userId = AuthenticationRepository.instance.authUser!.uid;
      final currentAddress=await _db.collection('Users').doc(userId).collection('Addresses').add(address.toJson());
      return currentAddress.id;
    }catch (e){
      throw 'Something went wrong while updating selected field';
    }
  }
}