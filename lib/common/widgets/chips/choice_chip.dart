import 'package:e_commerce/common/widgets/custom_shapes/container/circular_container.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';

class NChoiceChip extends StatelessWidget {
  const NChoiceChip({
    super.key,
    required this.text,
    required this.selected,
    this.onSelected,
  });

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    final isColor = NHelperFumctions.getColor(text) != null;
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
      child: ChoiceChip(
        label: isColor ? SizedBox() : Text(text),
        selected: selected,
        onSelected: onSelected,
        labelStyle: TextStyle(color: selected ? NColors.white: null),
        avatar: isColor
        ?NCircularContainer(width: 50,height: 50,backgroundColor: NHelperFumctions.getColor(text),)
        :null,
        shape:isColor ?  CircleBorder() :null,
        backgroundColor:isColor?  NHelperFumctions.getColor(text) : null  ,
        labelPadding:isColor ?  EdgeInsets.all(0) :null,
        padding: isColor ?  EdgeInsets.all(0) :null,

      ),
    );
  }
}