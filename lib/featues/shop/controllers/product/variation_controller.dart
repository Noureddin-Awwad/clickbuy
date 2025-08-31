import 'package:e_commerce/featues/shop/controllers/product/images_controller.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/featues/shop/models/product_variation_model.dart';
import 'package:get/get.dart';

class VariationController extends GetxController {
  static VariationController get to => Get.find();

  /// Variables
  RxMap selectedAttributes = {}.obs;
  RxString variationStockStatus = ''.obs;
  Rx<ProductVariationModel> selectedVariation =
      ProductVariationModel.empty().obs;

  /// -- Select attribute , and Variation
  void onAttributeSelected(ProductModel product, attributeName, attributeValue) {
    // when attribute is selected we will first add that attribute to the selected attributes
    final selectedAttribute = Map<String, dynamic>.from(this.selectedAttributes);
    selectedAttribute[attributeName] = attributeValue;
    this.selectedAttributes[attributeName] = attributeValue;

    final selectedVariation = product.productVariations!.firstWhere(
        (variation) => _isSameAttributeValues(variation.attributeValues!, selectedAttribute),
        orElse: () => ProductVariationModel.empty());

    // Show the Selected Variation image as a Main Image
    if (selectedVariation.image.isNotEmpty){
      ImagesController.instance.selectedProductImage.value = selectedVariation.image;
    }

    // Assign Selected Variation
    this.selectedVariation.value = selectedVariation;

    // Update selected product variation status
    getProductVariationStockStatus();
  }

  /// -- Check if selected attributes matches any variation attributes
  bool _isSameAttributeValues(Map<String, dynamic> variationAttributes, Map<String, dynamic> selectedAttributes) {
    // if selectedAttributes contains 3 attributes and current variation contains 2 then return .
    if (variationAttributes.length != selectedAttributes.length) return false;

    //if any of the attributes is different then return. e.g. [Green , Large] x [Green , Small]
    for (final key in variationAttributes.keys) {
      // Attributes[key] = value which could be [Green , Small, Cotton] etc.
      if (variationAttributes[key] != selectedAttributes[key]) return false;
    }
    return true;
  }

  /// -- Check Attribute availability / Stock in Variation
  Set<String?> getAttributesAvailablityInVariation(List<ProductVariationModel> variations, String attributeName) {
    // Pass the variations to check which attributes are available and stock is not 0
    final availableVariationAttributeValues = 
        variations.where((variation) => variation.attributeValues!
            [attributeName] != null && variation.attributeValues![attributeName]!.isNotEmpty && variation.stock > 0)

        .map((variation) => variation.attributeValues![attributeName])
        .toSet();

    return availableVariationAttributeValues;
  }

  String getVariationPrice(){
    return (selectedVariation.value.salePrice > 0 ? selectedVariation.value.salePrice : selectedVariation.value.price).toString();
  }

  /// -- Check Product Variation Stock Status
  void getProductVariationStockStatus() {
    variationStockStatus.value = selectedVariation.value.stock > 0 ? 'In Stock' : 'Out of Stock';
  }

  /// Reset Selected Attributes when switching products
  void resetSelectedAttributes() {
    selectedAttributes.clear();
    selectedVariation.value = ProductVariationModel.empty();
    variationStockStatus.value = '';
  }
}
