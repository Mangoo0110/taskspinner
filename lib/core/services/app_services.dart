import 'package:flutter/material.dart';
import 'package:taskspinner/core/helpers/physical_feedback.dart';
import '../features/settings/presentation/notifiers/settings_data_provider.dart';
import '../../app/ui/controllers/tasks_data_provider.dart';
import '../helpers/snackbar.dart';

class AppServices {
  static final TasksDataProvider tasksProvider = TasksDataProvider();
  static final SettingsDataProvider settingsDataProvider = SettingsDataProvider();
  static final PhysicalFeedback physicalFeedback = PhysicalFeedback(settingsDataProvider);
  // static final AppearenceNotifier appearenceNotifier = AppearenceNotifier();


  static Future <void> init() async {
    await tasksProvider.init();
    await settingsDataProvider.init();
    await physicalFeedback.init();
  }

  Future<void> dispose() async {
    tasksProvider.dispose();
    settingsDataProvider.dispose();
    await physicalFeedback.dispose();
  }
}




class AppNotifier{
  void errorHandler({
    required SnackBarEntity errSnackBarEntity,
  }){
    ScaffoldMessenger.of(errSnackBarEntity.context).showSnackBar(
      SnackBar(
        content: Text(errSnackBarEntity.message),
      ),
    );
  }
}


