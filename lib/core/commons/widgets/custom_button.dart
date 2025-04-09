import 'package:flutter/material.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';

class CustomButton extends StatefulWidget {
  final Widget child;
  final Size? size;
  final Color? splashColor;
  final Function()? onTap;
  final BorderRadius? borderRadius;
  const CustomButton({
    super.key,
    required this.child,
    this.onTap,
    this.borderRadius,
    this.size,
    this.splashColor,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        BorderRadius buttonBorderRadius =
            widget.borderRadius ?? BorderRadius.circular(10);
        return Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: AppColors.context(context).textColor,
            borderRadius: buttonBorderRadius,
            onTap:
                widget.onTap == null
                    ? null
                    : () {
                      
                      Future.delayed(Duration(milliseconds: 500)).then((_) {
                        widget.onTap!();   
                      });
                    },

            child: widget.child,
          ),
        );
      },
    );
  }
}
