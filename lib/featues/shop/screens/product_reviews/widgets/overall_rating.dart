import 'package:e_commerce/featues/shop/screens/product_reviews/widgets/rating_progress_indicator.dart';
import 'package:flutter/material.dart';

class NOverallProductRating extends StatelessWidget {
  const NOverallProductRating({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3,child: Text('4.8',style: Theme.of(context).textTheme.displayLarge,)),
        Expanded(
          flex: 7,
          child: Column(
            children: [
              NRatingProgressIndicator(text:'5' ,value: 1.0,),
              NRatingProgressIndicator(text:'4' ,value: 0.8,),
              NRatingProgressIndicator(text:'3' ,value: 0.6,),
              NRatingProgressIndicator(text:'2' ,value: 0.4,),
              NRatingProgressIndicator(text:'1' ,value: 0.2,),
            ],
          ),
        ),
      ],
    );
  }
}