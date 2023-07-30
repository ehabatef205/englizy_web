import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/student_home/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeCubit extends Cubit<StudentHomeStates> {
  StudentHomeCubit() : super(StudentHomeInitialState());

  static StudentHomeCubit get(context) => BlocProvider.of(context);

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

  Stream<QuerySnapshot> getDemo() {
    return FirebaseFirestore.instance.collection("demo").snapshots();
  }

  Stream<QuerySnapshot> getUnits() {
    return FirebaseFirestore.instance
        .collection("units")
        .where("view", isEqualTo: true)
        .where("level", isEqualTo: levelId ?? userModel!.level )
        .orderBy("time")
        .snapshots();
  }
}
