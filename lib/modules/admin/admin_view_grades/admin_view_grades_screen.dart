import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_view_grades/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_view_grades/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_update_level/admin_update_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewGradesScreen extends StatelessWidget {
  final String unitId;
  final String partId;

  const AdminViewGradesScreen(
      {required this.unitId, required this.partId, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminViewGradesCubit(),
      child: BlocConsumer<AdminViewGradesCubit, AdminViewGradesStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminViewGradesCubit cubit = AdminViewGradesCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Grades",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  StreamBuilder<DocumentSnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("units")
                          .doc(unitId)
                          .collection("parts")
                          .doc(partId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!;
                          return Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "View grades",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color),
                                ),
                                Theme(
                                  data: ThemeData(
                                      unselectedWidgetColor:
                                          Theme.of(context).iconTheme.color),
                                  child: Checkbox(
                                    activeColor:
                                        Theme.of(context).iconTheme.color,
                                    checkColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    value: data["viewGrade"],
                                    onChanged: (value) {
                                      FirebaseFirestore.instance
                                          .collection("units")
                                          .doc(unitId)
                                          .collection("parts")
                                          .doc(partId)
                                          .update({"viewGrade": value});
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("units")
                          .doc(unitId)
                          .collection("parts")
                          .doc(partId)
                          .collection("answers")
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("users")
                                        .doc(data[index].id)
                                        .snapshots(),
                                    builder: (context, snapshot2) {
                                      if (snapshot2.hasData) {
                                        var dataOfUser = snapshot2.data!;
                                        return ListTile(
                                          leading: Container(
                                            height: 50,
                                            width: 50,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      dataOfUser["image"]),
                                                  fit: BoxFit.fill),
                                            ),
                                          ),
                                          title: Text(
                                            dataOfUser["studentName"],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                          trailing: Text(
                                            data[index]["grade"],
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
                                          ),
                                        );
                                      } else {
                                        return const SizedBox();
                                      }
                                    });
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
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
