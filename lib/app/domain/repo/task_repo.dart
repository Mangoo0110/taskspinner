import 'package:dartz/dartz.dart';

import '../../../core/api_handler/failure.dart';
import '../../../core/api_handler/success.dart';
import '../entities/wheel_task.dart';

abstract interface class TaskRepo {
  /// Opens the database and returns a bool indicating whether the operation was successful.
  Future<Either<DataCRUDFailure, bool>> openDb();
  
  /// Writes a task to the database and returns a [Success] if the operation was successful.
  Future<Either<DataCRUDFailure, Success>> writeTask({required WheelTask task});

  /// Deletes a task from the database and returns a [Success] if the operation was successful.
  Future<Either<DataCRUDFailure, Success>> deleteTask({required String taskId});

  /// Returns a stream of tasks from the database.
  Either<DataCRUDFailure, Stream<List<WheelTask>>> streamWheelTasks();
}
