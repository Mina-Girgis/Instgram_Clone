part of 'login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class ValidEmailAndPasswordLoading extends LoginState {}


class validEmailAndPasswordSuccess extends LoginState {}


class validEmailAndPasswordFail extends LoginState {}

