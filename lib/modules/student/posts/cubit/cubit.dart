import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/posts/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsCubit extends Cubit<PostsStates> {
  PostsCubit() : super(PostsInitialState());

  static PostsCubit get(context) => BlocProvider.of(context);

  TextEditingController commentController = TextEditingController();

  bool isExists = false;

  String? levelId;
  String? level;

  void changeLevelId(String? newLevel) {
    levelId = newLevel;
    emit(ChangeState());
  }

  void changeLevel(String? newLevel) {
    level = newLevel;
    emit(ChangeState());
  }

  Stream<QuerySnapshot> getPosts() {
    return FirebaseFirestore.instance
        .collection("posts")
        .where("view", isEqualTo: true)
        .where("level", isEqualTo: levelId?? userModel!.level)
        .orderBy("time")
        .snapshots();
  }
}
