
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/core/services/app_services.dart';

import 'custom_button.dart';
import '../../notifiers/button_status_notifier.dart';
import '../../../utils/constants/app_colors.dart' show AppColors;
import '../../../utils/constants/app_sizes.dart';


class SaveButton extends StatefulWidget {
  final ButtonStatusNotifier buttonStatusNotifier;
  final String saveText;
  final String savingText;
  final String errorText;
  final String doneText;
  final VoidCallback onSave;
  final VoidCallback onDone;
  const SaveButton({
    required super.key, 
    this.saveText = "Save",
    this.savingText = "Saving",
    this.errorText = "Error",
    this.doneText = "Done",
    required this.buttonStatusNotifier,
    required this.onSave, 
    required this.onDone});

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  late ButtonStatusNotifier buttonStatusNotifier;

  @override
  void didChangeDependencies() {
    buttonStatusNotifier.addListener(() {
      if(mounted && context.mounted) {
        setState(() {});
      }

      if (buttonStatusNotifier.status is SuccessStatus) {
          dekhao("Successful save");
          Future.delayed(const Duration(milliseconds: 1000)).then((_) async{
            await AppServices.physicalFeedback.availableFeedbacks();
            if(context.mounted && mounted) {
              widget.onDone();
            }
          });
        }      
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    buttonStatusNotifier = widget.buttonStatusNotifier;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          
          duration: const Duration(milliseconds: 400),
          height: 40,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: (buttonStatusNotifier.status is DisabledStatus)
                ? AppColors.context(context).inActiveButtonColor
                : AppColors.context(context).buttonColor,
            borderRadius: AppSizes.smallBorderRadius,
          ),
          child: CustomButton(
            borderRadius: AppSizes.smallBorderRadius,
            onTap: () async{
              // TODO: Handle delete task action here
              if(buttonStatusNotifier.status is EnabledStatus) {
                widget.onSave();
              }
            },
            child: Center(
              //key: UniqueKey(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _statusUi()
              ),
            )
          ),
        );
      },
    );
  }

  Widget _statusUi() {
    return LayoutBuilder(
      builder: (context, constraints) {
        dekhao("Button status: ${buttonStatusNotifier.status.runtimeType}");
        switch (buttonStatusNotifier.status.runtimeType) {
          
          case const (EnabledStatus):
            return Text(
              widget.saveText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.context(context).buttonContentColor,
              ),
            );

          case const (DisabledStatus):
            dekhao("Button is disabled");
            return Text(
              widget.saveText,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.context(context).inActiveButtonContentColor,
              ),
            );

          case const (LoadingStatus):
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 10),
                Text(
                  widget.savingText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
                SizedBox(width: 10),
                SizedBox(
                  height: min(constraints.maxHeight ,constraints.maxWidth), 
                  width: min(constraints.maxHeight ,constraints.maxWidth), 
                  child: CircularProgressIndicator(strokeWidth: 2,))
              ],
            );

          case const (ErrorStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error,
                  size: AppSizes.mediumIconSize,
                  color: Colors.orange,
                ),
                SizedBox(width: 10),
                Text(
                  widget.errorText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
              ],
            );
            
          case const (SuccessStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done,
                  size: AppSizes.mediumIconSize,
                  color: AppColors.context(context).activeButtonColor,
                ),
                SizedBox(width: 10),
                Text(
                  widget.doneText,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
              ],
            );
          default:
            dekhao("Button status not found");
            return Text(
              "Save",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.context(context).inActiveButtonContentColor,
              ),
            );
        }
      },
    );
  }
}
