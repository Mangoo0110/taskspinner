import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/widgets/add_task.dart';

import '../../../core/commons/enums/tasktype.dart';
import '../../../core/services/app_services.dart';
import '../../../utils/constants/app_colors.dart';
import '../controllers/tasks_notifier.dart';
import '../widgets/select_tasktype.dart';
import '../widgets/task_list.dart';

class TaskBar extends StatefulWidget {
  final TasksNotifier tasksNotifier;
  const TaskBar({super.key, required this.tasksNotifier});

  @override
  State<TaskBar> createState() => _TaskBarState();
}

class _TaskBarState extends State<TaskBar> {

  late TaskType _currentTaskType;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    AppServices.tasksNotifier.addListener(() {
      if (mounted) {
        setState(() {
          _currentTaskType = AppServices.tasksNotifier.currentTaskType;
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _currentTaskType = AppServices.tasksNotifier.currentTaskType;
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        print(constraints.toString());
        return Drawer(
          backgroundColor: AppColors.context(context).backgroundColor,
          shape: const LinearBorder(side: BorderSide()),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                width: constraints.maxWidth,
                color: AppColors.context(context).accentColor.withAlpha(200),
                child: Center(
                  child: Text(
                    "Tasks",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: AppColors.context(context).buttonTextColor),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  
                  decoration: BoxDecoration(
                    color: AppColors.context(context).contentBoxColor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.context(context).contentBoxGreyColor,
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  ),
                  child: const SelectTasktype()
                ),
              ),
              
              Flexible(
                fit: FlexFit.tight,
                child: TaskList(),
              ),
              
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 120,
                  width: constraints.maxWidth,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withAlpha(125),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  ),
                  child: AddTask(
                    tasksNotifier: widget.tasksNotifier,
                  )),
              )
            ],
          ),
        );
      },
    );
  }
}
