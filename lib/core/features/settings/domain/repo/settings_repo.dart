
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../api_handler/failure.dart';
import '../../../../api_handler/success.dart';
import '../../presentation/notifiers/settings_data_provider.dart';
import '../entity/appearence.dart';



abstract interface class SettingsRepo {
  /// Open the local database.
  Future<Either<DataCRUDFailure, bool>> openDb();
  /// Save the appearance settings.
  /// Returns a [Success] object on success or a [DataCRUDFailure] on failure.
  /// [appearence] is the appearance settings to be saved.
  /// Throws [Exception] if the database is not opened.
  /// [openDb] must be called before this method.
  Future<Either<DataCRUDFailure, Success>> saveAppearence({
    required Appearence defaultAppearence,
    required ThemeMode? themeMode,
    required PrimaryColorMode? primaryColorMode,
    required String? assetBackgroundImagePath,
  });
  
  /// Stream the appearance settings.
  /// Returns a [Stream] of [Appearence] objects.
  /// [openDb] must be called before this method.
  /// Throws [Exception] if the database is not opened.
  Either<DataCRUDFailure, Stream<Appearence>> streamAppearence();
}