import 'package:dartz/dartz.dart';
import '../../../../api_handler/failure.dart';
import '../../../../usecases/usecases.dart';
import '../entity/appearence.dart';
import '../repo/settings_repo.dart';

class StreamAppearence implements EitherUsecase<Stream<Appearence>, NoParams> {
  final SettingsRepo  repository;

  StreamAppearence(this.repository);
  
  @override
  Either<DataCRUDFailure, Stream<Appearence>> call(NoParams params){
    return  repository.streamAppearence();
  }

}