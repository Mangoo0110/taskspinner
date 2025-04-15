import 'package:flutter/material.dart';
import 'package:taskspinner/core/notifiers/color_notifier.dart';
import 'package:taskspinner/core/services/app_services.dart';

class AppColors {

  // static Color _primaryColor = AppServices.currentColorNotifier.currentColor; //Color.fromARGB(255, 238, 88, 68);//Color.fromARGB(255, 58, 64, 234);
  
  static const Color _secondaryActionColor = Color.fromARGB(
    255,
    94,
    68,
    238,
  ); //Color.fromARGB(255, 58, 64, 234);
  //static const Color _actionColor =  Colors.orange;
  static AppColors _lightInstance = AppColors._internalLight();
  static AppColors _darkInstance = AppColors._internalDark();

  final Color textColor;
  final Color textGreyColor;
  final Color backgroundColor;
  final Color contentBoxColor;
  final Color contentBoxGreyColor;
  final Color iconColor; 
  // final Color primaryColor;
  static Color _primaryColor = AppServices.settingsDataProvider.currentAppearence.primaryColorMode.color;
  Color get primaryColor => _primaryColor;
  final Color secondaryAccentColor;
  final Color buttonContentColor;
  
  Color activeButtonColor = _primaryColor;
  final Color activeButtonContentColor;
  final Color inActiveButtonColor;
  final Color inActiveButtonContentColor;
  final Color buttonColor;
  final Color drawerColor;
  final Color fillColor;
  final Color hintColor;
  final Color labelColor;
  final Color focusedBorderColor;
  final Color enabledBorderColor;
  final Color borderColor;
  final Color popupBackgroundColor;
  final Color dividerColor;
  final Color tabBarColor;
  final Color shadowColor;
  final Color errorColor;

  AppColors._internalLight()
    : textColor = Colors.black,
      textGreyColor = Colors.grey.shade700,
      contentBoxColor = Colors.grey.shade200,
      contentBoxGreyColor = Colors.grey.shade200,
      backgroundColor = Colors.white,
      iconColor = Colors.black,
      //primaryColor = _actionColor,
      secondaryAccentColor = _secondaryActionColor,
      buttonColor = Colors.black,
      buttonContentColor = Colors.white,
      activeButtonContentColor = Colors.white,
      inActiveButtonContentColor = Colors.grey.shade200,
      inActiveButtonColor = Colors.grey.shade700,
      
      
      drawerColor = Colors.white,
      fillColor = Colors.transparent,
      hintColor = Colors.grey.shade700,
      labelColor = Colors.grey.shade800,
      focusedBorderColor = Colors.black, // same as text color
      enabledBorderColor = Colors.grey.shade700,
      borderColor = Colors.grey.shade700,
      dividerColor = Colors.grey.shade200,
      popupBackgroundColor = Colors.grey.shade200,
      shadowColor = const Color(0x1F000000),
      errorColor = Colors.red,
      tabBarColor = Colors.white;

  AppColors._internalDark()
    : textColor = Colors.white,
      textGreyColor = Colors.grey,
      backgroundColor = Color.fromARGB(255, 17, 22, 31),//Colors.black,
      contentBoxColor = Colors.grey.shade900,
      contentBoxGreyColor = Colors.grey.shade700,
      iconColor = Colors.white,
      //primaryColor = _actionColor,
      secondaryAccentColor = _secondaryActionColor,
      buttonColor = Colors.white,
      buttonContentColor = Colors.black,
      activeButtonContentColor = Colors.white,
      inActiveButtonContentColor = Colors.grey.shade700,
      inActiveButtonColor = Colors.grey.shade900,
      drawerColor = Colors.black,
      fillColor = Colors.transparent,
      hintColor = Colors.grey.shade400,
      labelColor = Colors.grey.shade200,
      focusedBorderColor = Colors.white, // same as text color
      enabledBorderColor = Colors.grey.shade400,
      borderColor = Colors.grey.shade400,
      dividerColor = Colors.grey.shade900,
      errorColor = Colors.red,
      popupBackgroundColor = Colors.black,
      shadowColor = const Color.fromARGB(255, 18, 18, 18),
      tabBarColor = Colors.black;

  factory AppColors.light() {
    _primaryColor = AppServices.settingsDataProvider.currentAppearence.primaryColorMode.color;
    return _lightInstance;
  }

  factory AppColors.dark() {
    _primaryColor = AppServices.settingsDataProvider.currentAppearence.primaryColorMode.color;
    return _darkInstance;
  }

  factory AppColors.context(BuildContext context) {
    _primaryColor = AppServices.settingsDataProvider.currentAppearence.primaryColorMode.color;
    return Theme.of(context).brightness == Brightness.dark
        ? _darkInstance
        : _lightInstance;
  }
}
