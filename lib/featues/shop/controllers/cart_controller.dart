import 'package:get/get.dart';
import '../../../data/repositories/cart/cart_repository.dart';
import '../models/cart_model.dart';

class CartController extends GetxController {
  // Observable list of cart items
  final cartItems = <CartModel>[].obs;

  // Instantiate the repository
  final CartRepository _cartRepository = CartRepository();

  // Add item to cart
  void addToCart(CartModel item) {
    final existingItemIndex = cartItems.indexWhere((cartItem) => cartItem.productId == item.productId);

    if (existingItemIndex != -1) {
      // If the item already exists, update its quantity
      cartItems[existingItemIndex] = CartModel(
        productId: item.productId,
        title: item.title,
        price: item.price,
        quantity: cartItems[existingItemIndex].quantity + 1,
        thumbnail: item.thumbnail,
      );
    } else {
      // If the item doesn't exist, add it to the cart
      cartItems.add(item);
    }

    // Save cart to Firestore
    saveCartToFirestore();
  }

  // Remove item from cart
  void removeFromCart(String productId) {
    cartItems.removeWhere((item) => item.productId == productId);
    saveCartToFirestore();
  }

  // Update item quantity
  void updateQuantity(String productId, int newQuantity) {
    final itemIndex = cartItems.indexWhere((item) => item.productId == productId);

    if (itemIndex != -1) {
      if (newQuantity > 0) {
        cartItems[itemIndex] = CartModel(
          productId: cartItems[itemIndex].productId,
          title: cartItems[itemIndex].title,
          price: cartItems[itemIndex].price,
          quantity: newQuantity,
          thumbnail: cartItems[itemIndex].thumbnail,
        );
      } else {
        cartItems.removeAt(itemIndex); // Remove item if quantity is 0
      }
      saveCartToFirestore();
    }
  }

  // Save cart to Firestore
  Future<void> saveCartToFirestore() async {
    try {
      final userId = 'user123'; // Replace with actual user ID (e.g., from Firebase Auth)
      await _cartRepository.saveCartItems(userId, cartItems.toList());
    } catch (error) {
      print('❌ Error saving cart to Firestore: $error');
      Get.snackbar('Error', 'Failed to save cart. Please try again.');
    }
  }

  // Load cart from Firestore
  Future<void> loadCartFromFirestore() async {
    try {
      final userId = 'user123'; // Replace with actual user ID (e.g., from Firebase Auth)
      final loadedItems = await _cartRepository.loadCartItems(userId);
      cartItems.assignAll(loadedItems);
    } catch (error) {
      print('❌ Error loading cart from Firestore: $error');
      Get.snackbar('Error', 'Failed to load cart. Please try again.');
    }
  }

  double get totalPrice {
    return cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
  }
}