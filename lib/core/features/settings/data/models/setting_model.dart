import 'package:flutter/material.dart';

import '../../domain/entity/setting.dart';
import '../../presentation/notifiers/settings_data_provider.dart';

extension ToThemeMode on String {
  ThemeMode toThemeMode() {
    switch (toLowerCase()) {
      case "light":
        return ThemeMode.light;
      case "dark":
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

class SettingModel extends Setting {
  SettingModel({
    required super.themeMode,
    required super.primaryColorMode,
    required super.assetBackgroundImagePath,
    required super.hapticImpact,
    required super.tickSound,
  });

  factory SettingModel.fromMap(Map<String, dynamic> map) {
    return SettingModel(
      themeMode: (map['themeMode'] as String).toThemeMode(),
      primaryColorMode: PrimaryColorMode.fromName(
        map['primaryColorMode'] as String,
      ),
      assetBackgroundImagePath: map['assetBackgroundImagePath'],
      hapticImpact: map['hapticImpact'] == null ? false : map['hapticImpact'] as bool,
      tickSound: map['tickSound'] == null ? false : map['tickSound'] as bool,
    );
  }

  factory SettingModel.fromEntity(Setting entity) {
    return SettingModel(
      themeMode: entity.themeMode,
      primaryColorMode: entity.primaryColorMode,
      assetBackgroundImagePath: entity.assetBackgroundImagePath,
      hapticImpact: entity.hapticImpact,
      tickSound: entity.tickSound,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.name,
      'primaryColorMode': primaryColorMode.name,
      'assetBackgroundImagePath': assetBackgroundImagePath,
      'hapticImpact': hapticImpact,
      'tickSound': tickSound,
    };
  }
}
