import 'package:flutter/material.dart';
import 'package:taskspinner/core/services/app_services.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

import '../../domain/entities/wheel_task.dart';

class TaskList extends StatefulWidget {
  const TaskList({super.key});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  List<WheelTask> tasks = [];

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
              child: ListTile(
                tileColor: AppColors.context(context).contentBoxGreyColor,
                shape: RoundedRectangleBorder(
                  borderRadius: AppSizes.smallBorderRadius,
                ),
                style: ListTileStyle.drawer,
                title: Text(tasks[index].title),
              ),
            );
          },
        );
      },
    );
  }
}
