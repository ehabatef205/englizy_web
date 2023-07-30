import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/comment_of_post/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CommentOfPostCubit extends Cubit<CommentOfPostStates> {
  CommentOfPostCubit() : super(CommentOfPostInitialState());

  static CommentOfPostCubit get(context) => BlocProvider.of(context);

  TextEditingController commentController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Stream<QuerySnapshot> getComments({required String id}) {
    return FirebaseFirestore.instance
        .collection("posts")
        .doc(id)
        .collection("comments")
        .where("view", isEqualTo: true)
        .orderBy("time")
        .snapshots();
  }

  Stream<DocumentSnapshot> getDataOfUser({required String uid}) {
    return FirebaseFirestore.instance.collection("users").doc(uid).snapshots();
  }

  void sendComment({required String id}) {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      FirebaseFirestore.instance
          .collection("posts")
          .doc(id)
          .collection("comments")
          .add({
        "uid": userModel!.uid,
        "text": commentController.text,
        "time": DateTime.now(),
        "view": true,
      }).whenComplete(() {
        commentController.clear();
      });
    }
  }
}
