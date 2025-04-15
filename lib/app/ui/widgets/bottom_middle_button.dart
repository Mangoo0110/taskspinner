
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/domain/entities/wheel_task.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

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



class LuckyTaskPopup extends StatefulWidget {
  final WheelTask luckyTask;
  const LuckyTaskPopup({super.key, required this.luckyTask});

  @override
  State<LuckyTaskPopup> createState() => _LuckyTaskPopupState();
}

class _LuckyTaskPopupState extends State<LuckyTaskPopup> {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Material(
                  color: Colors.transparent,
                  child: Dialog(
                    backgroundColor: Colors.transparent, // Transparent background for blur effect
                    child: Stack(
                      children: [
                        // The blurred background
                        Positioned.fill(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                            child: Container(
                              color: Colors.black.withAlpha(0), // Transparent background
                            ),
                          ),
                        ),
                        // The actual content of the dialog (Task selection)
                        Center(
                          child: Hero(
                            tag: "LuckyTask",
                            child: Container(
                              padding: EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.context(context).textColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(2),
                                    spreadRadius: 3,
                                    blurRadius: 7,
                                  ),
                                ],
                              ),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // task input
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        widget.luckyTask.title,
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: AppColors.context(context).contentBoxColor,
                                        ),
                                      ),
                                    ),
                                              
                                    _details(luckyTask: widget.luckyTask),
                                    SizedBox(height: 10),
                                    // add task button
                                    Container(
                                      width: constraints.maxWidth,
                                      decoration: BoxDecoration(
                                        color: AppColors.context(context).buttonContentColor,
                                        borderRadius: AppSizes.maxCircularRadius,
                                      ),
                                      child: CustomButton(
                                        borderRadius: AppSizes.maxCircularRadius,
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Okay",
                                              style: Theme.of(
                                                context,
                                              ).textTheme.labelLarge
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
      },
    );
  }
  
  Widget _details({required WheelTask luckyTask}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: AppSizes.smallBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.context(context).contentBoxColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                maxLines: 12,
                luckyTask.details,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.context(context).contentBoxColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
