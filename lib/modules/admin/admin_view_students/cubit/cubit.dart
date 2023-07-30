import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_students/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewStudentsCubit extends Cubit<AdminViewStudentsStates> {
  AdminViewStudentsCubit() : super(AdminViewStudentsInitialState());

  static AdminViewStudentsCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot> getStudents() {
    return FirebaseFirestore.instance.collection("users").where("admin", isEqualTo: false).snapshots();
  }
}
