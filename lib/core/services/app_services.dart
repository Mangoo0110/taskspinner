import 'package:flutter/material.dart';

import '../../app/ui/controllers/tasks_notifier.dart';
import '../helpers/snackbar.dart';

class AppServices {
  static final TasksNotifier tasksNotifier = TasksNotifier();
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
