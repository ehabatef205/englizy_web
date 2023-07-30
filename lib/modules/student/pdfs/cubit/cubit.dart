import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/pdfs/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PDFSCubit extends Cubit<PDFSStates> {
  PDFSCubit() : super(PDFSInitialState());

  static PDFSCubit get(context) => BlocProvider.of(context);

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
        .where("view", isEqualTo: true)
        .where("level", isEqualTo: levelId ?? userModel!.level )
        .orderBy("time")
        .snapshots();
  }
}
