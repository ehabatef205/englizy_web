import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_level/admin_add_level_screen.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_homework/admin_view_pdf_link_homework.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_homework/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_homework/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_update_level/admin_update_level_screen.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewStudentsInHomeworkScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> unit;

  const AdminViewStudentsInHomeworkScreen({required this.unit, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminViewStudentsInHomeworkCubit(),
      child: BlocConsumer<AdminViewStudentsInHomeworkCubit,
          AdminViewStudentsInHomeworkStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminViewStudentsInHomeworkCubit cubit =
              AdminViewStudentsInHomeworkCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Homework",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: StreamBuilder<QuerySnapshot>(
                stream: cubit.getHomework(unit.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var data = snapshot.data!.docs;
                    return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .doc(data[index].id)
                                  .snapshots(),
                              builder: (context, snapshot2) {
                                if (snapshot2.hasData) {
                                  var data2 = snapshot2.data!;
                                  return ListTile(
                                    onTap: () {
                                      /*Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminViewPdfLinkHomework(
                                                      link: data[index]["pdf"],
                                                      name: unit["name"],
                                                      grade: data[index]
                                                          ["grade"], userId: data[index].id, unitId: unit.id)));
                                    */},
                                    leading: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey,
                                        image: DecorationImage(
                                            image: NetworkImage(data2["image"]),
                                            fit: BoxFit.cover),
                                      ),
                                    ),
                                    title: Text(
                                      data2["studentName"],
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
          );
        },
      ),
    );
  }
}
