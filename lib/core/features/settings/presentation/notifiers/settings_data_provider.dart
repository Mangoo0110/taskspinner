import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/features/settings/domain/entity/appearence.dart';

import 'appearence_notifier.dart';
import '../../../../helpers/dekhao.dart';
import 'settings_db_actions.dart';


extension AppThemeModeExtension on ThemeMode {
  String get themeName {
    switch (this) {
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      case ThemeMode.system:
        return "System";
    }
  }

  
}

enum PrimaryColorMode {
  red,
  green,
  blue,
  yellow,
  pink,
  purple,
  orange,
  teal;

  Color get color {
    switch (this) {
      case PrimaryColorMode.red:
        return Colors.redAccent;
      case PrimaryColorMode.green:
        return Colors.lightGreenAccent;
      case PrimaryColorMode.blue:
        return Colors.blueAccent;
      case PrimaryColorMode.yellow:
        return Colors.yellowAccent;
      case PrimaryColorMode.pink:
        return Colors.pinkAccent;
      case PrimaryColorMode.purple:
        return Colors.purpleAccent;
      case PrimaryColorMode.orange:
        return Colors.deepOrangeAccent;
      case PrimaryColorMode.teal:
        return Colors.tealAccent;
    }
  }

  String get name {
    switch (this) {
      case PrimaryColorMode.red:
        return "Red";
      case PrimaryColorMode.green:
        return "Green";
      case PrimaryColorMode.blue:
        return "Blue";
      case PrimaryColorMode.yellow:
        return "Yellow";
      case PrimaryColorMode.pink:
        return "Pink";
      case PrimaryColorMode.purple:
        return "Purple";
      case PrimaryColorMode.orange:
        return "Orange";
      case PrimaryColorMode.teal:
        return "Teal";
    }
  }
  static PrimaryColorMode fromName(String name) {
    switch (name) {
      case "Red":
        return PrimaryColorMode.red;
      case "Green":
        return PrimaryColorMode.green;
      case "Blue":
        return PrimaryColorMode.blue;
      case "Yellow":
        return PrimaryColorMode.yellow;
      case "Pink":
        return PrimaryColorMode.pink;
      case "Purple":
        return PrimaryColorMode.purple;
      case "Orange":
        return PrimaryColorMode.orange;
      default:
        return PrimaryColorMode.teal;
    }
  }
}

class SettingsDataProvider extends ChangeNotifier with SettingsDBActions{

  StreamSubscription? _appearenceStreamSubscription;

  Appearence _currentAppearence = Appearence.defaultAppearence();
  Appearence get currentAppearence => _currentAppearence;


  void _setCurrentAppearence(Appearence appearence) {
    if(_currentAppearence == appearence) return;

    _currentAppearence = appearence;
    notifyListeners();
  }


  Future<void> _streamAppearence() async{
    await openDb(onError: (err){}, onDone: (){}).then((_) {
      streamAppearence(
        onError: (err){}, 
        onData: (stream){
          _appearenceStreamSubscription = stream.listen(
            (appearence) {
              dekhao(appearence.toString());
              _setCurrentAppearence(appearence);
              dekhao("Appearence updated");
            }
          );
        });
    });
  }

  ///### * Opens SETTINGS Local DB
  ///#### * Streams Appearence
  ///##### * Sets current Appearence
  Future<void> init() async{
    await _streamAppearence();
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    await _appearenceStreamSubscription?.cancel();
    super.dispose();
  }
}