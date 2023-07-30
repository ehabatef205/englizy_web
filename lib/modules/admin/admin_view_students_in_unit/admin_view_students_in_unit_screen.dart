import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_level/admin_add_level_screen.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_unit/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_view_students_in_unit/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_update_level/admin_update_level_screen.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminViewStudentsInUnitScreen extends StatelessWidget {
  final String unitId;

  const AdminViewStudentsInUnitScreen({required this.unitId, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminViewStudentsInUnitCubit(),
      child: BlocConsumer<AdminViewStudentsInUnitCubit,
          AdminViewStudentsInUnitStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminViewStudentsInUnitCubit cubit =
              AdminViewStudentsInUnitCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Students",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
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
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      style: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1!.color),
                      cursorColor: Theme.of(context).textTheme.bodyText1!.color,
                      decoration: InputDecoration(
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color!,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: BorderSide(
                            color:
                                Theme.of(context).textTheme.bodyText1!.color!,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        hintText: "Search...",
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .color!
                              .withOpacity(0.5),
                        ),
                      ),
                      onChanged: (value) => cubit.onChanged(value),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: cubit.getStudents(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs;
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: data.length,
                              itemBuilder: (context, index) {
                                return cubit.uid!.isEmpty
                                    ? ListTile(
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data[index]["image"]),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        title: Text(
                                          data[index]["studentName"],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color),
                                        ),
                                        trailing:
                                            StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("units")
                                              .doc(unitId)
                                              .snapshots(),
                                          builder: (context, snapshot2) {
                                            if (snapshot2.hasData) {
                                              var data2 = snapshot2.data!;
                                              List<dynamic> list =
                                                  data2["students"];
                                              return Theme(
                                                data: ThemeData(
                                                    unselectedWidgetColor:
                                                        Theme.of(context)
                                                            .iconTheme
                                                            .color),
                                                child: Checkbox(
                                                  activeColor: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  checkColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  value: list
                                                      .contains(data[index].id),
                                                  onChanged: (value) {
                                                    if (list.contains(
                                                        data[index].id)) {
                                                      list.remove(
                                                          data[index].id);
                                                      FirebaseFirestore.instance
                                                          .collection("units")
                                                          .doc(unitId)
                                                          .update({
                                                        "students": list
                                                      });
                                                    } else {
                                                      list.add(data[index].id);
                                                      FirebaseFirestore.instance
                                                          .collection("units")
                                                          .doc(unitId)
                                                          .update({
                                                        "students": list,
                                                      });
                                                    }
                                                  },
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        ))
                                    : data[index]["email"]
                                    .toString()
                                    .toLowerCase()
                                    .startsWith(cubit.uid!
                                    .toLowerCase())? ListTile(
                                        leading: Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    data[index]["image"]),
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        title: Text(
                                          data[index]["studentName"],
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1!
                                                  .color),
                                        ),
                                        trailing:
                                            StreamBuilder<DocumentSnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection("units")
                                              .doc(unitId)
                                              .snapshots(),
                                          builder: (context, snapshot2) {
                                            if (snapshot2.hasData) {
                                              var data2 = snapshot2.data!;
                                              List<dynamic> list =
                                                  data2["students"];
                                              return Theme(
                                                data: ThemeData(
                                                    unselectedWidgetColor:
                                                        Theme.of(context)
                                                            .iconTheme
                                                            .color),
                                                child: Checkbox(
                                                  activeColor: Theme.of(context)
                                                      .iconTheme
                                                      .color,
                                                  checkColor: Theme.of(context)
                                                      .scaffoldBackgroundColor,
                                                  value: list
                                                      .contains(data[index].id),
                                                  onChanged: (value) {
                                                    if (list.contains(
                                                        data[index].id)) {
                                                      list.remove(
                                                          data[index].id);
                                                      FirebaseFirestore.instance
                                                          .collection("units")
                                                          .doc(unitId)
                                                          .update({
                                                        "students": list
                                                      });
                                                    } else {
                                                      list.add(data[index].id);
                                                      FirebaseFirestore.instance
                                                          .collection("units")
                                                          .doc(unitId)
                                                          .update({
                                                        "students": list,
                                                      });
                                                    }
                                                  },
                                                ),
                                              );
                                            } else {
                                              return const SizedBox();
                                            }
                                          },
                                        )) : SizedBox();
                              });
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
