import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../../styles/rounded_container.dart';

class NCouponCode extends StatelessWidget {
  const NCouponCode({
    super.key,

  });



  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return NRoundedContainer(
      showBorder: true,
      backgroundColor: dark ? NColors.dark : NColors.white,
      padding: EdgeInsets.only(
          top: NSizes.sm,
          bottom: NSizes.sm,
          right: NSizes.sm,
          left: NSizes.md),
      child: Row(
        children: [
          /// TextField
          Flexible(
              child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Have a promo code ? Enter here',
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ))),

          /// Button
          SizedBox(
              width: 80,
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: dark? NColors.white.withOpacity(0.5):NColors.dark.withOpacity(0.5),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    side: BorderSide(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Text('Apply'))),
        ],
      ),
    );
  }
}