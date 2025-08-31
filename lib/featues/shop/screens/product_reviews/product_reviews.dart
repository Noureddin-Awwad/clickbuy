import 'package:e_commerce/common/widgets/appbar/appbar.dart';
import 'package:e_commerce/featues/shop/screens/product_reviews/user_review_card.dart';
import 'package:e_commerce/featues/shop/screens/product_reviews/widgets/overall_rating.dart';
import 'package:e_commerce/featues/shop/screens/product_reviews/widgets/rating_stars.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/sizes.dart';

class ProductReviewsScreen extends StatelessWidget {
  const ProductReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// Appbar
      appBar: NAppBar(title: Text('Reviews & Rating'),showBackArrow: true,),
      /// Body
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(NSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ratings and reviews are verified and are from people who use the same type of device that you use."),
              SizedBox(height: NSizes.spaceBtwItems,),

              /// Overall Product Ratings
              NOverallProductRating(),
              NRatingBarIndicator(rating: 3.5,),
              Text("12,611",style: Theme.of(context).textTheme.bodySmall,),
              SizedBox(height: NSizes.spaceBtwSections,),

              ///User Reviews List
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
              UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}


