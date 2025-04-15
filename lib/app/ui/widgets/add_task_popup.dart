import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/core/commons/widgets/description_textfield.dart';

import '../../../core/commons/widgets/custom_button.dart';
import '../../../core/commons/widgets/custom_textfield.dart';
import '../../../utils/constants/app_colors.dart' show AppColors;
import '../../../utils/constants/app_sizes.dart';
import '../controllers/tasks_data_provider.dart';

class AddTaskPopup extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  final TasksDataProvider tasksNotifier;
  const AddTaskPopup({super.key, required this.tasksNotifier, required this.taskWheelUINotifier});

  @override
  State<AddTaskPopup> createState() => _AddTaskPopupState();
}

class _AddTaskPopupState extends State<AddTaskPopup> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();

  void _addTask() {
    if (_taskNameController.text.isNotEmpty) {
      widget.tasksNotifier.addTask(
        currentTaskType: widget.taskWheelUINotifier.currentTaskType,
        title: _taskNameController.text,
        details: _taskDetailsController.text,
        onDone: () {
          
        },
        onError: (errMessage) {
          // Handle error here, e.g., show a snackbar or dialog with the error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errMessage),
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
      _taskNameController.clear();
      _taskDetailsController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Dialog(
                  backgroundColor: Colors.transparent, // Transparent background for blur effect
                  child: Stack(
                    children: [
                      // The blurred background
                      Positioned.fill(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                          child: Container(
                            color: Colors.black.withAlpha(0), // Transparent background
                          ),
                        ),
                      ),
                      // The actual content of the dialog (Task selection)
                      Center(
                        child: Hero(
                          tag: "Spinner_Add",
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.context(context).popupBackgroundColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(2),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // task input
                                    _taskTitleInput(),

                                    SizedBox(height: 10),

                                    // task details input
                                    _detailsInput(constraints: constraints),
                                    
                                    SizedBox(height: 10),

                                    // add task button
                                    Container(
                                      width: constraints.maxWidth,
                                      decoration: BoxDecoration(
                                        color: AppColors.context(context).buttonColor,
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
                                                color: AppColors.context(context).buttonContentColor,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
            }
          );
      },
    );
  }

  Widget _taskTitleInput() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 60,
          width: constraints.maxWidth,
          child: CustomTextfield(
            maxLines: 2,
            hintText: "Task title",
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
        );
      },
    );
  }

  Widget _detailsInput({required BoxConstraints constraints}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 150,
          //padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: AppSizes.smallBorderRadius,
          ),
          child: DescriptionTextfield(
            maxLines: 4,
            hintText: "Task Details",
            labelText: "",
            //onSubmit: () {},
            onChanged: (text) {},
            //validationCheck: (text) {},
            controller: _taskDetailsController,
          ),
        );
      },
    );
  }
}
