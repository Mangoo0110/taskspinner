import 'dart:convert';
import 'package:hive/hive.dart';

import '../../../core/helpers/dekhao.dart';
import '../models/wheel_task_model.dart';

abstract interface class TaskLocalDatasource {
  Future<bool> openDb();

  Stream<List<WheelTaskModel>> streamWheelTasks();

  Future<void> createTask(WheelTaskModel task);

  Future<void> updateTask({
    required String id,
    required String? title,
    required String? details,
    required int? minuteDuration,
  });

  Future<void> deleteTask(String taskId);
}

class TaskHiveImpl implements TaskLocalDatasource {
  final String _boxName = "wheeltasks";
  Box<dynamic>? _box;

  void _checkIfBoxExists() {
    if (_box == null) {
      throw Exception(
        "Hive box is not initialized. Please call openDb() first.",
      );
    }
  }

  @override
  Future<bool> openDb() async {
    //await Hive.
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
  Future<void> updateTask({
    required String id,
    required String? title,
    required String? details,
    required int? minuteDuration,
  }) async{
    _checkIfBoxExists();
    final data = _box?.get(id);
    if(data == null) throw Exception("Data doesn't exist!");
    final task = WheelTaskModel.fromMap(jsonDecode((jsonEncode(data))));
    return await _saveTask(WheelTaskModel.fromEntity(task.copyWith(
      id: id,
      title: title ?? task.title,
      details: details ?? task.details,
      minuteDuration: minuteDuration ?? task.minuteDuration,
      createdAt: task.createdAt
    )));
  }

  @override
  Future<void> createTask(WheelTaskModel task) async {
    await _saveTask(task);
  }

  Future<void> _saveTask(WheelTaskModel task) async {
    _checkIfBoxExists();
    await _box!.put(task.id, task.toMap());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _checkIfBoxExists();
    return await _box!.delete(taskId);
  }

  Stream<BoxEvent> _watchBoxChanges() {
    return _box!.watch();
  }

  @override
  Stream<List<WheelTaskModel>> streamWheelTasks() async* {
    _checkIfBoxExists();

    yield await _getWheelTasks(); // Emit initial state
    await for (final event in _watchBoxChanges()) {
      dekhao("Box changed: ${event.key} ${event.toString()}");
      yield await _getWheelTasks(); // Emit updated list on each change
    }
  }

  Future<List<WheelTaskModel>> _getWheelTasks() async {
    _checkIfBoxExists();

    final List<WheelTaskModel> tasks = [];
    for (final e in _box!.values) {
      try {
        final task = WheelTaskModel.fromMap(jsonDecode((jsonEncode(e))));
        tasks.add(task);
      } catch (e) {
        dekhao("Error while parsing task: $e");
      }
    }

    return tasks;
  }

  
}
