import 'package:dartz/dartz.dart';
import '../entities/wheel_task.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repo/task_repo.dart';

class DeleteTask implements AsyncEitherUsecase<Success, String> {
  final TaskRepo _repo;

  DeleteTask(this._repo);

  /// Saves the wheel task info only locally.
  @override
  Future<Either<DataCRUDFailure, Success>> call(String id) async {
    return await _repo.deleteTask(taskId: id);
  }
}
