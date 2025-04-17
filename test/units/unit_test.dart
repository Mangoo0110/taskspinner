// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:taskspinner/app/domain/entities/wheel_task.dart';
import 'package:taskspinner/app/ui/controllers/task_wheel_ui_notifier.dart';
import 'package:taskspinner/core/helpers/dekhao.dart';
import 'package:taskspinner/core/services/app_services.dart';


void main() async{
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(const MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  group('Testing App Provider', () {
        //var setting = AppServices.settingsDataProvider;

        test('Setting data provider presence', () {
          dekhao(WheelTask.dummies.length);
          //dekhao(TaskWheelUINotifier(controller: StreamController(), tasksDataProvider: AppServices.tasksProvider).upToDateCurrentTasks.tasks.length);
          expect(TaskWheelUINotifier(controller: StreamController(), tasksDataProvider: AppServices.tasksProvider).upToDateCurrentTasks.tasks.length >= 2, true);
          expect(WheelTask.dummies.length == 2, true);
          //expect(setting.currentSetting == Setting.defaultSetting(), false);
          //expect(serviceLocator.hasScope("SettingsLocalDatasource"), true);
          //expect(serviceLocator.hasScope("SettingsRepo"), true);
          //expect(serviceLocator.hasScope("SaveAppearence"), true);
        });    
      });

  
}

