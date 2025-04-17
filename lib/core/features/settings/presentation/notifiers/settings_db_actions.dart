import 'dart:async';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/features/settings/domain/usecases/open_settings_db.dart';
import 'package:taskspinner/core/features/settings/domain/usecases/save_appearence.dart';
import 'package:taskspinner/core/features/settings/presentation/notifiers/settings_data_provider.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import '../../domain/entity/setting.dart';
import '../../domain/usecases/stream_appearence.dart';
import '../../../../usecases/usecases.dart';
import '../../../../../init_dependencies.dart';

mixin class SettingsDBActions {
  Future<void> openDb({
    required void Function(String errMessage) onError,
    required VoidCallback onDone,
  }) async {
    return await serviceLocator<OpenSettingsDb>().call(NoParams()).then((rl) {
      return rl.fold((l) => onError(l.message), (r) => onDone());
    });
  }


  Future<void> saveSetting({
    ThemeMode? themeMode,
    PrimaryColorMode? primaryColorMode,
    String? assetBackgroundImagePath,    
    bool? tickSound,
    bool? hapticImpact,
    void Function(String errMessage)? onError,
    VoidCallback? onDone,
  }) async { 
    return await serviceLocator<SaveSetting>().call(
      SaveAppearenceParams(
        defaultAppearence: Setting.defaultSetting(),
        themeMode: themeMode,
        primaryColorMode: primaryColorMode,
        assetBackgroundImagePath: assetBackgroundImagePath,
        hapticImpact: hapticImpact,
        tickSound: tickSound,
      ),
    ).then((rl) {
      return rl.fold(
        (l) {
          dekhao("Failed to save setting ${l.message}");
          return onError == null ? null : onError(l.message);
        }, 
        (r) => onDone == null ? null : onDone());
    });
  }
  
  Future<void> streamAppearence({
    required void Function(String errMessage) onError,
    required void Function(Stream<Setting> appearence) onData,
  }) async {
    return await serviceLocator<StreamAppearence>()
        .call(NoParams())
        .fold((l) => onError(l.message), (r) => onData(r));
  }

}

