abstract class AdminCreatePostsStates {}

class AdminCreatePostsInitialState extends AdminCreatePostsStates {}

class AdminCreatePostsCreatePostLoadingState extends AdminCreatePostsStates {}
class ChangeState extends AdminCreatePostsStates {}

class AdminCreatePostsCreatePostSuccessState extends AdminCreatePostsStates {}

class AdminCreatePostsCreatePostErrorState extends AdminCreatePostsStates {}

class AdminCreatePostsPostImagePickedSuccessState extends AdminCreatePostsStates {}

class AdminCreatePostsPostImagePickedErrorState extends AdminCreatePostsStates {}

class AdminCreatePostsRemovePostImageState extends AdminCreatePostsStates {}

class AdminCreatePostsGetPostsLoadingState extends AdminCreatePostsStates {}

class AdminCreatePostsGetPostsSuccessState extends AdminCreatePostsStates {}

class AdminCreatePostsGetPostsErrorState extends AdminCreatePostsStates
{
  final String error;

  AdminCreatePostsGetPostsErrorState(this.error);
}