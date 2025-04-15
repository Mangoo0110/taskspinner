import 'package:dartz/dartz.dart';
import '../../../core/helpers/dekhao.dart';
import '../models/wheel_task_model.dart';
import '../../../core/api_handler/trycatch.dart';
import '../../domain/entities/wheel_task.dart';
import '../../../core/api_handler/failure.dart';
import '../../../core/api_handler/success.dart';

import '../../domain/repo/task_repo.dart';
import '../datasources/task_local_datasource.dart';

class TaskRepoImpl implements TaskRepo {
  final TaskLocalDatasource _localDatasource;

  TaskRepoImpl(this._localDatasource);

  @override
  Future<Either<DataCRUDFailure, Success>> writeTask({
    required WheelTask task,
  }) async {
    return asyncTryCatch<Success>(
      tryFunc: () async{
        return await _localDatasource.writeTask(WheelTaskModel.fromEntity(task)).then(
          (value) {
            return Success(message: "Task added successfully");
          },
        );
      },
    );
  }

  @override
  Future<Either<DataCRUDFailure, Success>> deleteTask({
    required String taskId,
  }) async {
    return await asyncTryCatch<Success>(
      tryFunc: () async{
        return await _localDatasource.deleteTask(taskId).then((value) {
          return Success(message: "Task is deleted successfully.");
        });
      },
    );
  }

  @override
  Either<DataCRUDFailure, Stream<List<WheelTask>>> streamWheelTasks() {
    return tryCatch<Stream<List<WheelTaskModel>>>(
      tryFunc: () {
        return _localDatasource.streamWheelTasks();
      },
    );
  }
  
  @override
  Future<Either<DataCRUDFailure, bool>> openDb() async{
    return await asyncTryCatch<bool>(
      tryFunc: () async{
        dekhao("calling local db to open.");
        return await _localDatasource.openDb();
      },
    );
  }
}
