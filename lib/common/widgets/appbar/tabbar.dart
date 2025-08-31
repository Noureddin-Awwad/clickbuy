import 'package:e_commerce/utils/constants/colors.dart';
import 'package:e_commerce/utils/device/device_utility.dart';
import 'package:e_commerce/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class NTabBar extends StatelessWidget implements PreferredSizeWidget{
  /// if you want to add the background color to tabs you have ato wrap them in Material widget
  /// to do that you need [PreferredSize] Widget and that's why created custom class
  const NTabBar({super.key, required this.tabs});

  final List<Widget> tabs;

  @override
  Widget build(BuildContext context) {
    final dark = NHelperFumctions.isDarkMode(context);
    return Material(
      color: dark? NColors.black : NColors.white,
      child: TabBar(
          tabs: tabs,
        isScrollable: true,
        indicatorColor: NColors.primary,
        labelColor: dark? NColors.white : NColors.primary,
        unselectedLabelColor: NColors.darkerGrey,
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(NDeviceUtils.getAppBarHeight());
}
