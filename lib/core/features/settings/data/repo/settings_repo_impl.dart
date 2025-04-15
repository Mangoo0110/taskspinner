import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:taskspinner/core/api_handler/success.dart';
import 'package:taskspinner/core/features/settings/data/models/appearence_model.dart';

import '../../../../api_handler/failure.dart';
import '../../../../api_handler/trycatch.dart';
import '../../domain/entity/appearence.dart';
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
Future<Either<DataCRUDFailure, Success>> saveAppearence({
  required Appearence defaultAppearence,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
}) async{
    return await asyncTryCatch<Success>(
      tryFunc: () async {
        return await localDataSource.saveAppearence(
          defaultAppearence: AppearenceModel.fromEntity(defaultAppearence),
          themeMode: themeMode,
          primaryColorMode: primaryColorMode,
          assetBackgroundImagePath: assetBackgroundImagePath,).then((_) {
          return Success();
        });
      }
    );
  }

  @override
  Either<DataCRUDFailure, Stream<Appearence>> streamAppearence() {
    return tryCatch<Stream<Appearence>>(
      tryFunc: () {
        return localDataSource.streamAppearence();
      }
    );
  }

}