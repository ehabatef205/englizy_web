import 'package:englizy_app/modules/admin/settings_admin/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/settings_admin/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_level/admin_level_screen.dart';
import 'package:englizy_app/modules/admin/admin_view_students/admin_view_students_screen.dart';
import 'package:englizy_app/modules/logIn/logIn_screen.dart';
import 'package:englizy_app/shared/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SettingsAdminScreen extends StatelessWidget {
  const SettingsAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SettingsAdminCubit(),
      child: BlocConsumer<SettingsAdminCubit, SettingsAdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          SettingsAdminCubit cubit = SettingsAdminCubit.get(context);
          if (!cubit.isDone) {
            cubit.readDark(context);
          }
          return Scaffold(
            body: SafeArea(
              child: ListView(
                children: [
                  ListTile(
                    title: Text(
                      "Dark Mode",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    trailing:
                        Consumer<ThemeNotifier>(builder: (context, theme, _) {
                      return CupertinoSwitch(
                        value: cubit.isDark,
                        onChanged: (value) {
                          cubit.changeMode(theme, context);
                        },
                      );
                    }),
                    leading: Icon(
                      Icons.dark_mode,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.person_outline,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      'Students',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminViewStudentsScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.layers_outlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      'Levels',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminLevelScreen()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.logout_outlined,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    onTap: () {
                      cubit.signOut(context: context);
                      FirebaseAuth.instance.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
