
import 'dart:async';

import 'package:flutter/material.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_sizes.dart';

class LuckyTaskDuration extends StatefulWidget {
  final int minuteDuration;
  const LuckyTaskDuration({
    super.key,
    this.minuteDuration = 0,
  });

  @override
  State<LuckyTaskDuration> createState() => _LuckyTaskDurationState();
}

class _LuckyTaskDurationState extends State<LuckyTaskDuration> {
  late int _duration;

  int _cnt = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    Timer.periodic(Duration(milliseconds: 500), (timer) {
      _cnt++;
      if(_cnt == 1) {
        _duration = widget.minuteDuration.clamp(0, 60);
        timer.cancel();
        setState(() {
          
        });
      }
    });
    
    
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _duration = (0).clamp(0, 60);
  }


  @override
  Widget build(BuildContext context) {
    final percent = _duration / 60;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            SingleChildScrollView(
              child: Row(
                children: [
                  Icon(Icons.history),
                  Text(
                    " $_duration minutes",
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ],
              ),
            ),
    
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final fillWidth = width * percent.clamp(0.0, 1.0);
    
            return Container(
              height: 15,
              width: width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: AppSizes.maxCircularRadius,
                border: Border.all(color: Theme.of(context).primaryColor, width: 2),
              ),
              child: Stack(
                children: [
                  // Animated fill bar
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: fillWidth,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: AppSizes.maxCircularRadius,
                    ),
                  ),
                  // Vertical dividers
                  Positioned(
                    left: width * (5 / 60),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: AppColors.context(context).textGreyColor,
                    ),
                  ),
                  Positioned(
                    left: width * (30 / 60),
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 2,
                      color: AppColors.context(context).textGreyColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
