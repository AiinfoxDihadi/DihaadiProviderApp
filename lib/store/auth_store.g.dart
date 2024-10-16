// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AuthStore on _AuthStore, Store {
  late final _$isPhoneVisibleAtom =
      Atom(name: '_AuthStore.isPhoneVisible', context: context);

  @override
  bool get isPhoneVisible {
    _$isPhoneVisibleAtom.reportRead();
    return super.isPhoneVisible;
  }

  @override
  set isPhoneVisible(bool value) {
    _$isPhoneVisibleAtom.reportWrite(value, super.isPhoneVisible, () {
      super.isPhoneVisible = value;
    });
  }

  late final _$isOTPVisibleAtom =
      Atom(name: '_AuthStore.isOTPVisible', context: context);

  @override
  bool get isOTPVisible {
    _$isOTPVisibleAtom.reportRead();
    return super.isOTPVisible;
  }

  @override
  set isOTPVisible(bool value) {
    _$isOTPVisibleAtom.reportWrite(value, super.isOTPVisible, () {
      super.isOTPVisible = value;
    });
  }

  late final _$phoneNumberAtom =
      Atom(name: '_AuthStore.phoneNumber', context: context);

  @override
  String get phoneNumber {
    _$phoneNumberAtom.reportRead();
    return super.phoneNumber;
  }

  @override
  set phoneNumber(String value) {
    _$phoneNumberAtom.reportWrite(value, super.phoneNumber, () {
      super.phoneNumber = value;
    });
  }

  late final _$otpAtom = Atom(name: '_AuthStore.otp', context: context);

  @override
  String get otp {
    _$otpAtom.reportRead();
    return super.otp;
  }

  @override
  set otp(String value) {
    _$otpAtom.reportWrite(value, super.otp, () {
      super.otp = value;
    });
  }

  late final _$canResendAtom =
      Atom(name: '_AuthStore.canResend', context: context);

  @override
  bool get canResend {
    _$canResendAtom.reportRead();
    return super.canResend;
  }

  @override
  set canResend(bool value) {
    _$canResendAtom.reportWrite(value, super.canResend, () {
      super.canResend = value;
    });
  }

  late final _$remainingTimeAtom =
      Atom(name: '_AuthStore.remainingTime', context: context);

  @override
  int get remainingTime {
    _$remainingTimeAtom.reportRead();
    return super.remainingTime;
  }

  @override
  set remainingTime(int value) {
    _$remainingTimeAtom.reportWrite(value, super.remainingTime, () {
      super.remainingTime = value;
    });
  }

  late final _$_AuthStoreActionController =
      ActionController(name: '_AuthStore', context: context);

  @override
  void toggleVisibility() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.toggleVisibility');
    try {
      return super.toggleVisibility();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setPhoneNumber(String value) {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.setPhoneNumber');
    try {
      return super.setPhoneNumber(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setOTP(String value) {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.setOTP');
    try {
      return super.setOTP(value);
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool verifyPhoneNumber() {
    final _$actionInfo = _$_AuthStoreActionController.startAction(
        name: '_AuthStore.verifyPhoneNumber');
    try {
      return super.verifyPhoneNumber();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool verifyOTP() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.verifyOTP');
    try {
      return super.verifyOTP();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimer() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.startTimer');
    try {
      return super.startTimer();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetTimer() {
    final _$actionInfo =
        _$_AuthStoreActionController.startAction(name: '_AuthStore.resetTimer');
    try {
      return super.resetTimer();
    } finally {
      _$_AuthStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isPhoneVisible: ${isPhoneVisible},
isOTPVisible: ${isOTPVisible},
phoneNumber: ${phoneNumber},
otp: ${otp},
canResend: ${canResend},
remainingTime: ${remainingTime}
    ''';
  }
}
