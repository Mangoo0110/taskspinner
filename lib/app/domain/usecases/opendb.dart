import 'package:dartz/dartz.dart';
import '../entities/wheel_task.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repo/task_repo.dart';

class OpenWheelTaskDb implements AsyncEitherUsecase<bool, NoParams> {
  final TaskRepo _repo;

  OpenWheelTaskDb(this._repo);

  /// Saves the wheel task info only locally.
  @override
  Future<Either<DataCRUDFailure, bool>> call(NoParams params) async {
    return await _repo.openDb();
  }
}
