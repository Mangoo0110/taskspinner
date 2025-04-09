import 'package:flutter/material.dart';
import '../../../core/commons/enums/tasktype.dart';
import '../../../core/commons/widgets/custom_button.dart';
import '../../../core/services/app_services.dart';
import '../../../utils/constants/app_colors.dart';
import '../../../utils/constants/app_names.dart';
import '../../../utils/constants/app_sizes.dart';
import '../controllers/tasks_notifier.dart';
import '../widgets/wheel.dart';
import 'task_bar.dart';

class SpinnerTaskApp extends StatelessWidget {
  const SpinnerTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder:
          (context, constraints) => Scaffold(
            appBar: AppBar(
              title: Text(AppNames.appName),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: _drawerButton(onTap: () async {}),
                ),
              ],
            ),

            endDrawer: SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth * .6,
              child: TaskBar(tasksNotifier: AppServices.tasksNotifier),
            ),

            body: Column(
              children: [
                Container(
                  width: constraints.maxWidth,
                  height: 370,
                  color: Colors.white,
                  child: Center(child: Wheel()),
                ),

                
              ],
            ),
          ),
    );
  }

  Widget _drawerButton({required VoidCallback onTap}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomButton(
          size: Size(50, 100),
          borderRadius: AppSizes.smallBorderRadius,
          onTap: () {
            print("tapped");
            Scaffold.of(context).openEndDrawer();
          },
          child: Container(
            height: 50,
            width: 100,
            decoration: BoxDecoration(
              color: AppColors.context(context).accentColor,
              borderRadius: AppSizes.smallBorderRadius,
            ),
            child: TaskModifyButton(),
          ),
        );
      },
    );
  }
}

class TaskModifyButton extends StatefulWidget {
  const TaskModifyButton({super.key});

  @override
  State<TaskModifyButton> createState() => _TaskModifyButtonState();
}

class _TaskModifyButtonState extends State<TaskModifyButton> {

  late TaskType _currentTaskType;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    AppServices.tasksNotifier.addListener(() {
      if(mounted) {
        setState(() {
          _currentTaskType = AppServices.tasksNotifier.currentTaskType;
        });
      }
      
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    _currentTaskType = AppServices.tasksNotifier.currentTaskType;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_alt,
                color: AppColors.context(context).buttonTextColor,
              ),
              SizedBox(width: 4),
              Text(
                _currentTaskType.name.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.context(context).buttonTextColor,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
