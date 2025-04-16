import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/domain/entities/wheel_task.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/core/commons/widgets/description_textfield.dart';
import 'package:taskspinner/core/commons/widgets/save_button.dart';
import 'package:taskspinner/core/notifiers/button_status_notifier.dart';

import '../../../core/commons/widgets/custom_textfield.dart';
import '../../../core/helpers/dekhao.dart';
import '../../../utils/constants/app_colors.dart' show AppColors;
import '../../../utils/constants/app_sizes.dart';
import '../controllers/tasks_data_provider.dart';
import '../../../core/commons/widgets/delete_button.dart';

class EditTaskPopup extends StatefulWidget {
  final WheelTask? editingTask;
  final TaskWheelUINotifier taskWheelUINotifier;
  final TasksDataProvider tasksDataProvider;
  const EditTaskPopup({super.key, this.editingTask, required this.tasksDataProvider, required this.taskWheelUINotifier});

  @override
  State<EditTaskPopup> createState() => _EditTaskPopupState();
}

class _EditTaskPopupState extends State<EditTaskPopup> {
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();

  ButtonStatusNotifier deleteStatusNotifier = ButtonStatusNotifier(initialStatus: DisabledStatus());
  ButtonStatusNotifier saveStatusNotifier = ButtonStatusNotifier(initialStatus: EnabledStatus());

  void _saveTask() async{
    if (_taskNameController.text.isNotEmpty) {
      if(widget.editingTask == null) {
          await widget.tasksDataProvider.addTask(
            currentTaskType: widget.taskWheelUINotifier.currentTaskType,
            title: _taskNameController.text,
            details: _taskDetailsController.text,
            buttonStatusNotifier: saveStatusNotifier,
          ).then((_) {
            _taskNameController.clear();
            _taskDetailsController.clear();
          });
      } else {
        await widget.tasksDataProvider.updateTask(
          buttonStatusNotifier: saveStatusNotifier,
          id: widget.editingTask!.id,
          title: _taskNameController.text,
          details: _taskDetailsController.text,
          currentTaskType: widget.taskWheelUINotifier.currentTaskType,
        );
      }
    }
  }

  void _deleteTask() {
    if (widget.editingTask != null) {
      widget.tasksDataProvider.deleteTask(
        buttonStatusNotifier: deleteStatusNotifier,
        id: widget.editingTask!.id,
      );
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    _taskNameController.text = widget.editingTask?.title ?? "";
    _taskDetailsController.text = widget.editingTask?.details ?? "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        dekhao("editing task is ${widget.editingTask?.toString()}");
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
                          tag: widget.editingTask == null ? "AddTaskPopup" : "EditTaskPopup${widget.editingTask!.id}",
                          child: Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              onTap: () {
                                
                              },
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
                              
                                      (widget.editingTask?.isDummy ?? false) 
                                      ? Container(
                                          height: 50,
                                          width: constraints.maxWidth,
                                          decoration: BoxDecoration(
                                            color: AppColors.context(context).inActiveButtonColor,
                                            borderRadius: AppSizes.maxCircularRadius,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Dummy Task!",
                                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                                color: AppColors.context(context).inActiveButtonContentColor,
                                              ),
                                            ),
                                          )
                                      ) 
                                      : _saveDeleteButtons(),
                                      
                                    ],
                                  ),
                                          
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

  Widget _saveDeleteButtons() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // add task button
            Container(
              height: 50,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: AppColors.context(context).buttonColor,
                borderRadius: AppSizes.smallBorderRadius,
              ),
              child: SaveButton(
                key: UniqueKey(),
                buttonStatusNotifier: saveStatusNotifier,
                onDone: () {
                  Navigator.pop(context);
                },
                onSave: () async{
                  _saveTask();
                },
              ),
            ),

            SizedBox(height: 10,),

            // task delete button
            if(widget.editingTask != null) Align(
              alignment: Alignment.centerRight, 
              child: DeleteButton(
                key: UniqueKey(),
                buttonStatusNotifier: deleteStatusNotifier,
                onDelete: () {
                  /// TODO: implement delete task functionality
                  _deleteTask();
                },
                onDone: () async{
                  Navigator.pop(context);
                },
              )
            ),
          ],
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
