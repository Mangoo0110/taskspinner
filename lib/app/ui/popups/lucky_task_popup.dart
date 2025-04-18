
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/widgets/lucky_task_duration.dart';
import '../../../core/commons/widgets/popup_okay_button.dart';
import '../../domain/entities/wheel_task.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

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
                              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.context(context).popupBackgroundColor,
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
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // task input
                                    Text(
                                      widget.luckyTask.title,
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: AppColors.context(context).popupContentColor,
                                      ),
                                    ),
                                    //gap
                                    SizedBox(height: 16),
                                    // duration
                                    LuckyTaskDuration(
                                      minuteDuration: widget.luckyTask.minuteDuration,
                                    ),
                                    // gap
                                    SizedBox(height: 10),
                                    _details(luckyTask: widget.luckyTask),
                                    // gap
                                    SizedBox(height: 16),
                                    // done/okay button
                                    PopupOkayButton(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                    )
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
          decoration: BoxDecoration(
            borderRadius: AppSizes.smallBorderRadius,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Details",
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.context(context).popupContentColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                luckyTask.details,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: AppColors.context(context).popupContentColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

