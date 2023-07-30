import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/layout/cubit/cubit.dart';
import 'package:englizy_app/modules/logIn/logIn_screen.dart';
import 'package:englizy_app/modules/student/settings_student/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:englizy_app/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class SettingsStudentCubit extends Cubit<SettingsStudentStates> {
  SettingsStudentCubit() : super(InitialSettingsStudentState());

  static SettingsStudentCubit get(context) => BlocProvider.of(context);

  bool isDark = false;
  bool isDone = false;

  void readDark(BuildContext context) {
    final themeProvider = Provider.of<ThemeNotifier>(context);
    themeProvider.readData().then((value) {
      isDark = value;
      isDone = true;
      emit(ChangeModeState());
    });
  }

  void changeMode(ThemeNotifier theme, BuildContext context){
    theme.readData().then((value) {
      if (value) {
        theme.setLightMode();
      } else {
        theme.setDarkMode();
      }
      isDone = false;
      emit(ChangeModeState());
    });
  }

  void signOut({required BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreen()),
    );
    FirebaseFirestore.instance
        .collection("users")
        .doc(userModel!.uid)
        .update({
      "open": false,
    }).whenComplete(() async{
      await FirebaseAuth.instance.signOut().whenComplete(() async{
        AppCubit.get(context).bottomNavIndex = 2;
        userModel = null;
        emit(LogoutState());
      });
    });
  }
}
