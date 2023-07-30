import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_update_level/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_update_level/cubit/states.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUpdateLevelScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;

  const AdminUpdateLevelScreen({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) =>
          AdminUpdateLevelCubit()..changeText(text: data["name"]),
      child: BlocConsumer<AdminUpdateLevelCubit, AdminUpdateLevelStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminUpdateLevelCubit cubit = AdminUpdateLevelCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(data["name"], style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .color,
              ),),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Form(
                  key: cubit.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormFieldWidget(
                          controller: cubit.nameLevelController,
                          type: TextInputType.text,
                          context: context,
                          labelText: "Level",
                          validate: (value) {
                            if (value!.isEmpty) {
                              return "Level is required";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        cubit.isLoading
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : Container(
                                width: double.infinity,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                child: MaterialButton(
                                  onPressed: () {
                                    cubit.updateLevel(
                                        context: context, id: data.id);
                                  },
                                  color: Colors.indigoAccent,
                                  height: 50.0,
                                  child: const Text(
                                    'Update level',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
