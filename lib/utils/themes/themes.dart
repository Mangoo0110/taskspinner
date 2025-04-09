
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_theme.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    primaryTextTheme: DTextTheme.lightTextTheme,
    primaryColorLight: AppColors.light().backgroundColor,
    primaryColorDark: AppColors.light().textColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: AppColors.light().backgroundColor,
      cardColor: AppColors.light().backgroundColor,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.light().backgroundColor,
    primaryColor: AppColors.light().primaryColor,
    textTheme: DTextTheme.lightTextTheme,
    //inputDecorationTheme: DInputDecorationTheme.lightTheme,
    // iconTheme: DIconTheme.lightIconTheme,
    // appBarTheme: DAppBarTheme.lightAppBarTheme,
    // buttonTheme: DButtonTheme.lightButtonTheme,
    // bottomSheetTheme: DBottomSheetTheme.lightBottomSheetTheme,
    // checkboxTheme: DCheckboxTheme.lightCheckboxTheme,
    // bottomAppBarTheme: DBottomAppBarTheme.lightBottomAppBarTheme,
    // cardTheme: DCardTheme.lightCardTheme,
    // bottomNavigationBarTheme: DBottomNavigationBarThemes.lightBottomNavTheme,
    // tabBarTheme: DTabBarTheme.lightTabBarTheme,
    // indicatorColor: AppColors.light().backgroundColor,
    // dividerTheme: DDividerTheme.lightDividerTheme,
  );

  static ThemeData darkTheme = ThemeData(
    primaryTextTheme: DTextTheme.darkTextTheme,
    primaryColorLight: AppColors.dark().textColor,
    primaryColorDark: AppColors.dark().backgroundColor,
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch(
      backgroundColor: AppColors.dark().backgroundColor,
      cardColor: AppColors.dark().backgroundColor,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.dark().backgroundColor,
    primaryColor: AppColors.dark().primaryColor,
    textTheme: DTextTheme.darkTextTheme,
    // inputDecorationTheme: DInputDecorationTheme.darkTheme,
    // iconTheme: DIconTheme.darkIconTheme,
    // appBarTheme: DAppBarTheme.darkAppBarTheme,
    // buttonTheme: DButtonTheme.darkButtonTheme,
    // bottomSheetTheme: DBottomSheetTheme.darkBottomSheetTheme,
    // checkboxTheme: DCheckboxTheme.darkCheckboxTheme,
    // bottomAppBarTheme: DBottomAppBarTheme.darkBottomAppBarTheme,
    // cardTheme: DCardTheme.darkCardTheme,
    // tabBarTheme: DTabBarTheme.darkTabBarTheme,
    // bottomNavigationBarTheme: DBottomNavigationBarThemes.darkBottomNavTheme,
    // dividerTheme: DDividerTheme.darkDividerTheme,
    //tabBarTheme: ,
    indicatorColor: AppColors.dark().textColor,
  );
}
