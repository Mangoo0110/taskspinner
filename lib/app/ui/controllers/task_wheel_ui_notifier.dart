import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/controllers/tasks_data_provider.dart';
import 'package:uuid/uuid.dart' show Uuid;

import '../../../core/commons/enums/tasktype.dart';
import '../../../core/helpers/dekhao.dart';
import '../../domain/entities/wheel_task.dart';

base class UpToDateCurrentTasks {
  /// 
  late final DateTime lastUpdatedAt;

  final List<WheelTask> _tasks;
  List<WheelTask> get tasks => _tasks;

  UpToDateCurrentTasks(this._tasks){
    lastUpdatedAt = DateTime.now();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UpToDateCurrentTasks) return false;
    return lastUpdatedAt == other.lastUpdatedAt && _tasks == other._tasks;
  }

  @override
  int get hashCode => Object.hash(lastUpdatedAt, _tasks);
}

class TaskWheelUINotifier extends ChangeNotifier {

  TaskWheelUINotifier({required this.controller, required this.tasksNotifier}){
    _upToDateCurrentTasks = UpToDateCurrentTasks(tasksNotifier.easyTasks);
    tasksNotifier.addListener(() {
      _setUpToDateCurrentTasks();
    });
  }

  final StreamController<int> controller;
  final TasksDataProvider tasksNotifier;
  bool _isSpinning = false;
  bool get isSpinning => _isSpinning;

  TaskType _currentTaskType = TaskType.easy;
  TaskType get currentTaskType => _currentTaskType;
  set currentTaskType(TaskType type) {
    if(_currentTaskType == type) return;

    _currentTaskType = type;
    _setUpToDateCurrentTasks();
    _selectedIndex = 0;
    dekhao("currentTaskType: $_currentTaskType");
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int? index) {
    dekhao("selectedIndex: $index");
    index = (index ?? 0) % upToDateCurrentTasks.tasks.length;

    // Handle out of index error.
    if(index >= upToDateCurrentTasks.tasks.length && index < 0) return;
    _selectedIndex = (index);
    notifyListeners();
  }

  static List<WheelTask> _dummyTasks = [
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
  

  UpToDateCurrentTasks _upToDateCurrentTasks = UpToDateCurrentTasks(_dummyTasks);
  UpToDateCurrentTasks get upToDateCurrentTasks => _upToDateCurrentTasks;

  void _setUpToDateCurrentTasks() {
    
    List<WheelTask> tasks = [];
    if (_currentTaskType == TaskType.easy) {
      tasks = tasksNotifier.easyTasks.isEmpty || tasksNotifier.easyTasks.length < 2 ? _dummyTasks : tasksNotifier.easyTasks;
    } else if (_currentTaskType == TaskType.medium) {
      tasks = tasksNotifier.mediumTasks.isEmpty || tasksNotifier.mediumTasks.length < 2 ? _dummyTasks : tasksNotifier.mediumTasks;
    } else if (_currentTaskType == TaskType.hard) {
      tasks = tasksNotifier.hardTasks.isEmpty || tasksNotifier.hardTasks.length < 2 ? _dummyTasks : tasksNotifier.hardTasks;
    } else {
      tasks = _dummyTasks;
    }
    _upToDateCurrentTasks = UpToDateCurrentTasks(tasks);
  }

  WheelTask? _luckyTask;
  WheelTask? get luckyTask => _luckyTask;
  void onAnimationEnd() {
    _isSpinning = false;
    if (_selectedIndex >= upToDateCurrentTasks.tasks.length || _selectedIndex < 0) return;
    _luckyTask = upToDateCurrentTasks._tasks[_selectedIndex];
    notifyListeners();
  }

  void spin() {
    _selectedIndex = Random().nextInt(upToDateCurrentTasks.tasks.length) % upToDateCurrentTasks.tasks.length;
    _isSpinning = true; notifyListeners();
    controller.add(_selectedIndex);
    
  }
}
