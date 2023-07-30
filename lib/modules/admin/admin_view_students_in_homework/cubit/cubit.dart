import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_homework/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewStudentsInHomeworkCubit extends Cubit<AdminViewStudentsInHomeworkStates> {
  AdminViewStudentsInHomeworkCubit() : super(AdminViewStudentsInHomeworkInitialState());

  static AdminViewStudentsInHomeworkCubit get(context) => BlocProvider.of(context);

  String? uid = "";

  void onChanged(String newValue) {
    uid = newValue;
    print(uid);
    emit(ChangeIdState());
  }

  Stream<QuerySnapshot> getHomework(String id) {
    return FirebaseFirestore.instance.collection("units").doc(id).collection("homework").orderBy("time").snapshots();
  }
}
