import 'package:flutter/material.dart';
class LayoutUtils{

  static bool isPortrait(BuildContext context)
  {
    if (MediaQuery.of(context).orientation== Orientation.portrait) {
      return true;
    } else {
      return false;
    }
  }
  static bool isLandscape(BuildContext context)
  {
    if (MediaQuery.of(context).orientation== Orientation.landscape) {
      return true;
    } else {
      return false;
    }
  }
  static double getWidth(BuildContext context)
  {
    return MediaQuery.of(context).size.width;
  }
  static double getHeight(BuildContext context)
  {
    return MediaQuery.of(context).size.height;
  }
}