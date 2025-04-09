import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:taskspinner/core/services/app_services.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';

import '../../domain/entities/wheel_task.dart';

class Wheel extends StatefulWidget {
  const Wheel({super.key});

  @override
  State<Wheel> createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  StreamController<int> controller = StreamController<int>();

  List<WheelTask> tasks = [];
  int _selectedIndex = 0;

  void _getRandomNumber() {
    _selectedIndex = Random().nextInt(tasks.length);
    controller.add(_selectedIndex);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    AppServices.tasksNotifier.addListener(() {
      if (mounted) {
        setState(() {
          tasks = AppServices.tasksNotifier.tasks;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    tasks = AppServices.tasksNotifier.tasks;
    _getRandomNumber();
    super.initState();
  }

  void dispose() {
    // TODO: implement dispose
    controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          height: 300,
          width: 300,
          child: FortuneWheel(
            physics: CircularPanPhysics(
              duration: Duration(seconds: 1),
              curve: Curves.decelerate,
              allowOppositeRotationFlung: true,
            ),
            onFling: () {
              _getRandomNumber();
            },
            indicators: [
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: TriangleIndicator(
                  color: AppColors.context(context).textColor,
                  elevation: 6,
                ),
              ),
            ],
            selected: controller.stream,
            onAnimationEnd: () {
              AppServices.tasksNotifier.selectedIndex = _selectedIndex;
            },
            items:
                AppServices.tasksNotifier.tasks
                    .asMap() // Converts the list to a map with the index as the key
                    .map(
                      (index, task) => MapEntry(
                        index,
                        FortuneItem(
                          style: FortuneItemStyle(
                            color: AppColors.context(
                              context,
                            ).accentColor.withAlpha(
                              (255 * (index + 1) / tasks.length).round(),
                            ),
                          ),
                          child: Text(
                            task.title,
                            style: Theme.of(
                              context,
                            ).textTheme.titleLarge?.copyWith(
                              color: AppColors.context(context).buttonTextColor,
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
