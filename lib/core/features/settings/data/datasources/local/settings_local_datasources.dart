import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskspinner/core/features/settings/data/models/setting_model.dart';

import '../../../../../helpers/dekhao.dart';
import '../../../presentation/notifiers/settings_data_provider.dart';

abstract interface class SettingsLocalDatasource {
  Future<bool> openDb();


  Future<void> saveSetting({
    required SettingModel defaultSetting,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
    required bool? tickSound,
    required bool? hapticImpact,
  });

  Stream<SettingModel> streamSetting();
}

class SettingsHiveImpl implements SettingsLocalDatasource {
  final String _boxName = "app_settings";
  final String _onlyDataKey = "setting_key@mangoo0110";
  Box<dynamic>? _box;

  void _checkIfBoxExists() {
    if (_box == null) {
      throw Exception(
        "Hive box is not initialized. Please call openDb() first.",
      );
    }
  }

  @override
  Future<bool> openDb() async {
    dekhao("opening player box");
    try {
      _box ??= await Hive.openBox(_boxName);
      if (_box == null) {
        dekhao("_box is still null");
        return false;
      } else {
        dekhao("_box is not null and functionable ${_box?.name}");
        return true;
      }
    } catch (e) {
      dekhao("Failed to open box.. $e");
      rethrow;
    }
  }

  Stream<BoxEvent> _watchBoxChanges() {
    return _box!.watch();
  }

  @override
  Stream<SettingModel> streamSetting() async* {
    _checkIfBoxExists();

    var model = await _getSetting(); 
    if(model != null) {
      yield model; // Emit initial state
    }

    await for (final event in _watchBoxChanges()) {
      if (event.key == _onlyDataKey) {
        model = await _getSetting(); 
        if(model != null) {
          yield model; // Emit updated state
        }
      }
    }
  }

  Future<SettingModel?> _getSetting() async {
    _checkIfBoxExists();

    final raw = await _box?.get(_onlyDataKey);
    if(raw == null) {
      dekhao("Setting not found!");
      //throw Exception("Setting not found!");
      return null;
    }
    return SettingModel.fromMap(jsonDecode(jsonEncode(raw)));
  }


  Future<void> _saveSetting(SettingModel setting) async {
    _checkIfBoxExists();
    dekhao("Saving setting to local db");
    return await _box?.put(_onlyDataKey, setting.toMap());
  }


  @override
  Future<void> saveSetting({
    required SettingModel defaultSetting,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
    required bool? tickSound,
    required bool? hapticImpact,
  }) async {

    _checkIfBoxExists();

    try {
      await _getSetting().then((setting) async{
        if(setting != null) {
          await _saveSetting(
            SettingModel.fromEntity(
            setting.copyWith(
              themeMode: themeMode,
              primaryColorMode: primaryColorMode,
              assetBackgroundImagePath: assetBackgroundImagePath,
              hapticImpact: hapticImpact,
              tickSound: tickSound
            ))
          );
        } else {
          dekhao("Data not found, creating new one");
          await _saveSetting(
            defaultSetting
          );
        }
      });
    } catch (e) {
      dekhao("Data not found, creating new one $e");
      await _saveSetting(
        defaultSetting
      );
    }
    
  }
}
