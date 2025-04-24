
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';

import '../../services/app_services.dart';
import 'custom_button.dart';
import '../../notifiers/button_status_notifier.dart';
import '../../../utils/constants/app_colors.dart' show AppColors;
import '../../../utils/constants/app_sizes.dart';

/// Height is 50
class DeleteButton extends StatefulWidget {
  final ButtonStatusNotifier buttonStatusNotifier;
  final VoidCallback onDelete;
  final VoidCallback onDone;
  const DeleteButton({required super.key, required this.onDelete, required this.onDone, required this.buttonStatusNotifier});

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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
    deleteButtonStatusNotifier = widget.buttonStatusNotifier;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Start fade-in on init
    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Focus(
          focusNode: _focusNode,
          onFocusChange: (value) {
            dekhao("Delete Focus changed");
            if(!_focusNode.hasFocus) {
              dekhao("Delete Focus changed");
              _focusNode.unfocus();
              deleteButtonStatusNotifier.setStatus(DisabledStatus());
            }
          },
          child: AnimatedContainer(
            
            duration: const Duration(milliseconds: 400),
            height: 50,
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
                  _focusNode.requestFocus();
                  deleteButtonStatusNotifier.setStatus(EnabledStatus());
                } else if (deleteButtonStatusNotifier.status is EnabledStatus) {
                  widget.onDelete();
                }
              },
              child: FadeTransition(
                opacity: _animation,
                child: Center(
                  key: UniqueKey(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _statusUi()
                  ),
                ),
              )
            ),
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  "Error",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
