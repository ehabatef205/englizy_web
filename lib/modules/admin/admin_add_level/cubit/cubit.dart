import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_level/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddLevelCubit extends Cubit<AdminAddLevelStates> {
  AdminAddLevelCubit() : super(AdminAddLevelInitialState());

  static AdminAddLevelCubit get(context) => BlocProvider.of(context);

  TextEditingController nameLevelController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> addLevel({required BuildContext context}) async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      isLoading = true;
      emit(LoadingState());
      await FirebaseFirestore.instance.collection("levels").add({
        "name": nameLevelController.text,
        "time": DateTime.now(),
      }).whenComplete(() async{
        isLoading = false;
        Navigator.pop(context);
        emit(LoadingSuccessState());
      }).catchError((error) {
        emit(LoadingErrorState());
      });
    }
  }
}
