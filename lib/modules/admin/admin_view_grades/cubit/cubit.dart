import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_grades/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewGradesCubit extends Cubit<AdminViewGradesStates> {
  AdminViewGradesCubit() : super(AdminViewGradesInitialState());

  static AdminViewGradesCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot> getLevels() {
    return FirebaseFirestore.instance.collection("levels").orderBy("time").snapshots();
  }
}
