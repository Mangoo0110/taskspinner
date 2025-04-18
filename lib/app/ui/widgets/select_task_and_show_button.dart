import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/popups/task_list_popup.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';



class SelectTaskAndShowButton extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const SelectTaskAndShowButton({super.key, required this.taskWheelUINotifier});
  @override
  State<SelectTaskAndShowButton> createState() => _SelectTaskAndShowButtonState();
}

class _SelectTaskAndShowButtonState extends State<SelectTaskAndShowButton> {
  late TaskType currentTaskType;

  @override
  void didChangeDependencies() {
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
            _showAllTaskDialog(context);
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
                      Icon(Icons.filter_alt, color: AppColors.context(context).textColor,),
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
          return TaskListPopup(taskWheelUINotifier: widget.taskWheelUINotifier,);
      },
    ));
  }
}

