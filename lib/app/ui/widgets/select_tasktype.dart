import 'package:flutter/material.dart';

import '../../../core/commons/enums/tasktype.dart';
import '../../../core/services/app_services.dart';
import '../../../utils/constants/app_colors.dart';
import '../controllers/tasks_notifier.dart';

class SelectTasktype extends StatefulWidget {
  const SelectTasktype({super.key});

  @override
  State<SelectTasktype> createState() => _SelectTasktypeState();
}

class _SelectTasktypeState extends State<SelectTasktype> {
  TaskType _currentTaskType = AppServices.tasksNotifier.currentTaskType;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: TaskType.values.map(
            (taskType) => Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: _taskTypeSelector(taskType),
                ),
              ],
            ),
          ).toList(),
        );
      },
    );
  }

  Widget _taskTypeSelector(TaskType taskType) {
    return Row(
      children: [
        Checkbox(
          value: _currentTaskType == taskType,
          onChanged: (val) {
            setState(() {
              _currentTaskType = taskType;
              AppServices.tasksNotifier.currentTaskType = taskType;
            });
          },
        ),
        Text(
          taskType.name.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _currentTaskType == taskType ? AppColors.context(context).accentColor : AppColors.context(context).textColor,
          ),
        ),
      ],
    );
  }
}
