import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../featues/shop/models/cart_model.dart';
class CartRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save cart items to Firestore
  Future<void> saveCartItems(String userId, List<CartModel> cartItems) async {
    try {
      await _firestore.collection('users').doc(userId).collection('cart').doc('items').set({
        'items': cartItems.map((item) => item.toJson()).toList(),
      });
    } catch (error) {
      print('❌ Error saving cart items to Firestore: $error');
      rethrow; // Rethrow the error for the caller to handle
    }
  }

  // Load cart items from Firestore
  Future<List<CartModel>> loadCartItems(String userId) async {
    try {
      final snapshot = await _firestore.collection('users').doc(userId).collection('cart').doc('items').get();

      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        final List<dynamic> itemsData = data['items'];
        return itemsData.map((item) => CartModel.fromJson(item)).toList();
      }
      return []; // Return an empty list if no cart items exist
    } catch (error) {
      print('❌ Error loading cart items from Firestore: $error');
      rethrow; // Rethrow the error for the caller to handle
    }
  }
}