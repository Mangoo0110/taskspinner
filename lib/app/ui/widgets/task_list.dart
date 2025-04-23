import 'package:flutter/material.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

import '../controllers/task_wheel_ui_notifier.dart';

class TaskList extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const TaskList({super.key, required this.taskWheelUINotifier});

  @override
  State<TaskList> createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  late TaskType currentTaskType;
  late UpToDateCurrentTasks upToDateCurrentTasks;

  final ScrollController _scrollController = ScrollController();

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
    // TODO: implement dispose
    _scrollController.dispose();
    //widget.taskWheelUINotifier.removeListener(() {});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          child: ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: upToDateCurrentTasks.tasks.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                child: Container(
                  height: 50,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    color: AppColors.context(context).backgroundColor,
                    borderRadius: AppSizes.verySmallBorderRadius
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(upToDateCurrentTasks.tasks[index].title, maxLines: 4, style: Theme.of(context).textTheme.labelLarge, overflow: TextOverflow.ellipsis, ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
