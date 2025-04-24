import 'package:flutter/material.dart';
import '../../presentation/notifiers/settings_data_provider.dart';

class Setting {
  final ThemeMode themeMode;
  final PrimaryColorMode primaryColorMode;
  final String? assetBackgroundImagePath;
  final bool hapticImpact;
  final bool tickSound;

  Setting({
    required this.themeMode,
    required this.hapticImpact,
    required this.tickSound,
    required this.primaryColorMode,
    required this.assetBackgroundImagePath,
  });

  static Setting defaultSetting() {
    return Setting(
      themeMode: ThemeMode.system,
      primaryColorMode: PrimaryColorMode.blue,
      assetBackgroundImagePath: null,
      hapticImpact: false,
      tickSound: true
    );
  }

  Setting copyWith({
    ThemeMode? themeMode,
    PrimaryColorMode? primaryColorMode,
    String? assetBackgroundImagePath,
    bool? hapticImpact,
    bool? tickSound,
  }) {
    return Setting(
      themeMode: themeMode ?? this.themeMode,
      primaryColorMode: primaryColorMode ?? this.primaryColorMode,
      assetBackgroundImagePath:
          assetBackgroundImagePath ?? this.assetBackgroundImagePath,
      hapticImpact: hapticImpact ?? this.hapticImpact,
      tickSound: tickSound ?? this.tickSound
    );
  }

  @override
  String toString() {
    return 'Appearence(themeMode: $themeMode, primaryColorMode: $primaryColorMode, assetBackgroundImagePath: $assetBackgroundImagePath, hapticImpact: $hapticImpact, tickSound: $tickSound)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Setting &&
        other.themeMode == themeMode &&
        other.primaryColorMode == primaryColorMode &&
        other.assetBackgroundImagePath == assetBackgroundImagePath &&
        other.hapticImpact == hapticImpact &&
        other.tickSound == tickSound;
  }

  @override
  int get hashCode {
    return themeMode.hashCode ^
        primaryColorMode.hashCode ^
        assetBackgroundImagePath.hashCode ^
        hapticImpact.hashCode ^
        tickSound.hashCode;
  }
}
