import 'dart:math';
import 'package:flutter/material.dart';

import '../../../core/helpers/dekhao.dart';
import '../../../core/services/app_services.dart';
import '../../domain/entities/wheel_task.dart';
import '../../../utils/constants/app_colors.dart';

class Wheel2 extends StatefulWidget {
  const Wheel2({super.key});
  @override
  State<Wheel2> createState() => _Wheel2State();
}

class _Wheel2State extends State<Wheel2> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation;
  double _angle = 0;

  List<WheelTask> tasks = [];

  // void _getRandomNumber() {
  //   controller.add(Random().nextInt(tasks.length));
  // }

  double radiansToDegrees(double radians) => radians * (180 / pi);

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    AppServices.tasksNotifier.addListener(() {
      setState(() {
        tasks = AppServices.tasksNotifier.tasks;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    tasks = AppServices.tasksNotifier.tasks;
    _controller = AnimationController(vsync: this);
  }

  void _startRotation() {
    final anglePerSlice = 2 * pi / tasks.length;
    final random = Random();
    var targetAngle = (random.nextDouble() * 2 * pi);
    // var floor = targetAngle - (targetAngle % (anglePerSlice/2));
    // var ceil = (targetAngle + anglePerSlice/2)% (anglePerSlice/2) ;
    // if(floor < ceil) {
    //   targetAngle = floor;
    // } else {
    //   targetAngle = ceil;
    // }

    _animation =
        Tween<double>(
            begin: _angle,
            end: _angle + 4 * pi + targetAngle,
          ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut))
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              dekhao("Animation completed");
              _angle = (_animation?.value ?? 0) % (2 * pi);
              int index = (_angle % (2 * pi) / anglePerSlice).round();
              dekhao("index: $index");
              AppServices.tasksNotifier.selectedIndex = index;

              setState(() {});
            }
          });

    _controller
      ..duration = Duration(seconds: 3)
      ..reset()
      ..forward();
  }

  @override
  void dispose() {
    dekhao("callingf dispose");
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = 300.0;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: TaskCirclePainter(
                tasks: tasks,
                appColors: AppColors.context(context),
                textStyle:
                    Theme.of(context).textTheme.labelLarge ?? TextStyle(),
              ),
              child: Transform.rotate(
                angle: _animation?.value ?? _angle,
                alignment: Alignment.center,
                child: CustomPaint(painter: HandlePainter()),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startRotation,
            style: ButtonStyle(
              shadowColor: WidgetStatePropertyAll(
                AppColors.context(context).accentColor,
              ),
              overlayColor: WidgetStatePropertyAll(
                AppColors.context(context).accentColor,
              ),
            ),
            child: Text('Start', style: Theme.of(context).textTheme.titleLarge),
          ),
        ],
      ),
    );
  }
}

class TaskCirclePainter extends CustomPainter {
  final List<WheelTask> tasks;
  final TextStyle textStyle;
  final AppColors appColors;

  TaskCirclePainter({
    required this.tasks,
    required this.appColors,
    required this.textStyle,
  });

  double radiansToDegrees(double radians) => radians * (180 / pi);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final anglePerSlice = 2 * pi / tasks.length;

    final paint = Paint()..style = PaintingStyle.fill;
    final borderPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    int? selectedTaskIndex = AppServices.tasksNotifier.selectedIndex;
    for (int i = 0; i < tasks.length; i++) {
      // Slice color
      if (selectedTaskIndex != null) {
        paint.color =
            selectedTaskIndex == i
                ? appColors.accentColor.withAlpha(255)
                : appColors.accentColor.withAlpha(100);
      } else {
        paint.color = appColors.accentColor.withAlpha(
          (255 * (i + 1) / tasks.length).round(),
        );
      }
      final startAngle = (anglePerSlice * i) - anglePerSlice;

      // Draw slice
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        anglePerSlice,
        true,
        paint,
      );

      // Draw slice border
      borderPaint.color = Colors.black;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        anglePerSlice,
        true,
        borderPaint,
      );

      // Draw task text
      final labelAngle = startAngle + anglePerSlice / 2;
      final textOffset = Offset(
        center.dx + (radius / 1.5) * cos(labelAngle),
        center.dy + (radius / 1.5) * sin(labelAngle),
      );

      textPainter.text = TextSpan(
        text: "${tasks[i].title}($i)",
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        textOffset - Offset(textPainter.width / 2, textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class HandlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final length = size.width / 2 - 20;

    final paint =
        Paint()
          ..color = Colors.black
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    final handleEnd = Offset(center.dx, center.dy - length);
    canvas.drawLine(center, handleEnd, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
