import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/app/ui/popups/edit_stask_popup.dart';
import 'package:taskspinner/app/ui/widgets/bottom_middle_button.dart';
import 'package:taskspinner/core/features/settings/presentation/pages/settings_popup.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/core/services/app_services.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_names.dart';
import '../widgets/task_type_button.dart';
import '../widgets/wheel.dart';


class SpinnerTaskApp extends StatefulWidget {
  const SpinnerTaskApp({super.key});

  

  @override
  State<SpinnerTaskApp> createState() => _SpinnerTaskAppState();
}

class _SpinnerTaskAppState extends State<SpinnerTaskApp> {

  static StreamController<int> controller = StreamController<int>();

  static TaskWheelUINotifier taskWheelUINotifier = TaskWheelUINotifier(
    wheelStreamcontroller: controller,
    tasksDataProvider: AppServices.tasksProvider
  );

  bool _isThereAPopUp = false;
  DateTime lastTickTime = DateTime.now();
  final Duration minTickInterval = Duration(milliseconds: 500);

  @override
  void dispose() {
    // TODO: implement dispose
    if(mounted && !controller.isClosed) {
      controller.close();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              alignment: AlignmentDirectional.topCenter,
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
                      Stack(
                        children: [
                          // Border text
                          Text(
                            AppNames.appName,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 1.5
                                ..color = AppColors.context(context).primaryColor,
                            ),
                          ),
                          // Fill text
                          Text(
                            AppNames.appName,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                      //Text(AppNames.appName, style: Theme.of(context).textTheme.titleLarge,),
                      const SizedBox(height: 10,),
                      Center(
                        child: TaskTypeButton(taskWheelUINotifier: taskWheelUINotifier,),
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
                        physicalFeedback: AppServices.physicalFeedback,
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
                        dekhao("Create tapped");
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
                        dekhao("Filter Task");
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
        double bottomSideButtonRadius = min(70, constraints.maxWidth - 16)/2 ;
        return CircleAvatar(
          backgroundColor: AppColors.context(context).contentBoxColor,
          radius: bottomSideButtonRadius,
          child: CustomButton(
            borderRadius: BorderRadius.circular(80000000),
            onTap: () {
              onTap();
            },
            child: SizedBox(
              height: bottomSideButtonRadius * 2,
              width: bottomSideButtonRadius * 2,
              child: Icon(icon, color: AppColors.context(context).textColor.withAlpha(200))),
          ),
        );
      },
    );
  }

  void _showSettingsDialog(BuildContext context) async{
    if(_isThereAPopUp && DateTime.now().difference(lastTickTime) <= minTickInterval) return;
    _isThereAPopUp = true;
    lastTickTime = DateTime.now();
    await Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
        return SettingsPopup(
          settingsDataProvider: AppServices.settingsDataProvider,
        );
      },
    )).then((any) {
      _isThereAPopUp = false;
    });
  }

  void _showAddTaskDialog(BuildContext context) async{
    if(_isThereAPopUp && DateTime.now().difference(lastTickTime) <= minTickInterval) return;
    _isThereAPopUp = true;
    lastTickTime = DateTime.now();
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierDismissible: true,
        pageBuilder: (_, __, ___) {
          return EditTaskPopup(tasksDataProvider: AppServices.tasksProvider, taskWheelUINotifier: taskWheelUINotifier);
      },
    )).then((any) {
      _isThereAPopUp = false;
    });
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







