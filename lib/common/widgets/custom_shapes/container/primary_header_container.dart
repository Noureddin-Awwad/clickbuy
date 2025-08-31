import 'package:flutter/material.dart';

import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class NPrimaryHeaderContainer extends StatelessWidget {
  const NPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NCurvedEdgeWidget(
      child:Container(
        color: NColors.primary,
        padding: const EdgeInsets.all(0),
        child: Stack(
          children: [
            Positioned(
                top: -150,
                right: -250,
                child: NCircularContainer(backgroundColor: NColors.textWhite.withOpacity(0.1),)),
            Positioned(
                top: 100,
                right: -300,
                child: NCircularContainer(backgroundColor: NColors.textWhite.withOpacity(0.1),)),
            child ,
          ],
        ),
      ), );
  }
}