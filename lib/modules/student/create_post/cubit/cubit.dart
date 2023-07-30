import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/create_post/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostsCubit extends Cubit<CreatePostsStates> {
  CreatePostsCubit() : super(CreatePostsInitialState());

  static CreatePostsCubit get(context) => BlocProvider.of(context);

  TextEditingController textController = TextEditingController();

  TextEditingController levelController = TextEditingController();

  bool isLoading = false;

  String? levelId;

  void changeLevelId(String? id) {
    levelId = id;
    emit(ChangeState());
  }

  void changeLevel(String? level) {
    levelController.text = level!;
    emit(ChangeState());
  }

  void createPost({required BuildContext context}) {
    if (textController.text.trim() != "" && levelId != null) {
      FirebaseFirestore.instance.collection('posts').add({
        "uid": userModel!.uid,
        "time": DateTime.now(),
        "text": textController.text,
        "level": levelId,
        "view": true,
        "likes": [],
      }).then((value) {
        Navigator.pop(context);
        emit(CreatePostsCreatePostSuccessState());
      }).catchError((error) {
        emit(CreatePostsCreatePostErrorState());
      });
    }
  }
}
