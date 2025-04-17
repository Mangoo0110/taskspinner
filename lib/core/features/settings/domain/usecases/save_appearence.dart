import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:taskspinner/core/api_handler/success.dart';
import '../../../../api_handler/failure.dart';
import '../../../../usecases/usecases.dart';
import '../../presentation/notifiers/settings_data_provider.dart';
import '../entity/setting.dart';
import '../repo/settings_repo.dart';

class SaveSetting implements AsyncEitherUsecase<Success, SaveAppearenceParams> {
  final SettingsRepo  repository;

  SaveSetting(this.repository);

  @override
  Future<Either<DataCRUDFailure, Success>> call(SaveAppearenceParams params) async{
    return await repository.saveSetting(
      defaultAppearence: params.defaultAppearence,
      themeMode: params.themeMode,
      primaryColorMode: params.primaryColorMode,
      assetBackgroundImagePath: params.assetBackgroundImagePath,
      hapticImpact: params.hapticImpact,
      tickSound: params.tickSound,
    );
  }

}

class SaveAppearenceParams {
  final Setting defaultAppearence;
  final ThemeMode? themeMode;
  final PrimaryColorMode? primaryColorMode;
  final String? assetBackgroundImagePath;
  final bool? tickSound;
  final bool? hapticImpact;

  SaveAppearenceParams({
    required this.defaultAppearence,
    required this.themeMode,
    required this.primaryColorMode,
    required this.assetBackgroundImagePath,
    required this.hapticImpact,
    required this.tickSound
  });
}