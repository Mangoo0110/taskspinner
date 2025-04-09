import 'package:get_it/get_it.dart';

final serviceLocator = GetIt.instance;

//::: Datasources [register singletone]

//::: Repo [register factory]

//::: Usecases

Future<void> initDependencies() async {
}




// void _imageService() {
//   //::: Remote Datasource [register singletone]
//   serviceLocator.registerLazySingleton(() => ImageFirebaseStorageImpl.instance);

//   //::: Local Datasource [register singletone]
//   serviceLocator.registerLazySingleton(() => ImageHiveDatasouceImpl.instance);

//   //::: Repo [register factory]
//   serviceLocator.registerFactory(
//     () => ImageRepoImpl(
//       serviceLocator<ImageFirebaseStorageImpl>(),
//       serviceLocator<ImageHiveDatasouceImpl>(),
//     ),
//   );

  //::: Usecases
//   serviceLocator.registerLazySingleton(
//     () => DeleteImage(serviceLocator<ImageRepoImpl>()),
//   );
//   serviceLocator.registerLazySingleton(
//     () => DeleteImageFromLocalDb(serviceLocator<ImageRepoImpl>()),
//   );
//   serviceLocator.registerLazySingleton(
//     () => FetchImage(serviceLocator<ImageRepoImpl>()),
//   );
//   serviceLocator.registerLazySingleton(
//     () => FetchImageFromLocalDb(serviceLocator<ImageRepoImpl>()),
//   );
//   serviceLocator.registerLazySingleton(
//     () => SaveImageWithUrl(serviceLocator<ImageRepoImpl>()),
//   );
//   serviceLocator.registerLazySingleton(
//     () => SaveImageWithReferencePath(serviceLocator<ImageRepoImpl>()),
//   );
//   serviceLocator.registerLazySingleton(
//     () => SaveImageLocally(serviceLocator<ImageRepoImpl>()),
//   );
// }
