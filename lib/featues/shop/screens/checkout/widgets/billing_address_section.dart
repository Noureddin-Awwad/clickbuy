import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../../common/widgets/texts/section_heading.dart';

class NBillingAddressSection extends StatelessWidget {
  const NBillingAddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        NSectionHeading(title: 'Shipping Address',buttonTitle: 'Change', onPressed: (){},),
        Text('Noureddin Awwad',style: Theme.of(context).textTheme.bodyLarge,),

        SizedBox(height: NSizes.spaceBtwItems/2,),

        
        Row(
          children: [
            Icon(Icons.phone,color: Colors.grey,size: 16,),
            SizedBox(width: NSizes.spaceBtwItems,),
            Text('+961 76366384',style: Theme.of(context).textTheme.bodyMedium,),
          ],
        ),
        SizedBox(height: NSizes.spaceBtwItems/2,),

        Row(
          children: [
            Icon(Icons.location_history,color: Colors.grey,size: 16,),
            SizedBox(width: NSizes.spaceBtwItems,),
            Text('South Lebanon, Chebaa, Lebanon',style: Theme.of(context).textTheme.bodyMedium,softWrap: true,),
          ],
        ),
      ],
    );
  }
}
