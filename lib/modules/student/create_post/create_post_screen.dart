import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/create_post/cubit/cubit.dart';
import 'package:englizy_app/modules/student/create_post/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePostsScreen extends StatelessWidget {
  const CreatePostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CreatePostsCubit(),
      child: BlocConsumer<CreatePostsCubit, CreatePostsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          CreatePostsCubit cubit = CreatePostsCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Create Post',
                style: TextStyle(
                  color: Color.fromRGBO(102, 144, 206, 1),
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    cubit.createPost(context: context);
                  },
                  child: Text(
                    "Post",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1!.color,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
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
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Container(
                        height: 66.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .color!),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(
                            child: Row(
                              children: [
                                Flexible(
                                  child: TextFormField(
                                    onEditingComplete: () {
                                      FocusScope.of(context).nextFocus();
                                    },
                                    keyboardType: TextInputType.datetime,
                                    enabled: false,
                                    controller: cubit.levelController,
                                    minLines: 1,
                                    cursorColor: Theme.of(context)
                                        .textTheme
                                        .bodyText1!
                                        .color,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color,
                                        fontSize: 18),
                                    decoration: InputDecoration(
                                      filled: true,
                                      hintText: "Level",
                                      hintStyle: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .color!
                                              .withOpacity(0.5)),
                                      disabledBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("levels")
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        var date = snapshot.data!.docs;
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton(
                                            dropdownColor: Theme.of(context)
                                                .scaffoldBackgroundColor,
                                            iconEnabledColor:
                                            Theme.of(context)
                                                .iconTheme
                                                .color,
                                            items: date.map((item) {
                                              return DropdownMenuItem(
                                                onTap: () {
                                                  cubit
                                                      .changeLevelId(item.id);
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
                                            onChanged: (newValue) {
                                              cubit.changeLevel(
                                                  newValue!.toString());
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
                                    })
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 25.0,
                            backgroundImage: NetworkImage(
                              userModel!.image
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: Text(
                              userModel!.studentName,
                              style: TextStyle(
                                height: 1.4,
                                color: Theme.of(context).textTheme.bodyText1!.color,
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TextFormField(
                          maxLines: 15,
                          controller: cubit.textController,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              color: Theme.of(context).textTheme.bodyText1!.color,
                            ),
                            hintText: 'what is on your mind ...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
