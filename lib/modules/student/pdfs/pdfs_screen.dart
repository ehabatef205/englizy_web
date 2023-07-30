import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/demo_unit/demo_unit_screen.dart';
import 'package:englizy_app/modules/student/pdfs/cubit/cubit.dart';
import 'package:englizy_app/modules/student/pdfs/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:englizy_app/shared/view_pdf_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PDFSScreen extends StatelessWidget {
  const PDFSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => PDFSCubit(),
      child: BlocConsumer<PDFSCubit, PDFSStates>(
        listener: (context, state) {},
        builder: (context, state) {
          PDFSCubit cubit = PDFSCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const SizedBox(),
              title: Text(
                'PDF',
                style: TextStyle(
                  color: Color.fromRGBO(102, 144, 206, 1),
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            body: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/englizy.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                color:
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.35),
                child: Center(
                    child: Column(
                  children: [
                    Center(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("levels")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var date = snapshot.data!.docs;
                              return DropdownButtonHideUnderline(
                                child: DropdownButton(
                                  dropdownColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  iconEnabledColor:
                                      Theme.of(context).iconTheme.color,
                                  hint: Text(
                                    levelText!,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
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
                                  value: cubit.level,
                                  onChanged: (newValue) {
                                    cubit.changeLevel(newValue!.toString());
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
                          }),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: cubit.getPdfs(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          return ListView.builder(
                            shrinkWrap: true,
                            itemCount: data.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  FirebaseFirestore.instance
                                      .collection("units")
                                      .doc(data[index]["unit"])
                                      .get()
                                      .then((value) {
                                    if (value["students"]
                                        .contains(userModel!.uid)) {
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewPdfLink(
                                                  link: data[index]["pdf"],
                                                  name: data[index]["name"])));*/
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please buy ${value["name"]}",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.BOTTOM,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 16.0,
                                      );
                                    }
                                  });
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
                            },
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                )),
              ),
            ),
          );
        },
      ),
    );
  }
}
