import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/common/widgets/products/product_price_text.dart';
import 'package:e_commerce/common/widgets/texts/product_title_text.dart';
import 'package:e_commerce/common/widgets/texts/section_heading.dart';
import 'package:e_commerce/featues/shop/models/product_model.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/product/variation_controller.dart';

class NProductAttributes extends StatelessWidget {
  const NProductAttributes({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    final controller = Get.put(VariationController());
    return Obx(
        ()=> Column(
        children: [
          /// Selected Attributes Pricing & Description
          //Display variation price and stock when some variation is selected
          if (controller.selectedVariation.value.id.isNotEmpty)
            NRoundedContainer(
              padding: EdgeInsets.all(NSizes.md),
              backgroundColor: dark ? NColors.darkerGrey : NColors.grey,
              child: Column(
                children: [
                  /// Title Price and Stock Status
                  Row(
                    children: [
                      NSectionHeading(
                        title: 'Variation',
                        showActionButton: false,
                      ),
                      SizedBox(
                        width: NSizes.spaceBtwItems,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              NProductTitleText(
                                title: 'Price : ',
                                smallSize: true,
                              ),
      
                              /// Actual Price
                              if (controller.selectedVariation.value.salePrice>0)
                              Text(
                                '\$${controller.selectedVariation.value.price}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .apply(
                                        decoration: TextDecoration.lineThrough),
                              ),
                              SizedBox(
                                width: NSizes.spaceBtwItems,
                              ),
      
                              /// Sale Price
                              NProductPriceText(price: controller.getVariationPrice()),
                            ],
                          ),
      
                          ///Stock
                          Row(
                            children: [
                              NProductTitleText(
                                title: 'Stock : ',
                                smallSize: true,
                              ),
                              Text(
                                controller.variationStockStatus.value,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
      
                  ///Variation Description
                  NProductTitleText(
                    title:controller.selectedVariation.value.description ?? '',
                    smallSize: true,
                    maxLines: 4,
                  )
                ],
              ),
            ),
          SizedBox(
            height: NSizes.spaceBtwItems,
          ),
      
          /// Attributes
          Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: product.productAttributes!
                  .map((attribute) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NSectionHeading(
                            title: attribute.name ?? '',
                            showActionButton: false,
                          ),
                          SizedBox(
                            height: NSizes.spaceBtwItems / 2,
                          ),
                          Obx(
                            () => Wrap(
                                spacing: 8,
                                children: attribute.values!.map((attributeValue) {
                                  final isSelected = controller
                                          .selectedAttributes[attribute.name] ==
                                      attributeValue;
                                  final available = controller
                                      .getAttributesAvailablityInVariation(
                                          product.productVariations!,
                                          attribute.name!)
                                      .contains(attributeValue);
                            
                                  return NChoiceChip(
                                      text: attributeValue,
                                      selected: isSelected,
                                      onSelected: available
                                          ? (selected) {
                                              if (selected && available) {
                                                controller.onAttributeSelected(
                                                    product,
                                                    attribute.name ?? '',
                                                    attributeValue);
                                              }
                                            }
                                          : null);
                                }).toList()),
                          )
                        ],
                      ))
                  .toList()),
        ],
      ),
    );
  }
}
