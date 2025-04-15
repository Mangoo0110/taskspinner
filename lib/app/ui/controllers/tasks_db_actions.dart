import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../core/commons/enums/tasktype.dart';
import '../../../core/helpers/dekhao.dart';
import '../../domain/usecases/opendb.dart';
import '../../../core/usecases/usecases.dart';
import '../../../init_dependencies.dart';

import '../../domain/entities/wheel_task.dart';
import '../../domain/usecases/delete_tasks.dart';
import '../../domain/usecases/stream_wheel_tasks.dart';
import '../../domain/usecases/write_task.dart';

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
    required TaskType currentTaskType,
    required void Function(String errMessage) onError,
    required VoidCallback onDone,
  }) async { 
    
    title = title.trim();
    details = details.trim();

    if (title.isEmpty) {
      dekhao("Error: Title is empty!");
      return;
    }

    WheelTask task = WheelTask(
      id: Uuid().v1(),
      type: currentTaskType,
      title: title,
      details: details,
      createdAt: DateTime.now(),
    );

    return await serviceLocator<WriteTask>().call(task).then((rl) {
      return rl.fold((l) => onError(l.message), (r) => onDone());
    });
  }

  Future<void> updateTask({
    required String id,
    required String title, 
    required String details, 
    required TaskType currentTaskType,
    required void Function(String errMessage) onError,
    required VoidCallback onDone,
  }) async { 
    
    title = title.trim();
    details = details.trim();

    if (title.isEmpty) {
      dekhao("Error: Title is empty!");
      return;
    }

    WheelTask task = WheelTask(
      id: id,
      type: currentTaskType,
      title: title,
      details: details,
      createdAt: DateTime.now(),
    );

    return await serviceLocator<WriteTask>().call(task).then((rl) {
      return rl.fold((l) => onError(l.message), (r) => onDone());
    });
  }

  Future<void> deleteTask({
    required String id,
    required void Function(String errMessage) onError,
    required VoidCallback onDone,
  }) async {
    return await serviceLocator<DeleteTask>().call(id).then((rl) {
      return rl.fold((l) => onError(l.message), (r) => onDone());
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
