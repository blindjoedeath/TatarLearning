import 'dart:ui';

import 'package:flutter/material.dart';

const double _keyboardK = 3 / 47;
const double _keyboardB = 47 - _keyboardK * 320;

class TatarKeyboardTheme{
  final bool isDark;
  final Color backgroundColor;
  final Color keyColor;
  final Color capsKeyColor;
  final Color selectedCapsColor;
  final TextStyle textStyle;
  final double keyboardHeight;
  final Size keySize;
  final Size keyGestureZone;

  static double keyTopMargin = 6;
  static int countOfKeysInRow = 11;
  static double keyMargin = 3;

  const TatarKeyboardTheme({@required this.isDark,
                            @required this.backgroundColor,@required this.keyColor,
                            @required this.textStyle, @required this.keyboardHeight,
                            @required this.keySize, @required this.keyGestureZone,
                            @required this.capsKeyColor, @required this.selectedCapsColor});

  static TatarKeyboardTheme of(BuildContext context){
    var isDark = MediaQuery.of(context).platformBrightness == Brightness.dark;
    var isIos = Theme.of(context).platform == TargetPlatform.iOS;

    var textStyle = DefaultTextStyle.of(context).style.copyWith(
      fontSize: isIos ? 23.2 : 26.5,
      color: isDark ? Colors.white : Colors.black,
      fontWeight: isDark ? FontWeight.w300 : FontWeight.w400, 
    );                    

    var screenWidth = MediaQuery.of(context).size.width;
    var keyWidth = (screenWidth / countOfKeysInRow) - (keyMargin * 2); 
    var keyboardHeight = _keyboardK * screenWidth + _keyboardB;

    var gestureWidth = screenWidth / TatarKeyboardTheme.countOfKeysInRow;
    var keyColor = isDark ? Color.fromARGB(255, 137, 137, 137) : Colors.white;
    
    return TatarKeyboardTheme(
      isDark: isDark,
      backgroundColor: isDark ? Color.fromARGB(255, 89, 89, 89) : Color.fromARGB(255, 208, 210, 215),
      keyColor: keyColor,
      capsKeyColor: isDark ? Color.fromARGB(255, 104, 104, 104) : Color.fromARGB(255, 170, 173, 182),
      selectedCapsColor: isDark ? Color.fromARGB(255, 221, 221, 221) : keyColor,
      textStyle: textStyle,
      keyboardHeight: keyboardHeight,
      keySize: Size(keyWidth, keyboardHeight - keyTopMargin - keyMargin),
      keyGestureZone: Size(gestureWidth, keyboardHeight),
    );         
  }
}