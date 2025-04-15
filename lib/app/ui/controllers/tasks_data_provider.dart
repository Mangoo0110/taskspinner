import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/helpers/dekhao.dart';
import '../../../core/commons/enums/tasktype.dart';
import '../../domain/entities/wheel_task.dart';
import 'tasks_db_actions.dart';

class TasksDataProvider extends ChangeNotifier with TasksDBActions{

  final List<WheelTask> _easyTasks = [];
  List<WheelTask> get easyTasks => _easyTasks;

  final List<WheelTask> _mediumTasks = [];
  List<WheelTask> get mediumTasks => _mediumTasks;

  final List<WheelTask> _hardTasks = [];
  List<WheelTask> get hardTasks => _hardTasks;


  StreamSubscription? _taskStreamSubscription;
  Future<void> streamTasks() async{
    await openDb(onError: (err){}, onDone: (){}).then((_) {
      streamWheelTasks(
        onError: (err){}, 
        onData: (stream){
          _taskStreamSubscription = stream.listen(
            (tasks) {
              dekhao("Updated tasks length: ${tasks.length}");
              _filterAndRestoreTasks(tasks);
            }
          );
        });
    });
  }


  
  void _filterAndRestoreTasks(List<WheelTask> tasks) {
    // Clear backdated data.
    _easyTasks.clear();
    _mediumTasks.clear();
    _hardTasks.clear();
    // Notify task data listeners.
    notifyListeners();

    // Update with updated data.
    for(final task in tasks) {
      switch (task.type) {
        case TaskType.easy:
          _easyTasks.add(task);
        case TaskType.medium:
          _mediumTasks.add(task);
        case TaskType.hard:
          _hardTasks.add(task);
      }
    }
    // Notify task data listeners.
    notifyListeners();
  }

  void removeTaskAt(int index) {
    if (index >= _easyTasks.length || index < 0) {
      dekhao("Index out of bound");
    }
    _easyTasks.removeAt(index);
    notifyListeners();
  }

  ///### Initializes local dbs
  ///
  /// * settings
  /// * tasks
  Future<void> init() async{
    await streamTasks();
  }

  @override
  void dispose() async{
    // TODO: implement dispose
    await _taskStreamSubscription?.cancel();
    super.dispose();
  }
}
