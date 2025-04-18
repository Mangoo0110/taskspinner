

import 'package:flutter/material.dart';
import 'package:taskspinner/app/domain/entities/wheel_task.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../popups/lucky_task_popup.dart';

class BottomMiddleButton extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const BottomMiddleButton({super.key, required this.taskWheelUINotifier});

  @override
  State<BottomMiddleButton> createState() => _BottomMiddleButtonState();
}

class _BottomMiddleButtonState extends State<BottomMiddleButton> {

  String buttonText = "Spin";
  bool isSpinning = false;

  void _showLuckyTaskDialog(BuildContext context, WheelTask luckyTask) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
          return LuckyTaskPopup(luckyTask: luckyTask);
      },
    ));
  }

  @override
  void didChangeDependencies() {
    // Logic to update the button text based
    widget.taskWheelUINotifier.addListener(() {
      if (mounted && context.mounted && widget.taskWheelUINotifier.isSpinning != isSpinning) {
        isSpinning = widget.taskWheelUINotifier.isSpinning;
        if (isSpinning) {
          buttonText = "Spinning";
        } else {
          if(widget.taskWheelUINotifier.luckyTask != null) _showLuckyTaskDialog(context, widget.taskWheelUINotifier.luckyTask!);
          buttonText = "Spin";
        }
        // Re render the widget
        setState(() {
        });
      }
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Hero(
          tag: "LuckyTask",
          child: Container(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            decoration: BoxDecoration(
              color: AppColors.context(context).primaryColor,
              borderRadius: AppSizes.maxCircularRadius,
            ),
            child: CustomButton(
              borderRadius: AppSizes.maxCircularRadius,
              onTap: () {
                widget.taskWheelUINotifier.spin();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(Icons.replay, color: AppColors.context(context).buttonTextColor),
                  SizedBox(width: 4),
                  Text(
                    buttonText,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.context(context).textColor,
                    ),
                  ),
                ],
              ),
            )
          ),
        );
      },
    );
  }
}



