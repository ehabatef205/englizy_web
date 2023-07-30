import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_unit/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewStudentsInUnitCubit extends Cubit<AdminViewStudentsInUnitStates> {
  AdminViewStudentsInUnitCubit() : super(AdminViewStudentsInUnitInitialState());

  static AdminViewStudentsInUnitCubit get(context) => BlocProvider.of(context);

  String? uid = "";

  void onChanged(String newValue) {
    uid = newValue;
    print(uid);
    emit(ChangeIdState());
  }

  Stream<QuerySnapshot> getStudents() {
    return FirebaseFirestore.instance.collection("users").snapshots();
  }
}
