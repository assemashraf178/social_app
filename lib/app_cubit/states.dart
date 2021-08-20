abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppPermissionSuccessState extends AppStates {}

class AppPermissionErrorState extends AppStates {}

class AppChangeThemeModeLoadingState extends AppStates {}

class AppChangeThemeModeSuccessState extends AppStates {}

class AppChangeThemeModeErrorState extends AppStates {}

class AppRegisterLoadingState extends AppStates {}

class GetUserDataLoadingState extends AppStates {}

class GetUserDataSuccessState extends AppStates {}

class GetUserDataErrorState extends AppStates {
  final String error;

  GetUserDataErrorState(this.error);
}

class GetPostsLoadingState extends AppStates {}

class GetPostsSuccessState extends AppStates {}

class GetPostsErrorState extends AppStates {
  final String error;

  GetPostsErrorState(this.error);
}

class GetPostsLikesSuccessState extends AppStates {}

class GetAllUsersLoadingState extends AppStates {}

class GetAllUsersSuccessState extends AppStates {}

class GetAllUsersErrorState extends AppStates {
  final String error;

  GetAllUsersErrorState(this.error);
}

class AppChangeNavBarState extends AppStates {}

class UpdateProfileImageSuccessState extends AppStates {}

class UpdateProfileImageErrorState extends AppStates {}

class UpdateCoverImageSuccessState extends AppStates {}

class UpdateCoverImageErrorState extends AppStates {}

class UploadProfileImageLoadingState extends AppStates {}

class UploadProfileImageSuccessState extends AppStates {}

class UploadProfileImageErrorState extends AppStates {}

class UploadMessageImageLoadingState extends AppStates {}

class UploadMessageImageSuccessState extends AppStates {}

class UploadMessageImageErrorState extends AppStates {}

class UploadCoverImageLoadingState extends AppStates {}

class UploadCoverImageSuccessState extends AppStates {}

class UploadCoverImageErrorState extends AppStates {}

class UpdateDataLoadingState extends AppStates {}

class UpdateDataSuccessState extends AppStates {}

class UpdateDataErrorState extends AppStates {}

class CreatePostLoadingState extends AppStates {}

class CreatePostSuccessState extends AppStates {}

class CreatePostErrorState extends AppStates {}

class LikePostSuccessState extends AppStates {}

class LikePostErrorState extends AppStates {}

class CommentPostSuccessState extends AppStates {}

class CommentPostErrorState extends AppStates {}

class CreatePostImageSuccessState extends AppStates {}

class CreatePostImageErrorState extends AppStates {}

class PostImageRemoveState extends AppStates {}

class SendMessageSuccessState extends AppStates {}

class SendMessageErrorState extends AppStates {}

class GetMessageSuccessState extends AppStates {}

class GetMessageErrorState extends AppStates {}
