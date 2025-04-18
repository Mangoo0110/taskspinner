import 'package:dartz/dartz.dart';

import '../../../core/api_handler/failure.dart';
import '../../../core/api_handler/success.dart';
import '../entities/wheel_task.dart';

abstract interface class TaskRepo {
  /// Opens the database and returns a bool indicating whether the operation was successful.
  Future<Either<DataCRUDFailure, bool>> openDb();
  
  /// Writes a task to the database and returns a [Success] if the operation was successful.
  Future<Either<DataCRUDFailure, Success>> createTask({required WheelTask task});

  Future<Either<DataCRUDFailure, Success>> updateTask({
    required String id,
    required String? title,
    required String? details,
    required int? minuteDuration,
  });

  /// Deletes a task from the database and returns a [Success] if the operation was successful.
  Future<Either<DataCRUDFailure, Success>> deleteTask({required String taskId});

  /// Returns a stream of tasks from the database.
  Either<DataCRUDFailure, Stream<List<WheelTask>>> streamWheelTasks();
}
