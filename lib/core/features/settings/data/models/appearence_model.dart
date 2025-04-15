import 'package:flutter/material.dart';

import '../../domain/entity/appearence.dart';
import '../../presentation/notifiers/appearence_notifier.dart';
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


class AppearenceModel extends Appearence{
  AppearenceModel({required super.themeMode, required super.primaryColorMode, required super.assetBackgroundImagePath});

  factory AppearenceModel.fromMap(Map<String, dynamic> map) {
    return AppearenceModel(
      themeMode: (map['themeMode'] as String).toThemeMode(),
      primaryColorMode: PrimaryColorMode.fromName(map['primaryColorMode'] as String),
      assetBackgroundImagePath: map['assetBackgroundImagePath'],
    );
  }

  factory AppearenceModel.fromEntity(Appearence entity) {
    return AppearenceModel(
      themeMode: entity.themeMode,
      primaryColorMode: entity.primaryColorMode,
      assetBackgroundImagePath: entity.assetBackgroundImagePath,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'themeMode': themeMode.name,
      'primaryColorMode': primaryColorMode.name,
      'assetBackgroundImagePath': assetBackgroundImagePath,
    };
  }
}