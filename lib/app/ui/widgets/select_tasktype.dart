import 'package:flutter/material.dart';

import '../../../core/commons/enums/tasktype.dart';
import '../../../core/services/app_services.dart';
import '../../../utils/constants/app_colors.dart';
import '../controllers/tasks_data_provider.dart';
import '../controllers/task_wheel_ui_notifier.dart';

class SelectTasktype extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const SelectTasktype({super.key, required this.taskWheelUINotifier});

  @override
  State<SelectTasktype> createState() => _SelectTasktypeState();
}

class _SelectTasktypeState extends State<SelectTasktype> {
  late TaskType _currentTaskType ;

  @override
  void initState() {
    // TODO: implement initState
    _currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    super.initState();
  }

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
              widget.taskWheelUINotifier.currentTaskType = taskType;
            });
          },
        ),
        Text(
          taskType.name.toUpperCase(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: _currentTaskType == taskType ? AppColors.context(context).primaryColor : AppColors.context(context).textColor,
          ),
        ),
      ],
    );
  }
}
