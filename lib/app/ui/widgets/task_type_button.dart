import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/popups/task_type_list_popup.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';



class TaskTypeButton extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const TaskTypeButton({super.key, required this.taskWheelUINotifier});
  @override
  State<TaskTypeButton> createState() => _TaskTypeButtonState();
}

class _TaskTypeButtonState extends State<TaskTypeButton> {
  late TaskType currentTaskType;
  bool _isSpinning = false;

  @override
  void didChangeDependencies() {
    widget.taskWheelUINotifier.addListener(() {
      if (mounted && context.mounted) {
        if(currentTaskType != widget.taskWheelUINotifier.currentTaskType) {
          currentTaskType = widget.taskWheelUINotifier.currentTaskType;
           setState(() {});
        }

        if(widget.taskWheelUINotifier.isSpinning != _isSpinning) {
          _isSpinning = widget.taskWheelUINotifier.isSpinning;
          setState(() {
            
          });
        }
        
      }

      
    });
    super.didChangeDependencies();
  }
  

  @override
  void initState() {
    currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomButton(
          borderRadius: AppSizes.maxCircularRadius,
          onTap: () {
            if(_isSpinning == false) _showAllTaskDialog(context);
          },
          child: Hero(
            tag: "TaskListPopup",
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: AppColors.context(context).popupBackgroundColor,
                borderRadius: AppSizes.maxCircularRadius,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.context(context).shadowColor,
                    offset: Offset(.5, 2),
                    spreadRadius: 2,
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isSpinning ? Icons.lock : Icons.filter_alt, color: AppColors.context(context).textColor,),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(currentTaskType.name, style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAllTaskDialog(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
          return TasktypeListPopup(taskWheelUINotifier: widget.taskWheelUINotifier,);
      },
    ));
  }
}

