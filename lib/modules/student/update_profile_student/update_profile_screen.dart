import 'dart:io';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/update_profile_student/cubit/cubit.dart';
import 'package:englizy_app/modules/student/update_profile_student/cubit/states.dart';
import 'package:englizy_app/shared/color.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateProfileStudentScreen extends StatelessWidget {
  const UpdateProfileStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => UpdateProfileStudentCubit()..dataUser(),
      child:
          BlocConsumer<UpdateProfileStudentCubit, UpdateProfileStudentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          UpdateProfileStudentCubit cubit =
              UpdateProfileStudentCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Update Profile',
                style: TextStyle(
                  color: Color.fromRGBO(102, 144, 206, 1),
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              centerTitle: true,
            ),
            body: SafeArea(
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/englizy.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Center(
                        child: Form(
                          key: cubit.formKey,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  cubit.chooseImage();
                                },
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: cubit.image == null
                                        ? DecorationImage(
                                            image:
                                                NetworkImage(userModel!.image),
                                            fit: BoxFit.cover,
                                          )
                                        : DecorationImage(
                                            image: FileImage(
                                                File(cubit.image!.path)),
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                              Divider(
                                thickness: 1.0,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormFieldWidget(
                                controller: cubit.parentsPhoneNumberController,
                                type: TextInputType.phone,
                                context: context,
                                labelText: "Parent's phone number",
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Parent's phone number is required";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              TextFormFieldWidget(
                                controller: cubit.nameController,
                                type: TextInputType.name,
                                context: context,
                                labelText: "Name",
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Name is required";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              TextFormFieldWidget(
                                controller: cubit.phoneController,
                                type: TextInputType.text,
                                context: context,
                                labelText: "Phone",
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return "Phone is required";
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Container(
                                height: 66.0,
                                decoration: BoxDecoration(
                                  color: Colors.black38,
                                  border: Border.all(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Center(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: TextFormField(
                                            onEditingComplete: () {
                                              FocusScope.of(context)
                                                  .nextFocus();
                                            },
                                            keyboardType:
                                                TextInputType.datetime,
                                            enabled: false,
                                            controller: cubit.levelController,
                                            minLines: 1,
                                            cursorColor: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color,
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 18),
                                            decoration: InputDecoration(
                                              filled: true,
                                              hintText: "Level",
                                              hintStyle: TextStyle(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!
                                                      .withOpacity(0.5)),
                                              disabledBorder:
                                                  OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                              errorBorder: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                                borderSide: const BorderSide(
                                                  color: Colors.transparent,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("levels")
                                                .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var date = snapshot.data!.docs;
                                                return DropdownButtonHideUnderline(
                                                  child: DropdownButton(
                                                    dropdownColor: Theme.of(
                                                            context)
                                                        .scaffoldBackgroundColor,
                                                    iconEnabledColor:
                                                        Theme.of(context)
                                                            .iconTheme
                                                            .color,
                                                    items: date.map((item) {
                                                      return DropdownMenuItem(
                                                        onTap: () {
                                                          cubit.changeLevelId(
                                                              item.id);
                                                        },
                                                        value: item["name"],
                                                        child: Text(
                                                          item["name"],
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .color),
                                                        ),
                                                      );
                                                    }).toList(),
                                                    onChanged: (newValue) {
                                                      cubit.changeLevel(
                                                          newValue!.toString());
                                                    },
                                                  ),
                                                );
                                              } else {
                                                return Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: color2,
                                                  ),
                                                );
                                              }
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              cubit.isLoading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                        color: colorButton,
                                      ),
                                    )
                                  : Container(
                                      width: size.width * 0.7,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: MaterialButton(
                                        onPressed: () {
                                          if (cubit.formKey.currentState!
                                              .validate()) {
                                            cubit.formKey.currentState!.save();
                                            cubit.uploadImage(context);
                                          }
                                        },
                                        color: Colors.indigo,
                                        height: 50.0,
                                        child: const Text(
                                          'Update',
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
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
