import 'package:dartz/dartz.dart';
import '../../../../api_handler/failure.dart';
import '../../../../usecases/usecases.dart';
import '../repo/settings_repo.dart';

class OpenSettingsDb implements AsyncEitherUsecase<bool, NoParams> {
  final SettingsRepo  repository;

  OpenSettingsDb(this.repository);

  @override
  Future<Either<DataCRUDFailure, bool>> call(NoParams params) async{
    return await repository.openDb();
  }

}