import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/posts_of_admin/cubit/cubit.dart';
import 'package:englizy_app/modules/student/posts_of_admin/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PostsOfAdminScreen extends StatelessWidget {
  const PostsOfAdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => PostsOfAdminCubit(),
      child: BlocConsumer<PostsOfAdminCubit, PostsOfAdminStates>(
        listener: (context, state) {},
        builder: (context, state) {
          PostsOfAdminCubit cubit = PostsOfAdminCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: const SizedBox(),
              centerTitle: true,
              title: Text(
                'Posts of Teacher',
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
                color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.4),
                child: StreamBuilder<QuerySnapshot>(
                  stream: cubit.getPostsOfTeacher(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data!.docs;
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Card(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              elevation: 5.0,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const CircleAvatar(
                                          radius: 25.0,
                                          backgroundImage: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/englizy-46f94.appspot.com/o/users%2F360_F_346936114_RaxE6OQogebgAWTalE1myseY1Hbb5qPM.jpg?alt=media&token=6402503a-2de0-41a0-a4a1-7a705ab9f11d',
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15.0,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'Admin',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .color,
                                                    height: 1.4,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5.0,
                                                ),
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color,
                                                  size: 16.0,
                                                ),
                                              ],
                                            ),
                                            Text(
                                                DateTime.fromMillisecondsSinceEpoch(
                                                        int.parse(data[index]
                                                                    ["time"]
                                                                .seconds
                                                                .toString()) *
                                                            1000)
                                                    .toString())
                                          ],
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15.0,
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 1.0,
                                        color: Colors.grey[300],
                                      ),
                                    ),
                                    data[index]["text"] == ""
                                        ? const SizedBox()
                                        : Text(
                                            data[index]["text"],
                                            style: TextStyle(
                                                fontSize: 25,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color),
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
                                              style: const TextStyle(
                                                  color: Colors.blue, fontSize: 25),
                                            ),
                                          ),
                                  ],
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
              ),
            ),
          );
        },
      ),
    );
  }
}
