import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:taskspinner/core/api_handler/success.dart';
import 'package:taskspinner/core/features/settings/data/models/setting_model.dart';

import '../../../../api_handler/failure.dart';
import '../../../../api_handler/trycatch.dart';
import '../../domain/entity/setting.dart';
import '../../domain/repo/settings_repo.dart';
import '../../presentation/notifiers/settings_data_provider.dart';
import '../datasources/local/settings_local_datasources.dart';

class SettingsRepoImpl implements SettingsRepo{

  final SettingsLocalDatasource localDataSource;

  SettingsRepoImpl(this.localDataSource);

  @override
  Future<Either<DataCRUDFailure, bool>> openDb() async{
    return await asyncTryCatch<bool>(
      tryFunc: () async {
        return await localDataSource.openDb();
      }
    );
  }

  @override
Future<Either<DataCRUDFailure, Success>> saveSetting({
  required Setting defaultAppearence,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
    required bool? tickSound,
    required bool? hapticImpact,
}) async{
    return await asyncTryCatch<Success>(
      tryFunc: () async {
        return await localDataSource.saveSetting(
          defaultSetting: SettingModel.fromEntity(defaultAppearence),
          themeMode: themeMode,
          primaryColorMode: primaryColorMode,
          assetBackgroundImagePath: assetBackgroundImagePath,
          hapticImpact: hapticImpact,
          tickSound: tickSound,
        ).then((_) {
          return Success();
        });
      }
    );
  }

  @override
  Either<DataCRUDFailure, Stream<Setting>> streamSetting() {
    return tryCatch<Stream<Setting>>(
      tryFunc: () {
        return localDataSource.streamSetting();
      }
    );
  }

}