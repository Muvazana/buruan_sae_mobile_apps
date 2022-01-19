import 'package:flutter/widgets.dart';

class SizeConfig{
  static late MediaQueryData _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static late double blockHorizontal;
  static late double blockVertikal;
  static Size? size;
  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    size = _mediaQueryData.size;
    screenWidth = size!.width;
    screenHeight = size!.height;
    blockHorizontal = screenWidth! / 100;
    blockVertikal = screenHeight! / 100;
  }

  static double getWidthSize(double size){
    return blockHorizontal * size;
  }
  static double getHeightSize(double size){
    return blockVertikal * size;
  }
}