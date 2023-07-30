import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:englizy_app/layout/cubit/states.dart';
import 'package:englizy_app/modules/admin/settings_admin/settings_admin_screen.dart';
import 'package:englizy_app/modules/admin/admin_community/admin_community_screen.dart';
import 'package:englizy_app/modules/admin/admin_home/admin_home_screen.dart';
import 'package:englizy_app/modules/admin/admin_pdfs/admin_pdfs_screen.dart';
import 'package:englizy_app/modules/admin/admin_view_posts/admin_view_posts_screen.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  int bottomNavIndex = 2;

  List<Widget> widgetAdmin = <Widget>[
    AdminCommunityScreen(),
    AdminPDFSScreen(),
    AdminHomeScreen(),
    AdminViewPostsScreen(),
    SettingsAdminScreen()
  ];

  List<TabItem> icons() {
    return [
      const TabItem(
        icon: Icon(Icons.date_range_sharp),
        title: 'Questions',
      ),
      const TabItem(
        icon: Icon(Icons.ac_unit),
        title: 'PDF',
      ),
      const TabItem(
        icon: IconTheme(
          data: IconThemeData.fallback(),
          child: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/englizy.jpg',
            ),
          )
        ),
        title: 'HOME PAGE',
      ),
      const TabItem(
        icon: Icon(Icons.data_exploration),
        title: 'Posts',
      ),
      const TabItem(
        icon: Icon(Icons.settings),
        title: 'Settings',
      ),
    ];
  }

  void changeIndex(int newIndex) {
    bottomNavIndex = newIndex;
    emit(ChangeIndexState());
  }
}
