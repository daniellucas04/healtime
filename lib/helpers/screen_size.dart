import 'package:flutter/material.dart';

class ScreenSize {
  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double wp(BuildContext context, double percent) =>
      width(context) * percent;

  static double hp(BuildContext context, double percent) =>
      height(context) * percent;
}
