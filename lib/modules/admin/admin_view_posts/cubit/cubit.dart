import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_posts/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewPostsCubit extends Cubit<AdminViewPostsStates> {
  AdminViewPostsCubit() : super(AdminViewPostsInitialState());

  static AdminViewPostsCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot> getPostsOfTeacher() {
    return FirebaseFirestore.instance
        .collection("posts_of_teacher")
        .orderBy("time")
        .snapshots();
  }

  void deletePost({required String id}) {
    FirebaseFirestore.instance.collection("posts_of_teacher").doc(id).delete();
  }
}
