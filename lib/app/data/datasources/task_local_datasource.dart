import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import '../../../core/helpers/dekhao.dart';
import '../models/wheel_task_model.dart';

abstract interface class TaskLocalDatasource {
  Future<bool> openDb();
  Stream<List<WheelTaskModel>> streamWheelTasks();
  Future<void> writeTask(WheelTaskModel task);
  Future<void> deleteTask(String taskId);
}

class TaskHiveImpl implements TaskLocalDatasource {
  final String _boxName = "wheeltasks";
  Box? _box;

  void _checkIfBoxExists() {
    if (_box == null) {
      throw Exception(
        "Hive box is not initialized. Please call openDb() first.",
      );
    }
  }

  @override
  Future<bool> openDb() async {
    dekhao("opening player box");
    try {
      _box ??= await Hive.openBox(_boxName);
      if (_box == null) {
        dekhao("_box is still null");
        return false;
      } else {
        dekhao("_box is not null and functionable ${_box?.name}");
        return true;
      }
    } catch (e) {
      dekhao("Failed to open box.. $e");
      rethrow;
    }
  }

  @override
  Future<void> writeTask(WheelTaskModel task) async {
    _checkIfBoxExists();
    await _box!.put(task.id, task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _checkIfBoxExists();
    await _box!.delete(taskId);
  }

  Stream<BoxEvent> _watchBoxChanges() {
    return _box!.watch();
  }

  @override
  Stream<List<WheelTaskModel>> streamWheelTasks() async* {
    _checkIfBoxExists();

    yield await _getWheelTasks(); // Emit initial state
    await for (final _ in _watchBoxChanges()) {
      yield await _getWheelTasks(); // Emit updated list on each change
    }
  }

  Future<List<WheelTaskModel>> _getWheelTasks() async {
    _checkIfBoxExists();

    final List<WheelTaskModel> tasks = [];
    for (final e in _box!.values) {
      try {
        final task = WheelTaskModel.fromMap(e);
        tasks.add(task);
      } catch (e) {
        dekhao("Error while parsing task: $e");
      }
    }

    return tasks;
  }
}
