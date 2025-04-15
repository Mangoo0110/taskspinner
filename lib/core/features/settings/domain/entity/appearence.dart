import 'package:flutter/material.dart';
import '../../presentation/notifiers/settings_data_provider.dart';

class Appearence {
  final String id = "appearence";
  final ThemeMode themeMode;
  final PrimaryColorMode primaryColorMode;
  final String? assetBackgroundImagePath;

  Appearence({required this.themeMode, required this.primaryColorMode, required this.assetBackgroundImagePath});

  static Appearence defaultAppearence() {
    return Appearence(
      themeMode: ThemeMode.system,
      primaryColorMode: PrimaryColorMode.blue,
      assetBackgroundImagePath: null,
    );
  }

  Appearence copyWith({
    ThemeMode? themeMode,
    PrimaryColorMode? primaryColorMode,
    String? assetBackgroundImagePath,
  }) {
    return Appearence(
      themeMode: themeMode ?? this.themeMode,
      primaryColorMode: primaryColorMode ?? this.primaryColorMode,
      assetBackgroundImagePath: assetBackgroundImagePath ?? this.assetBackgroundImagePath,
    );
  }

  @override
  String toString() {
    return 'Appearence(themeMode: $themeMode, primaryColorMode: $primaryColorMode, assetBackgroundImagePath: $assetBackgroundImagePath)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Appearence &&
        other.themeMode == themeMode &&
        other.primaryColorMode == primaryColorMode &&
        other.assetBackgroundImagePath == assetBackgroundImagePath;
  }

  @override
  int get hashCode => themeMode.hashCode ^ primaryColorMode.hashCode ^ assetBackgroundImagePath.hashCode;
}