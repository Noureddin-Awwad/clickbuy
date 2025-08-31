import 'package:flutter/material.dart';

import '../../../../../common/widgets/products/cart/add_remove_button.dart';
import '../../../../../common/widgets/products/cart/cart_item.dart';
import '../../../../../common/widgets/products/product_price_text.dart';
import '../../../../../utils/constants/sizes.dart';

class NCartItems extends StatelessWidget {
  const NCartItems({
    super.key,
    this.showAddRemoveButtons=true,
  });

  final bool showAddRemoveButtons;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      separatorBuilder: (_, __) => SizedBox(
        height: NSizes.spaceBtwSections,
      ),
      itemCount: 2,
      itemBuilder: (_, index) => Column(
        children: [
          /// Cart Item
          NCartItem(),
          if(showAddRemoveButtons)SizedBox(
            height: NSizes.spaceBtwItems,
          ),

          /// Add Remove buttons Row with total price
          if(showAddRemoveButtons)
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(width: 70),
                  ///Add Remove buttons
                  NProductQntWithAddRemove(),
                ],
              ),
              /// Product total data
              NProductPriceText(price: '256'),
            ],
          )
        ],
      ),
    );
  }
}