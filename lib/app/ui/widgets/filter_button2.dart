
// import 'package:flutter/material.dart';

// import '../../../core/commons/enums/tasktype.dart';
// import '../../../core/commons/widgets/custom_button.dart';
// import '../../../core/services/app_services.dart';
// import '../../../utils/constants/app_colors.dart';
// import '../../../utils/constants/app_sizes.dart';

// class TaskModifyButton extends StatefulWidget {
//   final VoidCallback onTap;
//   const TaskModifyButton({super.key, required this.onTap});

//   @override
//   State<TaskModifyButton> createState() => _TaskModifyButtonState();
// }

// class _TaskModifyButtonState extends State<TaskModifyButton> {

//   late TaskType _currentTaskType;

//   @override
//   void didChangeDependencies() {
//     // Listen tasktype change and update ui.
//     AppServices.tasksNotifier.addListener(() {
//       if(mounted) {
//         setState(() {
//           _currentTaskType = AppServices.tasksNotifier.currentTaskType;
//         });
//       }
      
//     });
//     super.didChangeDependencies();
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     _currentTaskType = AppServices.tasksNotifier.currentTaskType;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return Center(
//           child: Hero(
//             tag: "Spinner_Filter",
//             child: Container(
//               decoration: BoxDecoration(
//                 color: AppColors.context(context).accentColor,
//                 borderRadius: AppSizes.smallBorderRadius,
//               ),
//               child: CustomButton(
//                 //size: Size(50, 100),
//                 borderRadius: AppSizes.smallBorderRadius,
//                 onTap: () {
//                   print("tapped");
//                   widget.onTap();
//                   //Scaffold.of(context).openEndDrawer();
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(
//                         Icons.filter_alt,
//                         color: AppColors.context(context).buttonTextColor,
//                       ),
//                       SizedBox(width: 4),
//                       Text(
//                         _currentTaskType.name.toUpperCase(),
//                         style: Theme.of(context).textTheme.labelLarge?.copyWith(
//                           color: AppColors.context(context).buttonTextColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }