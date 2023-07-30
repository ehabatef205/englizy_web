import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_home/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeCubit extends Cubit<AdminHomeStates> {
  AdminHomeCubit() : super(AdminHomeInitialState());

  static AdminHomeCubit get(context) => BlocProvider.of(context);

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
        .where("level", isEqualTo: levelId)
        .orderBy("time")
        .snapshots();
  }
}
