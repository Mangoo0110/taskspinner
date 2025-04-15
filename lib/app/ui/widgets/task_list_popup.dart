import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/widgets/task_list.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';

import '../controllers/task_wheel_ui_notifier.dart';

class TaskListPopup extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const TaskListPopup({super.key, required this.taskWheelUINotifier});

  @override
  State<TaskListPopup> createState() => _TaskListPopupState();
}

class _TaskListPopupState extends State<TaskListPopup> {

  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SafeArea(
            child: Dialog(
              alignment: Alignment.topCenter,
              backgroundColor: Colors.transparent,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                      child: Container(
                        color: Colors.black.withAlpha(0),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.transparent,
                    child: Hero(
                      tag: "TaskListPopup",
                      
                      child: GestureDetector(
                        onTap: () {
                          
                        },
                        child: Container(
                          //duration: const Duration(milliseconds: 900),
                          padding: const EdgeInsets.only(top: 20.0),
                          decoration: BoxDecoration(
                            color: AppColors.context(context).popupBackgroundColor,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: CustomScrollView(
                            shrinkWrap: true,
                            slivers: [
                              SliverAppBar(
                                automaticallyImplyLeading: false,
                                backgroundColor: Colors.transparent,
                                pinned: true,
                                title: SizedBox(width: constraints.maxWidth, child: TaskTypeSegment(taskWheelUINotifier: widget.taskWheelUINotifier,))),
                              SliverToBoxAdapter(
                                child: TaskList(taskWheelUINotifier: widget.taskWheelUINotifier)
                              ),
                                            
                              // Add your task list here
                              // For example, a ListView of tasks
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class TaskTypeSegment extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const TaskTypeSegment({super.key, required this.taskWheelUINotifier});

  @override
  State<TaskTypeSegment> createState() => _TaskTypeSegmentState();
}

class _TaskTypeSegmentState extends State<TaskTypeSegment> {

  late TaskType currentTaskType;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    widget.taskWheelUINotifier.addListener(() {
      if (mounted && context.mounted && currentTaskType != widget.taskWheelUINotifier.currentTaskType) {
        currentTaskType = widget.taskWheelUINotifier.currentTaskType;
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SegmentedButton(
          multiSelectionEnabled: false,
          onSelectionChanged: (p0) {
            widget.taskWheelUINotifier.currentTaskType = p0.last;
            
          },
          style: ButtonStyle(
            backgroundColor: WidgetStateColor.resolveWith( (states) {
              if(states.isEmpty) {
                return Colors.transparent;
              }
              switch(states.first) {
                case WidgetState.pressed:
                  return AppColors.context(context).primaryColor.withAlpha(50);
                case WidgetState.selected:
                  return AppColors.context(context).primaryColor;
                default:
                  return Colors.transparent;
              }
            }),
            fixedSize: WidgetStatePropertyAll(Size(constraints.maxWidth, 40)),
            minimumSize: WidgetStatePropertyAll(Size(constraints.maxWidth, 40)),
          ),
          segments: List<ButtonSegment<TaskType>>.from( 
            TaskType.values
              .map((taskType) => ButtonSegment<TaskType>(
                    value: taskType,
                    label: SizedBox(
                      width: constraints.maxWidth / 3 - 10,
                      child: Center(child: Text(taskType.name))),
                  ))
              .toList()),
        
          selected: {widget.taskWheelUINotifier.currentTaskType}
        );
      }
    );

  }
}