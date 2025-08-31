
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/featues/shop/models/category_model.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../../utils/firebase_storage_service/firebase_storage_service.dart';
import '../fake_store_category/i_category_repository.dart';


class CategoryRepository extends GetxController implements ICategoryRepository { // <-- Add 'implements ICategoryRepository'
  static CategoryRepository get instance => Get.find();



  /// Variables
  final  _db = FirebaseFirestore.instance;
  /// Get all Categories
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      print('CategoryRepository (Firebase): Starting getAllCategories...'); // <-- Add print
      final snapshot = await _db.collection('Categories').get();

      print('CategoryRepository (Firebase): Fetched ${snapshot.docs.length} documents for all categories.'); // <-- Add print

      final list = snapshot.docs.map((document) => CategoryModel.fromSnapshot(document)).toList();
      print('CategoryRepository (Firebase): Converted ${list.length} documents to CategoryModel.'); // <-- Add print
      return list;
    } on FirebaseException catch (e) {
      throw 'Firebase Exception: ${e.message}';
    } catch (e) {
      throw 'Something went wrong. Please try again: $e';
    }
  }
  /// Get Sub Categories
  @override
  Future<List<CategoryModel>> getSubCategories(String categoryId) async{
    try {
      final snapshot = await _db.collection("Categories").where('ParentId', isEqualTo: categoryId).get();
      final result = snapshot.docs.map((e)=> CategoryModel.fromSnapshot(e)).toList();
      return result;

    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    }on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  /// Upload Categories to the Cloud Firebase
  Future<void> uploadDummyData(List<CategoryModel> categories) async{
    try {
      // Upload all the Categories along with their Images
      final storage = Get.put(NFirebaseStorageService());

      // Loop through each category
      for(var category in categories){
        // Get ImageData link from the local assets
        final file = await storage.getImageDataFromAssets(category.image);

        // Upload Image and Get its URL
        final url = await storage.uploadImageData('Categpries',file,category.name);

        // Assign URL to Category.image attribute
        category.image= url;

        //Store Category in Firestore
        await _db.collection("Categories").doc(category.id).set(category.toJson());
      }
    } on FirebaseException catch (e) {
      throw NFirebaseException(e.code).message;
    }on PlatformException catch (e) {
      throw NPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}