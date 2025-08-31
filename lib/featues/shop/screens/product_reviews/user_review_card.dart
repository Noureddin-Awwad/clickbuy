import 'package:e_commerce/common/styles/rounded_container.dart';
import 'package:e_commerce/featues/shop/screens/product_reviews/widgets/rating_stars.dart';
import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/constants/sizes.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';

import '../../../../utils/constants/image_strings.dart';

class UserReviewCard extends StatelessWidget {
  const UserReviewCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(backgroundImage: AssetImage(NImage.userProfileImage1),),
                  SizedBox(width: NSizes.spaceBtwItems,),
                  Text('Nour',style: Theme.of(context).textTheme.titleLarge,),
                ],
              ),
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert)),
            ],
          ),
          SizedBox(width: NSizes.spaceBtwItems,),

          /// Review
          Row(
            children: [
              NRatingBarIndicator(rating: 4),
              SizedBox(width: NSizes.spaceBtwItems,),
              Text('01 Nov,2025', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: NSizes.spaceBtwItems,),
          ReadMoreText(
            'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!! ',
            trimLines: 3,
            trimMode: TrimMode.Line,
            trimExpandedText: 'show less',
            trimCollapsedText: 'show more',
            moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NColors.primary),
            lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NColors.primary),
          ),
          SizedBox(height: NSizes.spaceBtwItems,),


          /// Company Review
          NRoundedContainer(
            backgroundColor: dark ? NColors.darkerGrey : NColors.grey,
            child: Padding(
                padding: EdgeInsets.all(NSizes.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("N's Store",style: Theme.of(context).textTheme.titleMedium,),
                      Text('02 Nov , 2025',style: Theme.of(context).textTheme.bodyMedium,),
                    ],
                  ),
                  SizedBox(height: NSizes.spaceBtwItems,),
                  ReadMoreText(
                    'The user interface of the app is quite intuitive. I was able to navigate and make purchases seamlessly. Great job!! ',
                    trimLines: 2,
                    trimMode: TrimMode.Line,
                    trimExpandedText: 'show less',
                    trimCollapsedText: 'show more',
                    moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NColors.primary),
                    lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: NColors.primary),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: NSizes.spaceBtwSections,),
        ],
    );
  }
}
