import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_parts/cubit/states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewPartsCubit extends Cubit<AdminViewPartsStates> {
  AdminViewPartsCubit() : super(AdminViewPartsInitialState());

  static AdminViewPartsCubit get(context) => BlocProvider.of(context);

  Stream<QuerySnapshot> getParts(String id) {
    return FirebaseFirestore.instance.collection("units").doc(id).collection("parts").orderBy("time").snapshots();
  }
}
