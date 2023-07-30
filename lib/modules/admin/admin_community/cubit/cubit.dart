import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_community/cubit/states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminCommunityCubit extends Cubit<AdminCommunityStates> {
  AdminCommunityCubit() : super(AdminCommunityInitialState());

  static AdminCommunityCubit get(context) => BlocProvider.of(context);

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
        .where("level", isEqualTo: levelId)
        .orderBy("time")
        .snapshots();
  }
}
