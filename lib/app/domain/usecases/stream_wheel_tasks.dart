import 'package:dartz/dartz.dart';
import '../entities/wheel_task.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repo/task_repo.dart';

class StreamWheelTasks
    implements EitherUsecase<Stream<List<WheelTask>>, NoParams> {
  final TaskRepo _repo;

  StreamWheelTasks(this._repo);

  /// Streams the wheel tasks from the database.
  @override
  Either<DataCRUDFailure, Stream<List<WheelTask>>> call(NoParams params) {
    return _repo.streamWheelTasks();
  }
}
