// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// import '../../../../helpers/dekhao.dart';


// class AppearenceNotifier extends ChangeNotifier{
//   ThemeMode _currentThemeMode = ThemeMode.system;
//   ThemeMode get currentThemeMode => _currentThemeMode;
//   set currentThemeMode(ThemeMode theme) {
//     if(_currentThemeMode == theme) return;
//     _currentThemeMode = theme;
//     notifyListeners();
//   }

//   PrimaryColorMode _currentPrimaryColorMode = PrimaryColorMode.pink;
//   PrimaryColorMode get currentPrimaryColorMode => _currentPrimaryColorMode;
//   set currentPrimaryColorMode(PrimaryColorMode colorMode) {
//     dekhao("changing color mode to $colorMode");
//     if(_currentPrimaryColorMode == colorMode) return;
//     _currentPrimaryColorMode = colorMode;
//     notifyListeners();
//   }

//   Color get currentPrimaryColor => _currentPrimaryColorMode.color;


//   Uint8List? _backgroundImage;
//   Uint8List? get backgroundImage => _backgroundImage;
//   set backgroundImage(Uint8List? image) {
//     if(_backgroundImage == image) return;
//     _backgroundImage = image;
//     notifyListeners();
//   }
  
//   bool get hasBackgroundImage => _backgroundImage != null;
// }