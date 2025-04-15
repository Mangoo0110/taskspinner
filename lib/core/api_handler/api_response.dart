
// import 'failure.dart' show DataCRUDFailure;

// class ApiResponse<T> {
//   void onDone(void handleDone()?){

//   }

//   T? _data;

//   void onData;
//   void Function(Exception? failure) onError;

//   ApiResponse();


//   Future<void> asyncCall({
//     required Future<T> Function() call,
//   }) async{
//     try {
//       // Simulate some data fetching
//       onData(await call());
//     } catch (e) {
//       onError(Exception(e));
//     }
//   }

//   Future<void> staticCall({
//     required T Function() call,
//   }) async{
//     try {
//       // Simulate some data fetching
//       onData(call());
//     } catch (e) {
//       onError(Exception(e));
//     }
//   }
// }