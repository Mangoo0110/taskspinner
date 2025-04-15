import 'package:flutter/material.dart';

sealed class ButtonStatus {
  String message;
  ButtonStatus({required this.message});
}

class EnabledStatus extends ButtonStatus {
  EnabledStatus({super.message = "Enabled"});
}

class DisabledStatus extends ButtonStatus {
  DisabledStatus({super.message = "Disabled"});
}

class LoadingStatus extends ButtonStatus {
  LoadingStatus({super.message = "Loading"});
}

class ErrorStatus extends ButtonStatus {
  ErrorStatus({super.message = "Error"});
}

class SuccessStatus extends ButtonStatus {
  SuccessStatus({super.message = "Success"});
}

class ButtonStatusNotifier extends ChangeNotifier{
  ButtonStatus _status = DisabledStatus();
  ButtonStatus get status => _status;

  void setStatus(ButtonStatus status) {
    _status = status;
    notifyListeners();
  }

  void reset() {
    _status = EnabledStatus();
    notifyListeners();
  }
}