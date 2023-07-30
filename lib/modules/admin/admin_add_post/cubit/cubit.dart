import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_post/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddPostCubit extends Cubit<AdminAddPostStates> {
  AdminAddPostCubit() : super(AdminAddPostInitialState());

  static AdminAddPostCubit get(context) => BlocProvider.of(context);

  TextEditingController textController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> addPost({required BuildContext context}) async{
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      isLoading = true;
      emit(LoadingState());
      await FirebaseFirestore.instance.collection("posts_of_teacher").add({
        "text": textController.text,
        "link": linkController.text,
        "time": DateTime.now(),
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
