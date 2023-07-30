import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/layout/app_layout.dart';
import 'package:englizy_app/layout/cubit/cubit.dart';
import 'package:englizy_app/models/user_model.dart';
import 'package:englizy_app/modules/logIn/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);
  TextEditingController emailLoginController = TextEditingController();
  TextEditingController passwordLoginController = TextEditingController();
  bool isPassword = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLogin = true;
  bool isLoading = false;

  void passwordChange() {
    isPassword = !isPassword;
    emit(ChangeState());
  }

  void loginChange() {
    isLogin = !isLogin;
    emit(ChangeState());
  }

  void userLogin({required BuildContext context}) {
    isLoading = true;
    emit(LoginLoadingState());
    FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: emailLoginController.text,
      password: passwordLoginController.text,
    )
        .then((value) async {
      FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .update({"open": true}).whenComplete(() async {
        FirebaseFirestore.instance
            .collection("users")
            .doc(value.user!.uid)
            .get()
            .then((value2) {
          userModel = UserModel.fromjson(value2.data()!);
          if (userModel!.admin) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AppScreen()),
            );
          } else {
            FirebaseAuth.instance.signOut();
            Fluttertoast.showToast(
              msg: "This email is not admin",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
        });
      });
      isLoading = false;
      emit(LoginSuccessState());
    }).catchError((error) {
      isLoading = false;
      emit(LoginErrorState());
    });
  }
}
