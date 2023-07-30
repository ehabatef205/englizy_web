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
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection("users")
          .doc(value.user!.uid)
          .get();
      if (!doc.get("open") || doc.get("open")) {
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
            AppCubit.get(context).changeLevelText().whenComplete(() async{
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AppScreen()),
              );
            });
          });
        });
      } else {
        Fluttertoast.showToast(
          msg: "This email opened in anther phone",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        FirebaseAuth.instance.signOut();
      }

      emit(LoginSuccessState());
    }).catchError((error) {
      isLoading = false;
      emit(LoginErrorState());
    });
  }

  // Registration

  TextEditingController quadrupleNameController = TextEditingController();
  TextEditingController parentsPhoneNumberController = TextEditingController();
  TextEditingController studentPhoneNumberController = TextEditingController();
  TextEditingController passwordController2 = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  bool isPassword2 = true;
  bool isConfirmPassword = true;
  String dropdownValue = 'academic year';
  String? text1;
  String? text2;
  String dropdownValue2 = 'Center';

  //GlobalKey<FormState> formKey2 = GlobalKey<FormState>();

  List<String> academicYearList = [
    'First year of high school',
    'Second year of high school',
    'Third year of high school',
  ];
  String? levelId;

  void changeLevelId(String? id) {
    levelId = id;
    emit(ChangeState());
  }

  void changeLevel(String? level) {
    levelController.text = level!;
    emit(ChangeState());
  }

  void changeItem(newValue) {
    dropdownValue = newValue;
    text1 = dropdownValue;
    emit(RegisterChangeState());
  }

  void passwordChange2() {
    isPassword2 = !isPassword2;
    emit(RegisterChangeState());
  }

  void confirmPasswordChange() {
    isConfirmPassword = !isConfirmPassword;
    emit(RegisterChangeState());
  }

  void userRegister({required BuildContext context}) {
    emit(RegisterLoadingState());
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController2.text,
    )
        .then((value) {
      userCreate(
        context: context,
        uid: value.user!.uid,
        email: emailController.text,
        parentPhone: parentsPhoneNumberController.text,
        studentName: quadrupleNameController.text,
        studentPhone: studentPhoneNumberController.text,
      );
      emit(RegisterSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState());
    });
  }

  void userCreate({
    required BuildContext context,
    required studentName,
    required parentPhone,
    required studentPhone,
    required email,
    required uid,
  }) async{
    UserModel model = UserModel(
        level: levelId!,
        uid: uid,
        email: email,
        studentName: studentName,
        parentPhone: parentPhone,
        studentPhone: studentPhone,
        open: true,
        admin: false,
        image:
            "https://firebasestorage.googleapis.com/v0/b/englizy-46f94.appspot.com/o/users%2F360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg?alt=media&token=6402503a-2de0-41a0-a4a1-7a705ab9f11d");
    emit(CreateUserSuccessState());
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .set(model.toMap())
        .then((value) async{
      AppCubit.get(context).changeLevelText().whenComplete(() async{
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AppScreen()));
      });
    }).catchError((error) {
      emit(CreateUserErrorState());
    });
  }
}
