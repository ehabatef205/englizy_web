import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:englizy_app/layout/cubit/cubit.dart';
import 'package:englizy_app/layout/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppScreen extends StatelessWidget {
  const AppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return Future.value(true);
          },
          child: Scaffold(
            bottomNavigationBar: ConvexAppBar(
              backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              style: TabStyle.fixedCircle,
              height: size.height * 0.07,
              initialActiveIndex: cubit.bottomNavIndex,
              activeColor: Colors.blueAccent,
              color: Theme.of(context).textTheme.bodyText1!.color,
              items: cubit.icons(),
              onTap: (index){
                cubit.changeIndex(index);
              },
            ),
            body: cubit.widgetAdmin[cubit.bottomNavIndex],
          ),
        );
      },
    );
  }
}
