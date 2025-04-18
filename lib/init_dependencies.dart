import 'package:get_it/get_it.dart';
import 'package:taskspinner/app/data/datasources/task_local_datasource.dart';
import 'package:taskspinner/app/domain/usecases/opendb.dart';
import 'package:taskspinner/app/domain/usecases/stream_wheel_tasks.dart';
import 'package:taskspinner/core/features/settings/data/datasources/local/settings_local_datasources.dart';
import 'package:taskspinner/core/features/settings/data/repo/settings_repo_impl.dart';
import 'package:taskspinner/core/features/settings/domain/repo/settings_repo.dart';
import 'package:taskspinner/core/features/settings/domain/usecases/open_settings_db.dart';
import 'package:taskspinner/core/features/settings/domain/usecases/save_appearence.dart';
import 'package:taskspinner/core/features/settings/domain/usecases/stream_appearence.dart';
import 'package:taskspinner/core/services/app_services.dart';

import 'app/data/repo/task_repo_impl.dart';
import 'app/domain/repo/task_repo.dart';
import 'app/domain/usecases/delete_tasks.dart';
import 'app/domain/usecases/create_task.dart';
import 'app/domain/usecases/update_task.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  // Dependencies
  _settingsServiceDI();
  _taskServiceDI();

  // Call essential service initialization
  await AppServices.init();
}




void _taskServiceDI() {
  //::: Remote Datasource [register singletone]
  // -----none-----

  //::: Local Datasource [register singletone]
  serviceLocator.registerLazySingleton<TaskLocalDatasource>(() => TaskHiveImpl());

  //::: Repo [register factory]
  serviceLocator.registerFactory<TaskRepo>(
    () => TaskRepoImpl(
      serviceLocator<TaskLocalDatasource>(),
    ),
  );

  //::: Usecases
  serviceLocator.registerLazySingleton(
    () => DeleteTask(serviceLocator<TaskRepo>()),
  );
  serviceLocator.registerLazySingleton(
    () => CreateTask(serviceLocator<TaskRepo>()),
  );
  serviceLocator.registerLazySingleton(
    () => UpdateTask(serviceLocator<TaskRepo>()),
  );
  serviceLocator.registerLazySingleton(
    () => StreamWheelTasks(serviceLocator<TaskRepo>()),
  );
  serviceLocator.registerLazySingleton(
    () => OpenWheelTaskDb(serviceLocator<TaskRepo>()),
  );
}


void _settingsServiceDI() {
  //::: Remote Datasource [register singletone]
  // -----none-----

  //::: Local Datasource [register singletone]
  serviceLocator.registerLazySingleton<SettingsLocalDatasource>(() => SettingsHiveImpl());

  //::: Repo [register factory]
  serviceLocator.registerFactory<SettingsRepo>(
    () => SettingsRepoImpl(
      serviceLocator<SettingsLocalDatasource>(),
    ),
  );

  //::: Usecases
  serviceLocator.registerLazySingleton(
    () => SaveSetting(serviceLocator<SettingsRepo>()),
  );
  serviceLocator.registerLazySingleton(
    () => StreamAppearence(serviceLocator<SettingsRepo>()),
  );
  serviceLocator.registerLazySingleton(
    () => OpenSettingsDb(serviceLocator<SettingsRepo>()),
  );
}
