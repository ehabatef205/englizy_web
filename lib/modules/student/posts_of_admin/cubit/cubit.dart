import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/posts_of_admin/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsOfAdminCubit extends Cubit<PostsOfAdminStates> {
  PostsOfAdminCubit() : super(PostsOfAdminInitialState());

  static PostsOfAdminCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot> getPostsOfTeacher() {
    return FirebaseFirestore.instance
        .collection("posts_of_teacher")
        .orderBy("time")
        .snapshots();
  }
}
