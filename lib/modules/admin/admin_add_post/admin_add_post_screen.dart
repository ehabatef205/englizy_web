import 'package:englizy_app/modules/admin/admin_add_post/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_add_post/cubit/states.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddPostScreen extends StatelessWidget {
  const AdminAddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return BlocProvider(
      create: (BuildContext context) => AdminAddPostCubit(),
      child: BlocConsumer<AdminAddPostCubit, AdminAddPostStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminAddPostCubit cubit = AdminAddPostCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Add post", style: TextStyle(
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
                          controller: cubit.textController,
                          type: TextInputType.text,
                          context: context,
                          labelText: "Text",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormFieldWidget(
                          controller: cubit.linkController,
                          type: TextInputType.url,
                          context: context,
                          labelText: "Link",
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
                              cubit.addPost(context: context);
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
