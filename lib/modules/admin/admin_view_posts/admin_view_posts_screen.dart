import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_post/admin_add_post_screen.dart';
import 'package:englizy_app/modules/admin/admin_update_post/admin_update_post_screen.dart';
import 'package:englizy_app/modules/admin/admin_view_posts/cubit/cubit.dart';
import 'package:englizy_app/modules/admin/admin_view_posts/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminViewPostsScreen extends StatelessWidget {
  const AdminViewPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => AdminViewPostsCubit(),
      child: BlocConsumer<AdminViewPostsCubit, AdminViewPostsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AdminViewPostsCubit cubit = AdminViewPostsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              centerTitle: true,
              title: Text("Posts of Teacher", style: TextStyle(
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
                              builder: (context) => AdminAddPostScreen()));
                    },
                    icon: Icon(Icons.add))
              ],
            ),
            body: StreamBuilder<QuerySnapshot>(
              stream: cubit.getPostsOfTeacher(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.grey.shade400),
                                            child: const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Icon(
                                                Icons.person_outline,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text("Admin"),
                                                Text(DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            int.parse(data[index]
                                                                        ["time"]
                                                                    .seconds
                                                                    .toString()) *
                                                                1000)
                                                    .toString())
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      PopupMenuButton<int>(
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          icon: Icon(
                                            Icons.more_vert_outlined,
                                            color: Theme.of(context)
                                                .iconTheme
                                                .color,
                                          ),
                                          onSelected: (value) {
                                            if (value == 1) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AdminUpdatePostScreen(
                                                              data: data[
                                                                  index])));
                                            }
                                            if (value == 2) {
                                              cubit.deletePost(
                                                  id: data[index].id);
                                            }
                                          },
                                          itemBuilder: (context) => [
                                                PopupMenuItem(
                                                  value: 1,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.update,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Update post",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                PopupMenuItem(
                                                  value: 2,
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete_outline,
                                                      ),
                                                      const SizedBox(
                                                        width: 10,
                                                      ),
                                                      Text(
                                                        "Delete post",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ])
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  data[index]["text"] == ""
                                      ? const SizedBox()
                                      : Text(
                                          data[index]["text"],
                                          style: TextStyle(fontSize: 25),
                                        ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  data[index]["link"] == ""
                                      ? const SizedBox()
                                      : InkWell(
                                          onTap: () async {
                                            if (!await launchUrl(Uri.parse(
                                                "${data[index]["link"]}"))) {
                                              throw Exception(
                                                  'Could not launch ${data[index]["link"]}');
                                            }
                                          },
                                          child: Text(
                                            data[index]["link"],
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 25),
                                          )),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
