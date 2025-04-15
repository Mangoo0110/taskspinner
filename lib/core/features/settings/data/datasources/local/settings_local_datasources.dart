import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:taskspinner/core/features/settings/data/models/appearence_model.dart';

import '../../../../../helpers/dekhao.dart';
import '../../../presentation/notifiers/settings_data_provider.dart';

abstract interface class SettingsLocalDatasource {
  Future<bool> openDb();


  Future<void> saveAppearence({
    required AppearenceModel defaultAppearence,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
  });

  Stream<AppearenceModel> streamAppearence();
}

class SettingsHiveImpl implements SettingsLocalDatasource {
  final String _boxName = "app_settings";
  final String _appearenceKey = "appearence";
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
  Stream<AppearenceModel> streamAppearence() async* {
    _checkIfBoxExists();

    var model = await _getAppearence(); 
    if(model != null) {
      yield model; // Emit initial state
    }

    await for (final event in _watchBoxChanges()) {
      if (event.key == _appearenceKey) {
        model = await _getAppearence(); 
        if(model != null) {
          yield model; // Emit updated state
        }
      }
    }
  }

  Future<AppearenceModel?> _getAppearence() async {
    _checkIfBoxExists();

    final raw = await _box?.get("appearence");
    if(raw == null) {
      dekhao("No appearence found");
      return null;
    }
    return AppearenceModel.fromMap(jsonDecode(jsonEncode(raw)));
  }


  Future<void> _saveAppearence(AppearenceModel appearence) async {
    _checkIfBoxExists();
    dekhao("Saving appearence to local db");
    await _box?.put(appearence.id, appearence.toMap());
  }


  @override
  Future<void> saveAppearence({
    required AppearenceModel defaultAppearence,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
  }) async {

    _checkIfBoxExists();

    try {
      await _getAppearence().then((appearence) async{
        if(appearence != null) {
          await _saveAppearence(
            AppearenceModel.fromEntity(
            appearence!.copyWith(
              themeMode: themeMode,
              primaryColorMode: primaryColorMode,
              assetBackgroundImagePath: assetBackgroundImagePath,
            ))
          );
        } else {
          dekhao("Data not found, creating new one");
          await _saveAppearence(
            defaultAppearence
          );
        }
      });
    } catch (e) {
      dekhao("Data not found, creating new one $e");
      await _saveAppearence(
        defaultAppearence
      );
    }
    
  }
}
