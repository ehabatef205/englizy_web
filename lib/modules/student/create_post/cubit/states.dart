abstract class CreatePostsStates {}

class CreatePostsInitialState extends CreatePostsStates {}

class CreatePostsCreatePostLoadingState extends CreatePostsStates {}
class ChangeState extends CreatePostsStates {}

class CreatePostsCreatePostSuccessState extends CreatePostsStates {}

class CreatePostsCreatePostErrorState extends CreatePostsStates {}

class CreatePostsPostImagePickedSuccessState extends CreatePostsStates {}

class CreatePostsPostImagePickedErrorState extends CreatePostsStates {}

class CreatePostsRemovePostImageState extends CreatePostsStates {}

class CreatePostsGetPostsLoadingState extends CreatePostsStates {}

class CreatePostsGetPostsSuccessState extends CreatePostsStates {}

class CreatePostsGetPostsErrorState extends CreatePostsStates
{
  final String error;

  CreatePostsGetPostsErrorState(this.error);
}