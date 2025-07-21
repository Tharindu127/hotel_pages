import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles{

  static TextStyle appBarTextStyle = TextStyle(
    fontSize: 32,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );

  static TextStyle primaryTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
    color: AppColors.white,
  );

  static TextStyle primaryBoldTextStyle = TextStyle(
    fontSize: 16,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  static TextStyle secondaryTextStyle(Color color) => TextStyle(
    fontSize: 12,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.normal,
    color: color,
  );
}