import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/commons/enums/tasktype.dart';
import '../../../core/helpers/dekhao.dart';
import '../../../core/notifiers/button_status_notifier.dart';
import '../../domain/usecases/opendb.dart';
import '../../../core/usecases/usecases.dart';
import '../../../init_dependencies.dart';

import '../../domain/entities/wheel_task.dart';
import '../../domain/usecases/delete_tasks.dart';
import '../../domain/usecases/stream_wheel_tasks.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';

mixin class TasksDBActions {
  Future<void> openDb({
    required void Function(String errMessage) onError,
    required VoidCallback onDone,
  }) async {
    return await serviceLocator<OpenWheelTaskDb>().call(NoParams()).then((rl) {
      return rl.fold((l) => onError(l.message), (r) => onDone());
    });
  }

  Future<void> addTask({
    required String title, 
    required String details, 
    required int minuteDuration,
    required ButtonStatusNotifier buttonStatusNotifier,
  }) async { 
    
    title = title.trim();
    details = details.trim();

    if (title.isEmpty) {
      dekhao("Error: Title is empty!");
      return;
    }

    WheelTask task = WheelTask(
      id: Uuid().v1(),
      title: title,
      details: details,
      minuteDuration: minuteDuration,
      createdAt: DateTime.now(),
    );
    // Set the button status to loading
    buttonStatusNotifier.setStatus(LoadingStatus(message: "Adding task..."));
    // Simulate a delay for the loading status
    return Future.delayed(const Duration(milliseconds: 500), () {}).then((_) async{
        return await serviceLocator<CreateTask>().call(task).then((rl) {
          return rl.fold((l) {
            buttonStatusNotifier.setStatus(ErrorStatus(message: l.message));
          }, (r) {
            buttonStatusNotifier.setStatus(SuccessStatus(message: "Task added successfully!"));
          });
        });
    });

  }

  Future<void> updateTask({
    required String id,
    required String? title, 
    required String? details, 
    required int? minuteDuration,
    required ButtonStatusNotifier buttonStatusNotifier,
  }) async {
    
    if (title?.isEmpty ?? false) {
      title = null;
    }

    // Set the button status to loading
    buttonStatusNotifier.setStatus(LoadingStatus(message: "Updating task..."));
    // Simulate a delay for the loading status
    return Future.delayed(const Duration(milliseconds: 500), () {}).then((_) async{
      return await serviceLocator<UpdateTask>().call(
        UpdateTaskParams(id: id, title: title, details: details, minuteDuration: minuteDuration)
      ).then((rl) {
          return rl.fold((l) {
            buttonStatusNotifier.setStatus(ErrorStatus(message: l.message));
          }, (r) {
            buttonStatusNotifier.setStatus(SuccessStatus(message: "Task updated successfully!"));
          });
        });
    });

    
  }

  Future<void> deleteTask({
    required String id,
    required ButtonStatusNotifier buttonStatusNotifier,
  }) async {
    buttonStatusNotifier.setStatus(LoadingStatus(message: "Updating task..."));
    Future.delayed(const Duration(milliseconds: 500), () {}).then((_) async{
        return await serviceLocator<DeleteTask>().call(id).then((rl) {
          return rl.fold((l) {
            buttonStatusNotifier.setStatus(ErrorStatus(message: l.message));
          }, (r) {
            buttonStatusNotifier.setStatus(SuccessStatus(message: "Task deleted successfully!"));
          });
        });
    });
    
  }

  Future<void> streamWheelTasks({
    required void Function(String errMessage) onError,
    required void Function(Stream<List<WheelTask>> tasks) onData,
  }) async {
    return await serviceLocator<StreamWheelTasks>()
        .call(NoParams())
        .fold((l) => onError(l.message), (r) => onData(r));
  }
}
