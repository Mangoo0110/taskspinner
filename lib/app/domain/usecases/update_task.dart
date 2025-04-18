import 'package:dartz/dartz.dart';

import '../../../../core/api_handler/failure.dart';
import '../../../../core/api_handler/success.dart';
import '../../../../core/usecases/usecases.dart';
import '../repo/task_repo.dart';
class UpdateTask implements AsyncEitherUsecase<Success, UpdateTaskParams> {
  final TaskRepo _repo;

  UpdateTask(this._repo);

  /// Saves the wheel task info only locally.
  @override
  Future<Either<DataCRUDFailure, Success>> call(UpdateTaskParams params) async {
    return await _repo.updateTask(
      id: params.id,
      title: params.title,
      details: params.details,
      minuteDuration: params.minuteDuration,
    );
  }
}


class UpdateTaskParams {
  final String id;
  final String? title;
  final String? details;
  final int? minuteDuration;

  UpdateTaskParams({required this.id, required this.title, required this.details, required this.minuteDuration});
}