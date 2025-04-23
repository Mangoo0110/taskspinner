import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/utils/constants/app_colors.dart';
import 'package:taskspinner/utils/constants/app_sizes.dart';

class TaskTypeAndDuration extends StatefulWidget {
  final int initialDuration;
  final ValueChanged<int> onChanged;

  const TaskTypeAndDuration({
    super.key,
    this.initialDuration = 0,
    required this.onChanged,
  });

  @override
  State<TaskTypeAndDuration> createState() => _TaskTypeAndDurationState();
}

class _TaskTypeAndDurationState extends State<TaskTypeAndDuration> {
  late int _duration;
  late TextEditingController _controller;
  int _initialLoadCnt = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    Timer.periodic(Duration(milliseconds: 800), (timer) {
      _initialLoadCnt++;
      dekhao("Timer is on..");
      if(_initialLoadCnt == 1) {
        _duration = widget.initialDuration.clamp(0, 60);
        timer.cancel();
        if(mounted && context.mounted) {
          setState(() {
            
          });
        }
      }
    });
    
    
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _duration = (1).clamp(0, 60);
    _controller = TextEditingController(text: _duration.toString());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _updateDuration(int value) {
    final clamped = value.clamp(0, 60);
    setState(() {
      _duration = clamped;
      _controller.text = clamped.toString();
    });
    widget.onChanged(clamped);
  }

  void _handleInteraction(Offset localPosition, BoxConstraints constraints) {
    final tappedPercent = (localPosition.dx / constraints.maxWidth).clamp(0.0, 1.0);
    final newDuration = max(1, (tappedPercent * 60).round());
    _updateDuration(newDuration);
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

            // Shows as title too
            Align(
              alignment: Alignment.center,
              child: Text(
                _duration < 6 ?
                TaskType.easy.name
                : _duration < 31 ?
                TaskType.medium.name
                : TaskType.hard.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            SizedBox(height: 10,),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history),
                  Text(
                    " $_duration minutes",
                    style: Theme.of(context).textTheme.titleLarge,
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

            return GestureDetector(
              onTapDown: (details) => _handleInteraction(details.localPosition, constraints),
              onHorizontalDragUpdate: (details) =>
                  _handleInteraction(details.localPosition, constraints),
              child: Container(
                height: 20,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.transparent,
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
                        borderRadius: _duration < 59 ?
                        AppSizes.maxCircularRadius.copyWith(topRight: Radius.circular(0), bottomRight: Radius.circular(0))
                        : AppSizes.maxCircularRadius
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
              ),
            );
          },
        ),
      ],
    );
  }
}
