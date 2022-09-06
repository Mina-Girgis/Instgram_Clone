part of 'signup_cubit.dart';

@immutable
abstract class SignupState {}

class SigninInitial extends SignupState {}

class ChangeSigninMethodIndex extends SignupState {}

class ChangeValidEmail extends SignupState {}

class OTPSendSuccess extends SignupState {}

class OTPSendFail extends SignupState {}

class OTPCodeSuccess extends SignupState {}

class OTPCodeFail extends SignupState {}

class SendOTPLoading extends SignupState {}

class SendOTPPhoneNumberFail extends SignupState {}

class SendOTPPhoneNumberSuccess extends SignupState {}

class VerifyOTPPhoneNumberSuccess extends SignupState {}

class VerifyOTPPhoneNumberFail extends SignupState {}

class VerifyEmailAndPhoneLoading extends SignupState {}

class ChangeCheckBoxBoolean extends SignupState {}


class AddNewUserLoading extends SignupState {}


class AddNewUserSuccess extends SignupState {}


class AddNewUserFail extends SignupState {}

class GetUsersSuccess extends SignupState {}

class GetUsersFail extends SignupState {}

class ChangePhoneNumberSuccess extends SignupState {}

















