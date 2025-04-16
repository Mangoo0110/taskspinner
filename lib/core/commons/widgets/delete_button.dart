
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';

import 'custom_button.dart';
import '../../notifiers/button_status_notifier.dart';
import '../../../utils/constants/app_colors.dart' show AppColors;
import '../../../utils/constants/app_sizes.dart';


class DeleteButton extends StatefulWidget {
  final ButtonStatusNotifier buttonStatusNotifier;
  final VoidCallback onDelete;
  final VoidCallback onDone;
  const DeleteButton({required super.key, required this.onDelete, required this.onDone, required this.buttonStatusNotifier});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {

  late ButtonStatusNotifier deleteButtonStatusNotifier;

  final FocusNode _focusNode = FocusNode();

  @override
  void didChangeDependencies() {
    deleteButtonStatusNotifier.addListener(() {
      if(mounted && context.mounted) {
        setState(() {});
      }

      if (deleteButtonStatusNotifier.status is SuccessStatus) {
          dekhao("Successful delete");
          Future.delayed(const Duration(milliseconds: 1000)).then((_) {
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
    deleteButtonStatusNotifier = widget.buttonStatusNotifier;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _focusNode.dispose();
    super.dispose();
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
            color: (deleteButtonStatusNotifier.status is DisabledStatus)
                ? AppColors.context(context).inActiveButtonColor
                : AppColors.context(context).buttonColor,
            borderRadius: AppSizes.smallBorderRadius,
          ),
          child: CustomButton(
            borderRadius: AppSizes.smallBorderRadius,
            onTap: () {
              // TODO: Handle delete task action here
              if(deleteButtonStatusNotifier.status is DisabledStatus) {
                deleteButtonStatusNotifier.setStatus(EnabledStatus());
              } else if (deleteButtonStatusNotifier.status is EnabledStatus) {
                widget.onDelete();
              }
            },
            child: Center(
              key: UniqueKey(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: _statusUi()
              ),
            ).animate().fadeIn(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            )
          ),
        );
      },
    );
  }

  Widget _statusUi() {
    return LayoutBuilder(
      builder: (context, constraints) {
        switch (deleteButtonStatusNotifier.status.runtimeType) {
          case const (EnabledStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  size: AppSizes.mediumIconSize,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  "Confirm",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.context(context).buttonContentColor,
                  ),
                )
              ],
            );

          case const (DisabledStatus):
            return Icon(
              Icons.delete,
              size: AppSizes.mediumIconSize,
              color: AppColors.context(context).inActiveButtonContentColor,
            );

          case const (LoadingStatus):
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  size: AppSizes.mediumIconSize,
                  color: Colors.red,
                ),
                SizedBox(width: 10),
                Text(
                  "Deleting",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
                  "Error",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
                SizedBox(width: 10),
                Flexible(child: CircularProgressIndicator())
              ],
            );
            
          case const (SuccessStatus):
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.done,
                  size: AppSizes.mediumIconSize,
                  color: AppColors.context(context).buttonContentColor,
                ),
                SizedBox(width: 10),
                Text(
                  "Done",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.context(context).buttonContentColor,
                  ),
                ),
              ],
            );
          default:
            return Icon(
              Icons.delete,
              size: AppSizes.mediumIconSize,
              color: AppColors.context(context).inActiveButtonContentColor,
            );
        }
      },
    );
  }
}
