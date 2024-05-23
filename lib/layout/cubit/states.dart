abstract class AppStates {}

class AppInitialState extends AppStates {}

class AppGetDataLoadingState extends AppStates {}

class AppGetDataSuccessState extends AppStates {}

class AppGetDataFailureState extends AppStates {
  String error;

  AppGetDataFailureState(this.error);
}

class AppGetPostsLoadingState extends AppStates {}

class AppGetPostsSuccessState extends AppStates {}

class AppGetPostsFailureState extends AppStates {
  String error;

  AppGetPostsFailureState(this.error);
}

class AppGetCommentPostsSuccessState extends AppStates {}

class AppGetCommentPostsFailureState extends AppStates {
  String error;

  AppGetCommentPostsFailureState(this.error);
}

class AppChangeModeState extends AppStates {}

class AppChangeBottomNavState extends AppStates {}

class AppNewPostState extends AppStates {}

class AppNotificationsState extends AppStates {}

class AppGetProfileImagePickedSuccessState extends AppStates {}

class AppGetProfileImagePickedFailureState extends AppStates {}

class AppGetCoverImagePickedSuccessState extends AppStates {}

class AppGetCoverImagePickedFailureState extends AppStates {}

class AppUploadProfileImageSuccessState extends AppStates {}

class AppUploadProfileImageFailureState extends AppStates {}

class AppUploadCoverImageSuccessState extends AppStates {}

class AppUploadCoverImageFailureState extends AppStates {}

class AppUpdateDataLoadingState extends AppStates {}

class AppUpdateDataErrorState extends AppStates {}

class AppUpdateImageLoadingState extends AppStates {}

class AppUpdateCoverLoadingState extends AppStates {}

class AppGetPostImagePickedSuccessState extends AppStates {}

class AppGetPostImagePickedFailureState extends AppStates {}

class AppGetCommentImagePickedSuccessState extends AppStates {}

class AppGetCommentImagePickedFailureState extends AppStates {}

class AppGetMessageImagePickedSuccessState extends AppStates {}

class AppGetMessageImagePickedFailureState extends AppStates {}

class AppGetChatImagePickedSuccessState extends AppStates {}

class AppGetChatImagePickedFailureState extends AppStates {}

class AppCreatePostLoadingState extends AppStates {}

class AppCreatePostSuccessState extends AppStates {}

class AppCreatePostFailureState extends AppStates {}

class AppRemovePostImageState extends AppStates {}

class AppRemoveCommentImageState extends AppStates {}

class AppRemoveMessageImageState extends AppStates {}

class AppLikePostSuccessState extends AppStates {}

class AppLikePostFailureState extends AppStates {}

class AppCommentPostSuccessState extends AppStates {}

class AppPostDeleteSuccessState extends AppStates {}

class AppPostDeleteFailureState extends AppStates {}

class AppCommentDeleteSuccessState extends AppStates {}

class AppCommentDeleteFailureState extends AppStates {}

class AppCommentPostLoadingState extends AppStates {}

class AppCommentPostFailureState extends AppStates {}

class AppGetUsersSuccessState extends AppStates {}

class AppGetUsersFailureState extends AppStates {}

class AppSendMessageLoadingState extends AppStates {}

class AppSendMessageSuccessState extends AppStates {}

class AppSendMessageFailureState extends AppStates {}

class AppSearchLoadingState extends AppStates {}

class AppSearchSuccessState extends AppStates {}

class AppSearchFailureState extends AppStates {}

class AppDeleteMessageSuccessState extends AppStates {}

class AppDeleteMessageFailureState extends AppStates {}

class AppGetMessagesSuccessState extends AppStates {}
