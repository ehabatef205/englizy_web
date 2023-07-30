import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_level/admin_add_level_screen.dart';
import 'package:englizy_app/modules/admin/admin_level/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_level/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_update_level/admin_update_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminLevelScreen extends StatelessWidget {
  const AdminLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminLevelCubit(),
      child: BlocConsumer<AdminLevelCubit, AdminLevelStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminLevelCubit cubit = AdminLevelCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Levels", style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .color,
              ),),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminAddLevelScreen()));
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: cubit.getLevels(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AdminUpdateLevelScreen(
                                          data: data[index],
                                        )));
                          },
                          title: Text(
                            data[index]["name"],
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .color),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
