import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_pdfs/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPDFSCubit extends Cubit<AdminPDFSStates> {
  AdminPDFSCubit() : super(AdminPDFSInitialState());

  static AdminPDFSCubit get(context) => BlocProvider.of(context);

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

  Stream<QuerySnapshot> getPdfs() {
    return FirebaseFirestore.instance
        .collection("pdfs")
        .where("level", isEqualTo: levelId)
        .orderBy("time")
        .snapshots();
  }
}
