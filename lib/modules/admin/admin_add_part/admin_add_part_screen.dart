import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_part/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_add_part/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_add_part/video_screen.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class AdminAddPartScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;

  const AdminAddPartScreen({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminAddPartCubit(),
      child: BlocConsumer<AdminAddPartCubit, AdminAddPartStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminAddPartCubit cubit = AdminAddPartCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text("Add part", style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .color,
              ),),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: cubit.result != null
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: cubit.result!.files.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                    cubit.result!.files[index].name,
                                    style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                                    ));
                                  })
                              : const SizedBox()),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: cubit.result == null
                            ? cubit.chooseVideo
                            : cubit.chooseVideo2,
                        child: SizedBox(
                          width: size.width * 0.8,
                          height: size.height * 0.1,
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 70,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        controller: cubit.namePartController,
                        type: TextInputType.text,
                        context: context,
                        labelText: "Name of part",
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Name of part is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        controller: cubit.descriptionUnitController,
                        type: TextInputType.text,
                        context: context,
                        labelText: "Description",
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Description is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        controller: cubit.numberOfQuestionsController,
                        type: TextInputType.number,
                        context: context,
                        labelText: "Number of questions",
                        suffixIcon: IconButton(
                            onPressed: () {
                              cubit.chooseNumberOfQuestions();
                            },
                            icon: Icon(Icons.send, color: Theme.of(context).iconTheme.color,)),
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Number of questions";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cubit.numberOfQuestions,
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                TextFormFieldWidgetExam(
                                  type: TextInputType.text,
                                  context: context,
                                  labelText: "Questions ${index + 1}",
                                  onChanged: (value) {
                                    cubit.changeQuestion(value!, index);
                                  },
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return "Questions ${index + 1}";
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: TextFormFieldWidgetExam(
                                        type: TextInputType.text,
                                        context: context,
                                        labelText: "Answer 1",
                                        onChanged: (value) {
                                          cubit.changeAnswer1(value!, index);
                                        },
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return "Answer 1";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: TextFormFieldWidgetExam(
                                        type: TextInputType.text,
                                        context: context,
                                        labelText: "Answer 2",
                                        onChanged: (value) {
                                          cubit.changeAnswer2(value!, index);
                                        },
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return "Answer 2";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: TextFormFieldWidgetExam(
                                        type: TextInputType.text,
                                        context: context,
                                        labelText: "Answer 3",
                                        onChanged: (value) {
                                          cubit.changeAnswer3(value!, index);
                                        },
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return "Answer 3";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Flexible(
                                      child: TextFormFieldWidgetExam(
                                        type: TextInputType.text,
                                        context: context,
                                        labelText: "Answer 4",
                                        onChanged: (value) {
                                          cubit.changeAnswer4(value!, index);
                                        },
                                        validate: (value) {
                                          if (value!.isEmpty) {
                                            return "Answer 4";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: size.width * 0.5,
                                  child: TextFormFieldWidgetExam(
                                    type: TextInputType.text,
                                    context: context,
                                    labelText: "Correct Answer",
                                    onChanged: (value) {
                                      cubit.changeCorrect(value!, index);
                                    },
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "Correct Answer";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            );
                          }),
                      cubit.isLoading
                          ? const Center(
                        child: CircularProgressIndicator(),
                      ) :
                      Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            cubit.uploadVideos(context, data["name"], data.id);
                          },
                          color: Colors.indigoAccent,
                          height: 50.0,
                          child: const Text(
                            'Add part',
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
          );
        },
      ),
    );
  }
}
