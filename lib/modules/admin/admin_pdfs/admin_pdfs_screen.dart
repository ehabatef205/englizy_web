import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_pdf/admin_add_pdf_screen.dart';
import 'package:englizy_app/modules/admin/admin_pdfs/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_pdfs/cubit/states.dart';
import 'package:englizy_app/modules/admin/admin_pdfs/view_pdf_link_admin.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:englizy_app/shared/view_pdf_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminPDFSScreen extends StatelessWidget {
  const AdminPDFSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminPDFSCubit(),
      child: BlocConsumer<AdminPDFSCubit, AdminPDFSStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminPDFSCubit cubit = AdminPDFSCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              centerTitle: true,
              title: Text("PDF", style: TextStyle(
                color: Theme
                    .of(context)
                    .textTheme
                    .bodyText1!
                    .color,
              ),),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminAddPDFScreen()));
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            body: Center(
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
                ),
                Expanded(
                  child: cubit.level == null
                      ? const SizedBox()
                      : StreamBuilder<QuerySnapshot>(
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
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ViewPdfLinkAdmin(
                                                  data: data[index],)));
                                    },
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
                                          unselectedWidgetColor:
                                              Theme.of(context).iconTheme.color),
                                      child: Checkbox(
                                        activeColor:
                                            Theme.of(context).iconTheme.color,
                                        checkColor: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        value: data[index]["view"],
                                        onChanged: (value) {
                                          FirebaseFirestore.instance
                                              .collection("pdfs")
                                              .doc(data[index].id)
                                              .update({"view": value});
                                        },
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
