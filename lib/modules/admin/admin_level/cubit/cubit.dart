import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_level/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminLevelCubit extends Cubit<AdminLevelStates> {
  AdminLevelCubit() : super(AdminLevelInitialState());

  static AdminLevelCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot> getLevels() {
    return FirebaseFirestore.instance.collection("levels").orderBy("time").snapshots();
  }
}
