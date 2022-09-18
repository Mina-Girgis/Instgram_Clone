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

class UploadNewPostImageSuccess extends HomeState {}

class UploadNewPostImageFail extends HomeState {}

class AddNewPostSuccess extends HomeState {}

class AddNewPostFail extends HomeState {}

class AddToMyPostsSuccess extends HomeState {}

class AddToMyPostsFail extends HomeState {}

class AddNewPostLoading extends HomeState {}

class GetAllPostsSuccess extends HomeState {}

class GetAllPostsFail extends HomeState {}

class GetMyPostsIdsSuccess extends HomeState {}

class GetMyPostsIdsFail extends HomeState {}

class GetPostByIdSuccess extends HomeState {}

class GetPostByIdFail extends HomeState {}

class ChangeUserTmpData extends HomeState {}

class GetSpecificUserSuccess extends HomeState {}

class GetSpecificUserFail extends HomeState {}

class GetAllUsersSuccess extends HomeState {}

class GetAllUsersFail extends HomeState {}

class GetAllPostsForSpecificUserSuccess extends HomeState {}

class GetLikesForSpecificPostSuccess extends HomeState {}

class GetLikesForSpecificPostFail extends HomeState {}

class AddLikeSuccess extends HomeState {}

class AddLikeFail extends HomeState {}

class RemoveLikeSuccess extends HomeState {}

class RemoveLikeFail extends HomeState {}


class AddToPostsLikedSuccess extends HomeState {}

class AddToPostsLikedFail extends HomeState {}

class RemoveFromPostsLikedSuccess extends HomeState {}

class RemoveFromPostsLikedFail extends HomeState {}

class GetPostsILikedSuccess extends HomeState {}

class GetPostsILikedFail extends HomeState {}

class LikePostSuccess extends HomeState {}

class UnlikePostSuccess extends HomeState {}

class ChangeLikeStateInAllPosts extends HomeState {}














