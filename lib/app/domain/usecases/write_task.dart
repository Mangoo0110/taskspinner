import 'package:dartz/dartz.dart';
import '../entities/wheel_task.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repo/task_repo.dart';
class WriteTask implements AsyncEitherUsecase<Success, WheelTask> {
  final TaskRepo _repo;

  WriteTask(this._repo);

  /// Saves the wheel task info only locally.
  @override
  Future<Either<DataCRUDFailure, Success>> call(WheelTask params) async {
    return await _repo.writeTask(task: params);
  }
}
