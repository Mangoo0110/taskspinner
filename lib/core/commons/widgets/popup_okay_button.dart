

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';
import '../../services/app_services.dart';

class PopupOkayButton extends StatelessWidget {
  final Constraints? constraints;
  final VoidCallback onTap;
  const PopupOkayButton({super.key, this.constraints, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          constraints: constraints,
          decoration: BoxDecoration(
            color: AppColors.context(context).popupContentColor,
            borderRadius: AppSizes.maxCircularRadius,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppSizes.maxCircularRadius,
            child: InkWell(
              splashColor: AppColors.context(context).popupBackgroundColor,
              borderRadius: AppSizes.maxCircularRadius,
              onTap: () async{
                
                await Future.delayed(Duration(milliseconds: 500)).then((_) async{
                  await AppServices.physicalFeedback.availableFeedbacks().then((_) {
                    onTap();
                  });
                });
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Okay",
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(
                      color: AppColors.context(context).popupBackgroundColor
                    )
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}