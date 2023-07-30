import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/view_student/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/view_student/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewStudentScreen extends StatelessWidget {
  final QueryDocumentSnapshot<Object?> data;
  const ViewStudentScreen({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ViewStudentCubit(),
      child: BlocConsumer<ViewStudentCubit, ViewStudentStates>(
        listener: (context, state) {},
        builder: (context, state) {
          ViewStudentCubit cubit = ViewStudentCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "Student Profile",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).textTheme.bodyText1!.color,
                ),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        height: size.height * 0.18,
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(data["image"]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Name : ${data["studentName"]}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color:
                            Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance.collection("levels").doc(data["level"]).snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              var dataOfLevel = snapshot.data!;
                              return Text(
                                'Level : ${dataOfLevel["name"]}',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color),
                              );
                            }else{
                              return SizedBox();
                            }
                          }
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email : ${data["email"]}',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color:
                            Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async{
                            await launch("tel:${data["studentPhone"]}");
                          },
                          child: Text(
                            'Student Phone : ${data["studentPhone"]}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color:
                              Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async{
                            await launch("tel:${data["parentPhone"]}");
                          },
                          child: Text(
                            'Parent Phone : ${data["parentPhone"]}',
                            style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color:
                              Theme.of(context).textTheme.bodyText1!.color,
                            ),
                          ),
                        ),
                      ],
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
