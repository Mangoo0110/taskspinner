import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/controllers/tasks_data_provider.dart';
import 'package:taskspinner/app/ui/popups/edit_stask_popup.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/core/features/settings/domain/entity/setting.dart';
import '../../../core/features/settings/presentation/notifiers/settings_data_provider.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';

import '../../../core/helpers/physical_feedback.dart';
import '../../../core/services/app_services.dart';


class Wheel extends StatefulWidget {
  final PhysicalFeedback physicalFeedback;
  final TasksDataProvider tasksDataProvider;
  final SettingsDataProvider settingsDataProvider;
  final TaskWheelUINotifier taskWheelUINotifier;
  const Wheel({super.key, required this.taskWheelUINotifier, required this.physicalFeedback, required this.tasksDataProvider, required this.settingsDataProvider});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  

  late TaskType currentTaskType;
  late UpToDateCurrentTasks upToDateCurrentTasks;
  late Setting setting;
  DateTime lastTickTime = DateTime.now();
  final Duration minTickInterval = Duration(milliseconds: 50); 


  @override
  void didChangeDependencies() {
    widget.taskWheelUINotifier.addListener(() {
      dekhao("data changed in task notifier");
      if (mounted && context.mounted && upToDateCurrentTasks.lastUpdatedAt != widget.taskWheelUINotifier.upToDateCurrentTasks.lastUpdatedAt) {
        currentTaskType = widget.taskWheelUINotifier.currentTaskType;
        dekhao("Current task type changed to $currentTaskType");
        setState(() {
          upToDateCurrentTasks = widget.taskWheelUINotifier.upToDateCurrentTasks;
        });
      }
    });

    // Listen to settings data provider too 
    widget.settingsDataProvider.addListener(() {
      dekhao("data changed in settings notifier");
      if (mounted && context.mounted && setting != widget.settingsDataProvider.currentSetting) {
        setting = widget.settingsDataProvider.currentSetting;
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  

  @override
  void initState() {
    upToDateCurrentTasks =  widget.taskWheelUINotifier.upToDateCurrentTasks;
    currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    setting = widget.settingsDataProvider.currentSetting;
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
          child:  
            FortuneWheel(
              hapticImpact: HapticImpact.heavy,
              physics: NoPanPhysics(),
              animateFirst: false,
              indicators: [
                FortuneIndicator(
                  alignment: Alignment.topCenter,
                  child: TriangleIndicator(
                    color: AppColors.context(context).textColor,
                    elevation: 6,
                  ),
                ),
              ],
              onFocusItemChanged: (value) async{
                final interval = DateTime.now().difference(lastTickTime);
                dekhao("Time interval is $interval");
                if(interval > minTickInterval) {
                  if(Platform.isAndroid) await widget.physicalFeedback.availableFeedbacks();
                  if(Platform.isIOS) await widget.physicalFeedback.vibrate();
                  lastTickTime = DateTime.now();
                  dekhao("Throw feedback");
                }
                
              },
              selected: widget.taskWheelUINotifier.wheelStreamcontroller.stream,
              onAnimationEnd: () async{
                await widget.physicalFeedback.availableFeedbacks();
                widget.taskWheelUINotifier.onAnimationEnd();
              },
              items:
                  widget.taskWheelUINotifier.upToDateCurrentTasks.tasks
                      .asMap() // Converts the list to a map with the index as the key
                      .map(
                        (index, task) => MapEntry(
                          index,
                          FortuneItem(
                            
                            onTap: () async{
                              await AppServices.physicalFeedback.availableFeedbacks();
                              if(context.mounted && mounted) {
                                Navigator.of(context).push(
                                  PageRouteBuilder(
                                    opaque: false,
                                    barrierDismissible: true,
                                    transitionDuration: Duration(milliseconds: 600),
                                    pageBuilder: (_, __, ___) {
                                    return EditTaskPopup(tasksDataProvider: widget.tasksDataProvider, taskWheelUINotifier: widget.taskWheelUINotifier, editingTask: task,);
                                  },
                                ));
                              }
                            },
                            style: FortuneItemStyle(
                              borderColor: Colors.grey.shade300,
                              color: task.isDummy ? Colors.black.withAlpha(100): AppColors.context(context).primaryColor.withAlpha(
                                (255 * (index + 1) / upToDateCurrentTasks.tasks.length).round(),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: Text(
                                      task.title,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelLarge?.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Hero(
                                    tag: "EditTaskPopup${task.id}",
                                    child: CircleAvatar(
                                      radius: 1,
                                      backgroundColor: Colors.transparent,
                                    ),
                                  )
                                ],
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
