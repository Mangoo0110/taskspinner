import 'package:flutter/material.dart';
import '../../../core/helpers/dekhao.dart';
import 'package:uuid/uuid.dart';

import '../../../core/commons/enums/tasktype.dart';
import '../../domain/entities/wheel_task.dart';
import 'tasks_db_actions.dart';

class TasksNotifier extends ChangeNotifier with TasksDBActions {
  int _thresold = 14;
  double startAngle = 0;

  TaskType _currentTaskType = TaskType.easy;
  TaskType get currentTaskType => _currentTaskType;
  set currentTaskType(TaskType type) {
    _currentTaskType = type;
    _selectedIndex = 0;
    notifyListeners();
  }

  int? _selectedIndex = 0;
  int? get selectedIndex => _selectedIndex;
  set selectedIndex(int? index) {
    dekhao("selectedIndex: $index");
    index = (index ?? 0) % tasks.length;
    _selectedIndex = (index);
    notifyListeners();
  }

  final List<WheelTask> _dummyTasks = [
    WheelTask(
      id: Uuid().v1(),
      type: TaskType.easy,
      title: "Relax",
      details: "Only chill",
      createdAt: DateTime.now(),
    ),
    WheelTask(
      id: Uuid().v1(),
      type: TaskType.easy,
      title: "Exercise",
      details: "Start with a walk, then stretch, then do some yoga",
      createdAt: DateTime.now(),
    ),
  ];

  final List<WheelTask> _easyTasks = [];

  final List<WheelTask> _mediumTasks = [];
  final List<WheelTask> _hardTasks = [];

  List<WheelTask> get tasks {
    switch (_currentTaskType) {
      case TaskType.easy:
        return _easyTasks.isEmpty ? _dummyTasks : _easyTasks;

      case TaskType.medium:
        return _mediumTasks.isEmpty ? _dummyTasks : _mediumTasks;

      case TaskType.hard:
        return _hardTasks.isEmpty ? _dummyTasks : _hardTasks;
    }
  }

  String? addTask({required String title, required String details}) {
    if (_thresold <= _easyTasks.length) {
      return "Thresold reached. Need bigger screen";
    }

    title = title.trim();
    details = details.trim();

    if (title.isEmpty) {
      return "Title is empty!";
    }

    WheelTask task = WheelTask(
      id: Uuid().v1(),
      type: _currentTaskType,
      title: title,
      details: details,
      createdAt: DateTime.now(),
    );
      writeTask(
      task: task, 
      onError: (errMessage) {
        //return errMessage;
      },   
      onDone: () {

      });
  }

  void removeTaskAt(int index) {
    if (index >= _easyTasks.length || index < 0) {
      print("Index out of bound");
    }
    _easyTasks.removeAt(index);
    notifyListeners();
  }
}
