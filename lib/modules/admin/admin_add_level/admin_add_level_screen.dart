import 'package:englizy_app/modules/admin/admin_add_level/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_add_level/cubit/states.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddLevelScreen extends StatelessWidget {
  const AdminAddLevelScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminAddLevelCubit(),
      child: BlocConsumer<AdminAddLevelCubit, AdminAddLevelStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminAddLevelCubit cubit = AdminAddLevelCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Add Level"),
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
                                    cubit.addLevel(context: context);
                                  },
                                  color: Colors.indigoAccent,
                                  height: 50.0,
                                  child: const Text(
                                    'Add unit',
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
