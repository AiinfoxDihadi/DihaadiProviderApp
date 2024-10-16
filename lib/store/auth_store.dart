import 'dart:async';
import 'package:mobx/mobx.dart';

part 'auth_store.g.dart';

class AuthStore = _AuthStore with _$AuthStore;

abstract class _AuthStore with Store {
  @observable
  bool isPhoneVisible = true;

  @observable
  bool isOTPVisible = false;

  @observable
  String phoneNumber = '';

  @observable
  String otp = '';

  @action
  void toggleVisibility() {
    isPhoneVisible = !isPhoneVisible;
    isOTPVisible = !isOTPVisible;
  }

  @action
  void setPhoneNumber(String value) {
    phoneNumber = value;
  }

  @action
  void setOTP(String value) {
    otp = value;
  }

  @action
  bool verifyPhoneNumber() {
    return phoneNumber == '9876543210';
  }

  @action
  bool verifyOTP() {
    return otp == '1234';
  }

  @observable
  bool canResend = false;

  @observable
  int remainingTime = 30;

  Timer? _timer;

  @action
  void startTimer() {
    remainingTime = 30;
    canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (remainingTime > 0) {
        remainingTime--;
      } else {
        canResend = true;
        _timer?.cancel();
      }
    });
  }

  @action
  void resetTimer() {
    remainingTime = 30;
    canResend = false;
    _timer?.cancel();
  }

}