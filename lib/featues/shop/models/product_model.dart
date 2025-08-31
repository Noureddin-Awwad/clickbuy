import 'package:cloud_firestore/cloud_firestore.dart';
import 'brand_model.dart';
import 'product_attribute_model.dart';
import 'product_variation_model.dart';

class ProductModel {
  final String id;
  final int stock;
  final String? sku;
  final double price;
  final String title;
  final DateTime? date;
  final double salePrice;
  final String thumbnail;
  final bool isFeatured;
  final BrandModel? brand;
  final String? description;
  final String? categoryId;
  final List<String>? images;
  final String productType;
  final List<ProductAttributeModel>? productAttributes;
  final List<ProductVariationModel>? productVariations;

  ProductModel({
    required this.id,
    required this.stock,
    required this.productType,
    required this.thumbnail,
    required this.price,
    required this.title,
    this.sku,
    this.date,
    this.salePrice = 0.0,
    this.isFeatured = false,
    this.brand,
    this.description,
    this.categoryId,
    this.images,
    this.productAttributes,
    this.productVariations,
  });

  static ProductModel empty() => ProductModel(
    id: '',
    title: '',
    stock: 0,
    price: 0,
    thumbnail: '',
    productType: '',
  );

  Map<String, dynamic> toJson() {
    return {
      'SKU': sku,
      'Title': title,
      'Stock': stock,
      'Price': price,
      'Images': images ?? [],
      'ThumbnailHttpsUrl': thumbnail,
      'SalePrice': salePrice,
      'IsFeatured': isFeatured,
      'CategoryId': categoryId,
      'Brand': brand?.toJson(),
      'Description': description,
      'ProductType': productType,
      'ProductAttributes': productAttributes?.map((e) => e.toJson()).toList() ?? [],
      'ProductVariations': productVariations?.map((e) => e.toJson()).toList() ?? [],
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final firestoreData = json['firestoreData'] as Map<String, dynamic>? ?? {};
    // Support Fake Store JSON
    if (json.containsKey('image') &&
        json.containsKey('category') &&
        json.containsKey('rating') &&
        json['id'] is int) {
      return ProductModel(
        id: json['id'].toString(),
        title: json['title'] ?? '',
        price: (json['price'] ?? 0).toDouble(),
        thumbnail: json['image'] ?? '',
        description: json['description'] ?? '',
        categoryId: json['category'],
        stock: 0,
        salePrice: 0.0,
        isFeatured: false,
        brand: null,
        images: null,
        productType: 'single',
        productAttributes: [],
        productVariations: [],
        sku: null,
        date: null,
      );
    }

    // Firestore or local JSON
    return ProductModel(
      id: json['Id'] ?? '',
      sku: json['SKU'],
      title: json['Title'] ?? 'Unknown Product',
      stock: json['Stock'] ?? 0,
      price: (json['Price'] is num ? json['Price'].toDouble() : 0.0),
      salePrice: (json['SalePrice'] is num ? json['SalePrice'].toDouble() : 0.0),
      thumbnail: json['ThumbnailHttpsUrl'] ?? '',
      isFeatured: json['IsFeatured'] ?? false,
      brand: json['Brand'] != null
          ? BrandModel.fromJson(json['Brand'] as Map<String, dynamic>)
          : null,
      description: json['Description'] ?? '',
      categoryId: json['CategoryId'],
      productType: json['ProductType'] ?? 'single',
      images: (json['Images'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      productAttributes: (json['ProductAttributes'] as List?)
          ?.map((e) => ProductAttributeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList() ??
          [],
      productVariations: (json['ProductVariations'] as List?)
          ?.map((e) => ProductVariationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList() ??
          [],
      date: null, // You can implement timestamp conversion if needed
    );
  }

  factory ProductModel.fromCloudFunctionResponse(Map<String, dynamic> json) {
    final firestoreData = json['firestoreData'] as Map<String, dynamic>? ?? {};

    return ProductModel(
      id: json['visionProductId'] ?? '',
      sku: firestoreData['SKU'],
      title: firestoreData['Title'] ?? 'Unknown Product',
      stock: firestoreData['Stock'] ?? 0,
      price: (firestoreData['Price'] is num ? firestoreData['Price'].toDouble() : 0.0),
      salePrice: (firestoreData['SalePrice'] is num ? firestoreData['SalePrice'].toDouble() : 0.0),
      thumbnail: firestoreData['ThumbnailHttpsUrl'] ?? firestoreData['Thumbnail'] ?? 'https://via.placeholder.com/150 ',
      isFeatured: firestoreData['IsFeatured'] ?? false,
      brand: firestoreData['Brand'] != null
          ? BrandModel.fromJson(firestoreData['Brand'] as Map<String, dynamic>)
          : BrandModel.empty(),
      description: firestoreData['Description'] ?? '',
      categoryId: firestoreData['CategoryId'],
      productType: firestoreData['ProductType'] ?? 'single',
      images: (firestoreData['Images'] as List?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      productAttributes: (firestoreData['ProductAttributes'] as List?)
          ?.map((e) => ProductAttributeModel.fromJson(Map<String, dynamic>.from(e)))
          .toList() ??
          [],
      productVariations: (firestoreData['ProductVariations'] as List?)
          ?.map((e) => ProductVariationModel.fromJson(Map<String, dynamic>.from(e)))
          .toList() ??
          [],
      date: null, // You can implement timestamp conversion if needed
    );
  }

  factory ProductModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    if (data == null) return ProductModel.empty();
    return ProductModel.fromJson({...data, 'Id': doc.id});
  }

  factory ProductModel.fromQuerySnapshot(QueryDocumentSnapshot<Object?> doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel.fromJson({...data, 'Id': doc.id});
  }
}
