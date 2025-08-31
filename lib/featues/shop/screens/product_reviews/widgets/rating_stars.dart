import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';

class NRatingBarIndicator extends StatelessWidget {
  const NRatingBarIndicator({
    super.key, required this.rating,
  });
  final double rating;


  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        rating: rating,
        itemSize: 20,
        unratedColor: NColors.grey,
        itemBuilder: (_,__) => Icon(Iconsax.star1,color: NColors.primary,)
    );
  }
}