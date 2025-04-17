import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/features/settings/domain/entity/setting.dart';

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
        return Colors.redAccent.shade400;
      case PrimaryColorMode.green:
        return Colors.lightGreenAccent;
      case PrimaryColorMode.blue:
        return Colors.blueAccent;
      case PrimaryColorMode.yellow:
        return Colors.lime;
      case PrimaryColorMode.pink:
        return Colors.pinkAccent;
      case PrimaryColorMode.purple:
        return Colors.deepPurpleAccent;
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

  StreamSubscription? _settingStreamSubscription;

  Setting _currentSetting = Setting.defaultSetting();
  Setting get currentSetting => _currentSetting;


  void _setCurrentSetting(Setting setting) {
    if(_currentSetting == setting) return;

    _currentSetting = setting;
    notifyListeners();
  }


  Future<void> _streamSetting() async{
    await openDb(onError: (err){}, onDone: (){}).then((_) {
      streamAppearence(
        onError: (err){}, 
        onData: (stream){
          _settingStreamSubscription = stream.listen(
            (appearence) {
              dekhao(appearence.toString());
              _setCurrentSetting(appearence);
              dekhao("Setting updated");
            }
          );
        });
    });
  }

  ///### * Opens SETTINGS Local DB
  ///#### * Streams Setting
  ///##### * Sets current Setting
  Future<void> init() async{
    await _streamSetting();
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    await _settingStreamSubscription?.cancel();
    super.dispose();
  }
}