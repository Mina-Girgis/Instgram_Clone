part of 'global_cubit.dart';

@immutable
abstract class GlobalState {}

class GlobalInitial extends GlobalState {}

class GlobalGetUsersSuccess extends GlobalState {}

class GlobalGetUsersFail extends GlobalState {}

class ChangeCurrentUserSuccess extends GlobalState {}

class GetCurrentUserSuccess extends GlobalState {}
