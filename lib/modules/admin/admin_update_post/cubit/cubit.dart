import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_update_post/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUpdatePostCubit extends Cubit<AdminUpdatePostStates> {
  AdminUpdatePostCubit() : super(AdminUpdatePostInitialState());

  static AdminUpdatePostCubit get(context) => BlocProvider.of(context);

  TextEditingController textController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  void changeControllers({required String text, required String link}) {
    textController.text = text;
    linkController.text = link;
    emit(ChangeControllersState());
  }

  Future<void> addPost({required BuildContext context, required String id}) async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      isLoading = true;
      emit(LoadingState());
      await FirebaseFirestore.instance.collection("posts_of_teacher").doc(id).update({
        "text": textController.text,
        "link": linkController.text,
      }).whenComplete(() async{
        isLoading = false;
        Navigator.pop(context);
        emit(LoadingSuccessState());
      }).catchError((error) {
        isLoading = false;
        emit(LoadingErrorState());
      });
    }
  }
}
