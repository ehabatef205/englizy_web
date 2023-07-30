import 'package:bloc/bloc.dart';
import 'package:englizy_app/layout/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/settings_admin/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:englizy_app/shared/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';


class SettingsAdminCubit extends Cubit<SettingsAdminStates> {
  SettingsAdminCubit() : super(InitialSettingsAdminState());

  static SettingsAdminCubit get(context) => BlocProvider.of(context);

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
    AppCubit.get(context).bottomNavIndex = 2;
    userModel = null;
    emit(LogoutState());
  }
}
