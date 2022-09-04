part of 'signin_cubit.dart';

@immutable
abstract class SigninState {}

class SigninInitial extends SigninState {}

class ChangeSigninMethodIndex extends SigninState {}

class ChangeValidEmail extends SigninState {}

class OTPSendSuccess extends SigninState {}

class OTPSendFail extends SigninState {}

class OTPCodeSuccess extends SigninState {}

class OTPCodeFail extends SigninState {}

class SendOTPLoading extends SigninState {}

