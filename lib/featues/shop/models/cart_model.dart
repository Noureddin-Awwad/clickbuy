class CartModel {
  final String productId;
  final String title;
  final double price;
  final int quantity;
  final String thumbnail;

  CartModel({
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
    required this.thumbnail,
  });

  // Convert CartModel to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'price': price,
      'quantity': quantity,
      'thumbnail': thumbnail,
    };
  }

  // Create CartModel from JSON (Firestore data)
  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      productId: json['productId'] ?? '',
      title: json['title'] ?? 'Unknown Product',
      price: (json['price'] is num ? json['price'].toDouble() : 0.0),
      quantity: json['quantity'] ?? 1,
      thumbnail: json['thumbnail'] ?? '',
    );
  }
}