import 'package:flutter/material.dart';

import '../../../core/commons/widgets/custom_button.dart';
import '../../../core/commons/widgets/custom_textfield.dart';
import '../../domain/entities/wheel_task.dart';
import '../../../utils/constants/app_colors.dart' show AppColors;
import '../../../utils/constants/app_sizes.dart';
import '../controllers/tasks_notifier.dart';

class AddTask extends StatefulWidget {
  final TasksNotifier tasksNotifier;
  const AddTask({super.key, required this.tasksNotifier});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  TextEditingController _taskNameController = TextEditingController();
  TextEditingController _taskDetailsController = TextEditingController();

  void _addTask() {
    if (_taskNameController.text.isNotEmpty) {
      widget.tasksNotifier.addTask(
        title: _taskNameController.text,
        details: _taskDetailsController.text,
      );
      _taskNameController.clear();
      _taskDetailsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // task input
                SizedBox(
                  height: 60,
                  width: constraints.maxWidth,
                  child: CustomTextfield(
                    maxLines: 2,
                    hintText: "Task Name",
                    labelText: "",
                    onSubmit: () {
                      _addTask();
                    },
                    onChanged: (text) {
                      print(text);
                    },
                    validationCheck: (text) {},
                    controller: _taskNameController,
                  ),
                ),
                SizedBox(height: 10),
                // add task button
                Container(
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: AppColors.context(context).accentColor,
                    borderRadius: AppSizes.smallBorderRadius,
                  ),
                  child: CustomButton(
                    borderRadius: AppSizes.smallBorderRadius,
                    onTap: () {
                      _addTask();
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Add Task",
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(
                            color: AppColors.context(context).buttonTextColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
