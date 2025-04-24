import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/domain/entities/wheel_task.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/widgets/task_type_and_duration.dart';
import 'package:taskspinner/core/commons/widgets/description_textfield.dart';
import 'package:taskspinner/core/commons/widgets/save_button.dart';
import 'package:taskspinner/core/notifiers/button_status_notifier.dart';

import '../../../core/commons/widgets/custom_textfield.dart';
import '../../../core/helpers/dekhao.dart';
import '../../../core/services/app_services.dart';
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
  late int minuteDuration;
  final TextEditingController _taskNameController = TextEditingController();
  final TextEditingController _taskDetailsController = TextEditingController();

  ButtonStatusNotifier deleteStatusNotifier = ButtonStatusNotifier(initialStatus: DisabledStatus());
  ButtonStatusNotifier saveStatusNotifier = ButtonStatusNotifier(initialStatus: EnabledStatus());

  void _saveTask() async{
    if (_taskNameController.text.isNotEmpty) {
      if(widget.editingTask == null) {
          await widget.tasksDataProvider.addTask(
            minuteDuration: minuteDuration,
            title: _taskNameController.text,
            details: _taskDetailsController.text,
            buttonStatusNotifier: saveStatusNotifier,
          ).then((_) {
          });
      } else {
        await widget.tasksDataProvider.updateTask(
          buttonStatusNotifier: saveStatusNotifier,
          id: widget.editingTask!.id,
          title: _taskNameController.text,
          details: _taskDetailsController.text,
          minuteDuration: minuteDuration,
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
    minuteDuration = widget.editingTask?.minuteDuration ?? 1;
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
                onTap: () async{
                  await AppServices.physicalFeedback.availableFeedbacks();
                  if(context.mounted && mounted) {
                    Navigator.pop(context);
                  }
                  
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
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      
                                      TaskTypeAndDuration(
                                        initialDuration: minuteDuration,
                                        onChanged: (value) {
                                          minuteDuration = value;
                                        },
                                      ),
                                                                      
                                      SizedBox(height: 20,),
                                      // task input
                                      _taskTitleInput(),
                                                              
                                      SizedBox(height: 10),
                                                              
                                      // task details input
                                      _detailsInput(constraints: constraints),
                                                                      
                                      SizedBox(height: 30),
                                                              
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
                saveText: widget.editingTask == null ? "Create" : "Update",
                key: UniqueKey(),
                buttonStatusNotifier: saveStatusNotifier,
                onDone: () async{
                  await AppServices.physicalFeedback.tick();
                  if(mounted && context.mounted) Navigator.pop(context);
                },
                onSave: () async{
                  _saveTask();
                },
              ),
            ),
            // task delete button
            if(widget.editingTask != null && (saveStatusNotifier.status.runtimeType == EnabledStatus || saveStatusNotifier.status.runtimeType == DisabledStatus )) Column(
              children: [
                SizedBox(height: 10,),
                Align(
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
            maxLines: 1,
            hintText: "Task title",
            labelText: "Title",
            onSubmit: () {
            },
            onChanged: (text) {
              dekhao(text);
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
            maxLines: 10,
            hintText: "Task details",
            labelText: "Details",
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
