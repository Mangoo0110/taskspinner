// import 'dart:math';

// import 'package:flutter/material.dart';

// import '../../domain/entities/wheel_task.dart';

// class TaskCirclePainter extends CustomPainter {
//   final List<WheelTask> tasks;
//   final int selectedIndex;

//   TaskCirclePainter(this.tasks, this.selectedIndex);

//   @override
//   void paint(Canvas canvas, Size size) {
//     final center = size.center(Offset.zero);
//     final radius = size.width / 2 - 10;
//     final anglePerSlice = 2 * pi / tasks.length;

//     final shadowPaint =
//         Paint()
//           ..color = Colors.black.withOpacity(0.2)
//           ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

//     final fillPaint = Paint()..style = PaintingStyle.fill;
//     final borderPaint =
//         Paint()
//           ..style = PaintingStyle.stroke
//           ..strokeWidth = 2
//           ..color = Colors.black;

//     final textPainter = TextPainter(
//       textDirection: TextDirection.ltr,
//       textAlign: TextAlign.center,
//     );

//     for (int i = 0; i < tasks.length; i++) {
//       final startAngle = anglePerSlice * i;

//       final path =
//           Path()
//             ..moveTo(center.dx, center.dy)
//             ..arcTo(
//               Rect.fromCircle(center: center, radius: radius),
//               startAngle,
//               anglePerSlice,
//               false,
//             )
//             ..close();

//       if (i == selectedIndex) {
//         // Elevate with shadow
//         canvas.save();
//         canvas.translate(2, 2); // subtle elevation
//         canvas.drawPath(path, shadowPaint);
//         canvas.restore();

//         fillPaint.color = Colors.orangeAccent;
//       } else {
//         fillPaint.color = Colors.blue.withOpacity(0.2);
//       }

//       canvas.drawPath(path, fillPaint);
//       canvas.drawPath(path, borderPaint);

//       // Optional: Draw text
//       final labelAngle = startAngle + anglePerSlice / 2;
//       final textOffset = Offset(
//         center.dx + (radius / 1.5) * cos(labelAngle),
//         center.dy + (radius / 1.5) * sin(labelAngle),
//       );

//       textPainter.text = TextSpan(
//         text: "${tasks[i].title}($i)",
//         style: TextStyle(
//           fontSize: 12,
//           color: Colors.black,
//           fontWeight: i == selectedIndex ? FontWeight.bold : FontWeight.normal,
//         ),
//       );
//       textPainter.layout();
//       textPainter.paint(
//         canvas,
//         textOffset - Offset(textPainter.width / 2, textPainter.height / 2),
//       );
//     }
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }
