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

  TaskWheelUINotifier({required this.wheelStreamcontroller, required this.tasksDataProvider}){
    _upToDateCurrentTasks = UpToDateCurrentTasks(tasksDataProvider.easyTasks.length > 1 ? tasksDataProvider.easyTasks : WheelTask.dummies);
    tasksDataProvider.addListener(() {
      _setUpToDateCurrentTasks();
    });
  }

  final StreamController<int> wheelStreamcontroller;
  final TasksDataProvider tasksDataProvider;
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

  static final List<WheelTask> _dummyTasks = WheelTask.dummies;
  
  UpToDateCurrentTasks _upToDateCurrentTasks = UpToDateCurrentTasks(_dummyTasks);
  UpToDateCurrentTasks get upToDateCurrentTasks => _upToDateCurrentTasks;

  void _setUpToDateCurrentTasks() {
    
    List<WheelTask> tasks = [];
    if (_currentTaskType == TaskType.easy) {
      tasks = tasksDataProvider.easyTasks;
    } else if (_currentTaskType == TaskType.medium) {
      tasks = tasksDataProvider.mediumTasks;
    } else if (_currentTaskType == TaskType.hard) {
      tasks = tasksDataProvider.hardTasks;
    } 
    // Add dummies until task length is greater than equal 2.
    int dumIndex = 0;
    while(tasks.length < 2 && (dumIndex < _dummyTasks.length)) {
      tasks.add(_dummyTasks[dumIndex]);
      dumIndex++;
    }
    _upToDateCurrentTasks = UpToDateCurrentTasks(tasks);
    notifyListeners();
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
    wheelStreamcontroller.add(_selectedIndex);
  }
}
