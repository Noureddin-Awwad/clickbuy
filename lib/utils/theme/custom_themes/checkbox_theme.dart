import 'package:flutter/material.dart';

///Custom Class for light and Text Themes

class NCheckBoxTheme{
  NCheckBoxTheme._(); //to avoid creating instances

/// Customizable Light Text Theme
    static CheckboxThemeData lightCheckoxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: WidgetStateProperty.resolveWith((states){
        if (states.contains(WidgetState.selected)){
          return Colors.white;
        }else{
          return Colors.black;
        }
    }),
      fillColor: WidgetStateProperty.resolveWith((states){
        if (states.contains(WidgetState.selected)){
          return Colors.blue;
        }else{
          return Colors.transparent;
        }
    }),
);


  /// Customizable dark Text Theme
  static CheckboxThemeData darkCheckoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateProperty.resolveWith((states){
      if (states.contains(WidgetState.selected)){
        return Colors.white;
      }else{
        return Colors.black;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states){
      if (states.contains(WidgetState.selected)){
        return Colors.blue;
      }else{
        return Colors.transparent;
      }
    }),
  );
}