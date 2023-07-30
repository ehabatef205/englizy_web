import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_unit/admin_add_unit_screen.dart';
import 'package:englizy_app/modules/admin/admin_home/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_home/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_view_parts/admin_view_parts_screen.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminHomeCubit(),
      child: BlocConsumer<AdminHomeCubit, AdminHomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminHomeCubit cubit = AdminHomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              centerTitle: true,
              title: Text(
                "Home",
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
                              builder: (context) => AdminAddUnitScreen()));
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            body: Center(
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
                            iconEnabledColor: Theme.of(context).iconTheme.color,
                            hint: const Text(
                              "Choose level",
                              style: TextStyle(color: Colors.grey),
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
                Expanded(
                  child: cubit.level == null
                      ? const SizedBox()
                      : StreamBuilder<QuerySnapshot>(
                          stream: cubit.getUnits(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!.docs;
                              return ListView.builder(
                                shrinkWrap: true,
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ListTile(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AdminViewPartsScreen(
                                                      dataOfUnit: data[index],
                                                    )));
                                      },
                                      leading: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(data[index]["image"]),
                                            fit: BoxFit.fill
                                          )
                                        ),
                                      ),
                                      title: Text(
                                        data[index]["name"],
                                        style: TextStyle(
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1!
                                                .color),
                                      ),
                                      trailing: Theme(
                                        data: ThemeData(
                                            unselectedWidgetColor: Theme.of(context).iconTheme.color
                                        ),
                                        child: Checkbox(
                                          activeColor: Theme.of(context).iconTheme.color,
                                          checkColor: Theme.of(context).scaffoldBackgroundColor,
                                          value: data[index]["view"],
                                          onChanged: (value) {
                                            FirebaseFirestore.instance
                                                .collection("units")
                                                .doc(data[index].id)
                                                .update({"view": value});
                                          },
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
          );
        },
      ),
    );
  }
}
