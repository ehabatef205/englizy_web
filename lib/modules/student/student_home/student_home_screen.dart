import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/demo_unit/demo_unit_screen.dart';
import 'package:englizy_app/modules/student/parts/parts_screen.dart';
import 'package:englizy_app/modules/student/student_home/cubit/cubit.dart';
import 'package:englizy_app/modules/student/student_home/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => StudentHomeCubit(),
      child: BlocConsumer<StudentHomeCubit, StudentHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          StudentHomeCubit cubit = StudentHomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              centerTitle: true,
              leading: const SizedBox(),
              title: Text(
                'Units',
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
                    StreamBuilder<QuerySnapshot>(
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
                                  levelText?? "choose Level",
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
                                            .color,
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w700,
                                      ),
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
                    FirebaseAuth.instance.currentUser == null
                        ? Center(child: SizedBox())
                        : Expanded(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: cubit.getUnits(),
                              builder: (context, snapshot2) {
                                if (snapshot2.hasData) {
                                  var data = snapshot2.data!.docs;
                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.8,
                                    ),
                                    shrinkWrap: true,
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: const EdgeInsets.all(5),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!,
                                                  width: 1)),
                                          child: InkWell(
                                            onTap: () {
                                              if (data[index]['students']
                                                  .contains(userModel!.uid)) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PartsScreen(
                                                              dataOfUnit:
                                                                  data[index],
                                                            )));
                                              } else {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            DemoUnitScreen(
                                                              unit: data[index],
                                                            )));
                                              }
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .only(
                                                        topLeft:
                                                            Radius.circular(5),
                                                        topRight:
                                                            Radius.circular(5),
                                                        bottomRight:
                                                            Radius.circular(5),
                                                        bottomLeft:
                                                            Radius.circular(5),
                                                      ),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                          data[index]["image"],
                                                        ),
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Center(
                                                  child: Text(
                                                    data[index]["name"],
                                                    style: TextStyle(
                                                      color: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodyText1!
                                                          .color,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                  /*TextLiquidFill(
                                                              text: data[index]["name"],
                                                              waveColor: Colors.blueAccent,
                                                              boxBackgroundColor: Colors.redAccent,
                                                              textStyle: TextStyle(
                                                                fontSize: 18.0,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                              boxHeight: 30.0,
                                                            ),*/
                                                  /*Text(
                                                              data[index]["name"],
                                                              style: TextStyle(
                                                                color: Theme
                                                                    .of(context)
                                                                    .textTheme
                                                                    .bodyText1!
                                                                    .color,
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                              maxLines: 1,
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                            ),*/
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                              ],
                                            ),
                                          ),
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
