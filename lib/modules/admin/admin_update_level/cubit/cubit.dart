import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_update_level/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUpdateLevelCubit extends Cubit<AdminUpdateLevelStates> {
  AdminUpdateLevelCubit() : super(AdminUpdateLevelInitialState());

  static AdminUpdateLevelCubit get(context) => BlocProvider.of(context);

  TextEditingController nameLevelController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  void changeText({required String text}){
    nameLevelController.text = text;
    emit(ChangeTextState());
  }

  Future<void> updateLevel({required BuildContext context, required String id}) async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      isLoading = true;
      emit(LoadingState());
      await FirebaseFirestore.instance.collection("levels").doc(id).update({
        "name": nameLevelController.text,
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
