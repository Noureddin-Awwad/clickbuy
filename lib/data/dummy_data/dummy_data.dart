

import 'package:e_commerce/featues/shop/models/category_model.dart';
import 'package:e_commerce/utils/constants/image_strings.dart';

class NDummyData {

  /// List of Categories
  static final List<CategoryModel> categories= [
    CategoryModel(id: '1', name: 'Sports', image: NImage.sportIcon, isFeatured: true),
    CategoryModel(id: '5', name: 'Furniture', image: NImage.furnitureIcon, isFeatured: true),
    CategoryModel(id: '2', name: 'Electronics', image: NImage.electronicsIcon, isFeatured: true),
    CategoryModel(id: '3', name: 'Clothes', image: NImage.clothIcon, isFeatured: true),
    CategoryModel(id: '4', name: 'Animals', image: NImage.animalIcon, isFeatured: true),
    CategoryModel(id: '6', name: 'Shoes', image: NImage.shoeIcon, isFeatured: true),
    CategoryModel(id: '7', name: 'Cosmetics', image: NImage.cosmeticsIcon, isFeatured: true),
    CategoryModel(id: '14', name: 'Jewelery', image: NImage.jeweleryIcon, isFeatured: true),


    ///subcategories
    CategoryModel(id: '8', name: 'Sport Shoes', image: NImage.sportIcon,parentId: '1', isFeatured: false),
    CategoryModel(id: '9', name: 'Track suite', image: NImage.sportIcon,parentId: '1', isFeatured: false),
    CategoryModel(id: '10', name: 'Sports Equipment', image: NImage.sportIcon,parentId: '1', isFeatured: false),
  ];

}