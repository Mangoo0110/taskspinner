import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';


class Wheel extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const Wheel({super.key, required this.taskWheelUINotifier});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  

  late TaskType currentTaskType;
  late UpToDateCurrentTasks upToDateCurrentTasks;
  int _selectedIndex = 0;


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    widget.taskWheelUINotifier.addListener(() {
      dekhao("data changed in task notifier");
      if (mounted && context.mounted && upToDateCurrentTasks != widget.taskWheelUINotifier.upToDateCurrentTasks) {
        currentTaskType = widget.taskWheelUINotifier.currentTaskType;
        dekhao("Current task type changed to $currentTaskType");
        setState(() {
          upToDateCurrentTasks = widget.taskWheelUINotifier.upToDateCurrentTasks;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    upToDateCurrentTasks =  widget.taskWheelUINotifier.upToDateCurrentTasks;
    currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: min(constraints.maxWidth, constraints.maxHeight) ,
          width: min(constraints.maxWidth, constraints.maxHeight) ,
          child: FortuneWheel(
            physics: NoPanPhysics(),
            animateFirst: false,
            // physics: CircularPanPhysics(
            //   duration: Duration(seconds: 1),
            //   curve: Curves.decelerate,
            //   allowOppositeRotationFlung: true,
            // ),
            indicators: [
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(
                  color: AppColors.context(context).textColor,
                  elevation: 6,
                ),
              ),
            ],
            onFocusItemChanged: (value) {
              // TODO:: Implement focus item changed logic
            },
            selected: widget.taskWheelUINotifier.controller.stream,
            onAnimationEnd: () {
              widget.taskWheelUINotifier.onAnimationEnd();
            },
            items:
                 widget.taskWheelUINotifier.upToDateCurrentTasks.tasks
                    .asMap() // Converts the list to a map with the index as the key
                    .map(
                      (index, task) => MapEntry(
                        index,
                        FortuneItem(
                          onTap: () {
                            dekhao(task.toString());
                          },
                          style: FortuneItemStyle(
                            color: AppColors.context(context).primaryColor.withAlpha(
                              (255 * (index + 1) / upToDateCurrentTasks.tasks.length).round(),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              task.title,
                              style: Theme.of(
                                context,
                              ).textTheme.labelLarge?.copyWith(
                                color: AppColors.context(context).textColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .values
                    .toList(),
          ),
        );
      },
    );
  }
}
