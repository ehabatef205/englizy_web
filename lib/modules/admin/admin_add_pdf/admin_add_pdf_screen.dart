import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_pdf/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_add_pdf/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_add_pdf/view_pdf.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddPDFScreen extends StatelessWidget {
  const AdminAddPDFScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminAddPDFCubit(),
      child: BlocConsumer<AdminAddPDFCubit, AdminAddPDFStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminAddPDFCubit cubit = AdminAddPDFCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Add pdf",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: cubit.formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      cubit.pdf != null
                          ? ListTile(
                              onTap: () {
                                if (!cubit.isLoading) {
                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ViewPdf(
                                                path: cubit.pdf!.files[0].path!,
                                              )));*/
                                }
                              },
                              title: Text(
                                cubit.pdf!.files[0].name,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                              ),
                            )
                          : SizedBox(),
                      InkWell(
                        onTap: () {
                          if (!cubit.isLoading) {
                            cubit.choosePdf();
                          }
                        },
                        child: SizedBox(
                          child: Icon(
                            cubit.pdf == null
                                ? Icons.add_box_rounded
                                : Icons.change_circle_outlined,
                            color: Theme.of(context).iconTheme.color,
                            size: 50,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 66.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    onEditingComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    keyboardType: TextInputType.datetime,
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
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
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
                                            dropdownColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            iconEnabledColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            items: date.map((item) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  cubit.changeLevelId(item.id);
                                                },
                                                value: item["name"],
                                                child: Text(
                                                  item["name"],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
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
                                          child: CircularProgressIndicator(
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
                        height: 20,
                      ),
                      Container(
                        height: 66.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    onEditingComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    keyboardType: TextInputType.datetime,
                                    enabled: false,
                                    controller: cubit.unitController,
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
                                      hintText: "Unit",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color!
                                              .withOpacity(0.5)),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("units")
                                        .where("level",
                                            isEqualTo: cubit.levelId)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var date = snapshot.data!.docs;
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            dropdownColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            iconEnabledColor: Theme.of(context)
                                                .iconTheme
                                                .color,
                                            items: date.map((item) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  cubit.changeUnitId(item.id);
                                                },
                                                value: item["name"],
                                                child: Text(
                                                  item["name"],
                                                  style: TextStyle(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color),
                                                ),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              cubit.changeUnit(
                                                  newValue!.toString());
                                            },
                                          ),
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(
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
                        height: 20,
                      ),
                      TextFormFieldWidget(
                        controller: cubit.namePdfController,
                        type: TextInputType.text,
                        context: context,
                        labelText: "Name pdf",
                        validate: (value) {
                          if (value!.isEmpty) {
                            return "Name pdf is required";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      cubit.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: color2,
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  cubit.uploadPdf(context: context);
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
          );
        },
      ),
    );
  }
}
