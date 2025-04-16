import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:just_audio/just_audio.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/controllers/tasks_data_provider.dart';
import 'package:taskspinner/app/ui/widgets/edit_stask_popup.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';


class Wheel extends StatefulWidget {
  final TasksDataProvider tasksDataProvider;
  final TaskWheelUINotifier taskWheelUINotifier;
  const Wheel({super.key, required this.taskWheelUINotifier, required this.tasksDataProvider});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  

  late TaskType currentTaskType;
  late UpToDateCurrentTasks upToDateCurrentTasks;


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
    super.didChangeDependencies();
  }

  Future<void> playTick() async{
    //dekhao("ticker count ${_tickerCount}");
    await _player.seek(Duration.zero); // rewind
    await _player.play();              // fire-and-forget
  }

  late final AudioPlayer _player;
  int _tickerCount = 0;


  @override
  void initState() {
    upToDateCurrentTasks =  widget.taskWheelUINotifier.upToDateCurrentTasks;
    currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    
    _player = AudioPlayer();

    // Preload the tick sound
    _player.setAsset('assets/sounds/spin_tick.mp3');
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
            onFocusItemChanged: (value) {
              // if(_tickerCount % 3 == 0) playTick();
              // _tickerCount++;
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
                            Navigator.of(context).push(
                            PageRouteBuilder(
                              opaque: false,
                              barrierDismissible: true,
                              transitionDuration: Duration(milliseconds: 600),
                              pageBuilder: (_, __, ___) {
                              return EditTaskPopup(tasksDataProvider: widget.tasksDataProvider, taskWheelUINotifier: widget.taskWheelUINotifier, editingTask: task,);
                            },
                          ));
                          },
                          style: FortuneItemStyle(
                            color: AppColors.context(context).primaryColor.withAlpha(
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
                                      color: AppColors.context(context).textColor,
                                    ),
                                  ),
                                ),
                                Hero(
                                  tag: "EditTaskPopup${task.id}",
                                  child: CircleAvatar(
                                    radius: 1,
                                    backgroundColor: AppColors.context(context).primaryColor.withAlpha(
                                      (255 * (index + 1) / upToDateCurrentTasks.tasks.length).round(),
                                    ),
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
