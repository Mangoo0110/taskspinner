import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/widgets/edit_stask_popup.dart';
import 'package:taskspinner/app/ui/widgets/bottom_middle_button.dart';
import 'package:taskspinner/core/features/settings/presentation/pages/settings_popup.dart';
import 'package:taskspinner/app/ui/widgets/task_list_popup.dart';
import 'package:taskspinner/core/commons/enums/tasktype.dart';
import 'package:taskspinner/core/services/app_services.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_names.dart';
import '../../../utils/constants/app_sizes.dart';
import '../widgets/wheel.dart';


class SpinnerTaskApp extends StatefulWidget {
  const SpinnerTaskApp({super.key});

  

  @override
  State<SpinnerTaskApp> createState() => _SpinnerTaskAppState();
}

class _SpinnerTaskAppState extends State<SpinnerTaskApp> {

  static StreamController<int> controller = StreamController<int>();

  static TaskWheelUINotifier taskWheelUINotifier = TaskWheelUINotifier(
    controller: controller,
    tasksDataProvider: AppServices.tasksProvider
  );

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => Scaffold(
            //backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            // appBar: AppBar(
            //   title: Center(child: Text(AppNames.appName)),
            // ),

            body: Stack(
              alignment: AlignmentDirectional.topCenter,
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Positioned(
                  top: 0,
                  child: AssetBackGroundImage(
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                  ),
                ),
                
                Positioned(
                  top:  constraints.maxHeight / 4.2 - 130,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(AppNames.appName, style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 10,),
                      Center(
                        child: TaskListShowButton(taskWheelUINotifier: taskWheelUINotifier,),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  top: constraints.maxHeight / 4.2,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 370,
                    //color: Colors.white,
                    child: Center(
                      child: Wheel(
                        settingsDataProvider: AppServices.settingsDataProvider,
                        taskWheelUINotifier: taskWheelUINotifier,
                        tasksDataProvider: AppServices.tasksProvider,
                      )),
                  ),
                ),

                // floating buttons
                Positioned(
                  bottom: 25,
                  child: SizedBox(
                    height: 80, 
                    width: constraints.maxWidth, 
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _bottomActions(),
                    )
                ))
              ],
            ),
          ),
    );
  }

  Widget _bottomActions() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: {0: FlexColumnWidth(.2), 1: FlexColumnWidth(.6), 2: FlexColumnWidth(.2)},
            children: [
              TableRow(
                children: [
                  Hero(
                    tag: "AddTaskPopup",
                    child: _bottomSideButton(
                      icon: Icons.create,
                      onTap: () {
                        print("Create tapped");
                        _showAddTaskDialog(context);
                      },
                    ),
                  ),
          
                  SizedBox(
                    height: constraints.maxHeight,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: BottomMiddleButton(
                        taskWheelUINotifier: taskWheelUINotifier,
                      ),
                    )
                  ),
                  
                  Hero(
                    tag: "Spinner_Settings",
                    child: _bottomSideButton(
                      icon: Icons.settings,
                      onTap: () {
                        print("Filter Task");
                        _showSettingsDialog(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          )
        );
      },
    );
  }

  Widget _bottomSideButton({required IconData icon, required VoidCallback onTap}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double _bottomSideButtonRadius = min(70, constraints.maxWidth - 16)/2 ;
        return CircleAvatar(
          backgroundColor: AppColors.context(context).contentBoxColor,
          radius: _bottomSideButtonRadius,
          child: CustomButton(
            borderRadius: BorderRadius.circular(80000000),
            onTap: () {
              onTap();
            },
            child: SizedBox(
              height: _bottomSideButtonRadius * 2,
              width: _bottomSideButtonRadius * 2,
              child: Icon(icon, color: AppColors.context(context).textColor.withAlpha(200))),
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
        return SettingsPopup(
          settingsDataProvider: AppServices.settingsDataProvider,
        );
      },
    ));
  }

  void _showAddTaskDialog(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
          return EditTaskPopup(tasksDataProvider: AppServices.tasksProvider, taskWheelUINotifier: taskWheelUINotifier);
      },
    ));
  }

  
}


class AssetBackGroundImage extends StatefulWidget {
  final double height;
  final double width;
  const AssetBackGroundImage({super.key, required this.height, required this.width});

  @override
  State<AssetBackGroundImage> createState() => _AssetBackGroundImageState();
}

class _AssetBackGroundImageState extends State<AssetBackGroundImage> {

  String? assetBackgroundImagePath;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    AppServices.settingsDataProvider.addListener(
      () {
        if (mounted && context.mounted && assetBackgroundImagePath != AppServices.settingsDataProvider.currentSetting.assetBackgroundImagePath) {
          assetBackgroundImagePath = AppServices.settingsDataProvider.currentSetting.assetBackgroundImagePath;
          setState(() {});
        }
      },
    );
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    assetBackgroundImagePath = AppServices.settingsDataProvider.currentSetting.assetBackgroundImagePath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: widget.height,
          width: widget.width,
          decoration: BoxDecoration(
            image: assetBackgroundImagePath == null ? null : DecorationImage(
              image: AssetImage(assetBackgroundImagePath!),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withAlpha(100), BlendMode.darken),
            ),
          ),
        );
      },
    );
  }
}


class TaskListShowButton extends StatefulWidget {
  final TaskWheelUINotifier taskWheelUINotifier;
  const TaskListShowButton({super.key, required this.taskWheelUINotifier});
  @override
  State<TaskListShowButton> createState() => _TaskListShowButtonState();
}

class _TaskListShowButtonState extends State<TaskListShowButton> {
  late TaskType currentTaskType;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    widget.taskWheelUINotifier.addListener(() {
      if (mounted && context.mounted && currentTaskType != widget.taskWheelUINotifier.currentTaskType) {
        currentTaskType = widget.taskWheelUINotifier.currentTaskType;
        setState(() {});
      }
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    currentTaskType = widget.taskWheelUINotifier.currentTaskType;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomButton(
          borderRadius: AppSizes.maxCircularRadius,
          onTap: () {
            _showAllTaskDialog(context);
          },
          child: Hero(
            tag: "TaskListPopup",
            // flightShuttleBuilder: (flightContext, animation, direction, fromContext, toContext) {
            //   return FadeTransition(
            //     opacity: animation,
            //     child: toContext.widget,
            //   );
            // },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: AppColors.context(context).popupBackgroundColor,
                borderRadius: AppSizes.maxCircularRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(2),
                    spreadRadius: 3,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.filter_alt, color: AppColors.context(context).textColor,),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(currentTaskType.name, style: Theme.of(context).textTheme.titleMedium,),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAllTaskDialog(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
          return TaskListPopup(taskWheelUINotifier: widget.taskWheelUINotifier,);
      },
    ));
  }
}







