import 'package:englizy_app/modules/student/change_password/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordStates> {
  ChangePasswordCubit() : super(ChangePasswordInitialState());

  static ChangePasswordCubit get(context) => BlocProvider.of(context);

  TextEditingController lastPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isPassword = true;
  bool isPassword2 = true;
  bool isPassword3 = true;

  void passwordChange() {
    isPassword = !isPassword;
    emit(ChangeState());
  }

  void passwordChange2() {
    isPassword2 = !isPassword2;
    emit(ChangeState());
  }

  void passwordChange3() {
    isPassword3 = !isPassword3;
    emit(ChangeState());
  }

  void changePassword({required BuildContext context}) {
    if(formKey.currentState!.validate()){
      formKey.currentState!.save();
      User user = FirebaseAuth.instance.currentUser!;
      AuthCredential credential = EmailAuthProvider.credential(
          email: userModel!.email, password: lastPasswordController.text);

      user.reauthenticateWithCredential(credential).then((value) {
        user.updatePassword(newPasswordController.text).then((value2) {
          Navigator.pop(context);
        }).catchError((error) {
          print(error);
        });
      }).catchError((error) {
        Fluttertoast.showToast(
          msg: error.message!,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
    }
  }
}
