part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ChangeBottomNavigationBarIndex extends HomeState {}

class ChangeUpdatingValueField extends HomeState {}

class DeleteUserSuccess extends HomeState {}

class DeleteUserFail extends HomeState {}

class AddUserSuccess extends HomeState {}

class AddUserFail extends HomeState {}

class UpdateFunctionSuccess extends HomeState {}

class UpdateFunctionFail extends HomeState {}

class ChangeInitialValuesForEditProfile extends HomeState {}

class ChangeNameController extends HomeState {}

class ChangeUsernameController extends HomeState {}

class ChangeBioController extends HomeState {}

class ChangeUpdateController extends HomeState {}

class UpdateUserDataSuccess extends HomeState {}

class UpdateUserDataFail extends HomeState {}

class ChangeDropdownButtonHintText extends HomeState {}

class GetImagesPathLoading extends HomeState {}

class GetImagesPathSuccess extends HomeState {}

class ChangeImageIndex extends HomeState {}








