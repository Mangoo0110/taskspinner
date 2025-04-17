import 'package:dartz/dartz.dart';
import '../../../../api_handler/failure.dart';
import '../../../../usecases/usecases.dart';
import '../entity/setting.dart';
import '../repo/settings_repo.dart';

class StreamAppearence implements EitherUsecase<Stream<Setting>, NoParams> {
  final SettingsRepo  repository;

  StreamAppearence(this.repository);
  
  @override
  Either<DataCRUDFailure, Stream<Setting>> call(NoParams params){
    return  repository.streamSetting();
  }

}