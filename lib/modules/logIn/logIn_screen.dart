import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/logIn/cubit/cubit.dart';
import 'package:englizy_app/modules/logIn/cubit/states.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          LoginCubit cubit = LoginCubit.get(context);
          return WillPopScope(
            onWillPop: () async {
              SystemNavigator.pop();
              return Future.value(true);
            },
            child: Scaffold(
              body: Container(
                constraints: const BoxConstraints.expand(),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/englizy.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.7),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                    child: SafeArea(
                      child: Center(
                        child: SingleChildScrollView(
                          child: Form(
                            key: cubit.formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                cubit.isLogin
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Login",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormFieldWidget(
                                            controller:
                                                cubit.emailLoginController,
                                            type: TextInputType.emailAddress,
                                            context: context,
                                            labelText: "Email",
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "Email is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20.0,
                                          ),
                                          TextFormFieldWidget(
                                            controller:
                                                cubit.passwordLoginController,
                                            type: TextInputType.visiblePassword,
                                            context: context,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                cubit.isPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              onPressed: () {
                                                cubit.passwordChange();
                                              },
                                              color: Colors.black,
                                            ),
                                            labelText: "Password",
                                            obscureText: cubit.isPassword,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "password is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () {},
                                                child: Text(
                                                  "Forgot your password?",
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyText1!
                                                        .color,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 30.0,
                                          ),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              "Registration",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color,
                                                fontSize: 28.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          TextFormFieldWidget(
                                            controller:
                                                cubit.quadrupleNameController,
                                            type: TextInputType.name,
                                            context: context,
                                            labelText: "Name",
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "Name is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Container(
                                            height: 66.0,
                                            decoration: BoxDecoration(
                                              color: Colors.black26,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1!
                                                      .color!),
                                              borderRadius:
                                                  BorderRadius.circular(25),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Flexible(
                                                      child: TextFormField(
                                                        onEditingComplete: () {
                                                          FocusScope.of(context)
                                                              .nextFocus();
                                                        },
                                                        keyboardType:
                                                            TextInputType
                                                                .datetime,
                                                        enabled: false,
                                                        controller: cubit
                                                            .levelController,
                                                        minLines: 1,
                                                        cursorColor:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color,
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyText1!
                                                                .color,
                                                            fontSize: 18),
                                                        decoration:
                                                            InputDecoration(
                                                          filled: true,
                                                          hintText: "Level",
                                                          hintStyle: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyText1!
                                                                  .color!
                                                                  .withOpacity(
                                                                      0.5)),
                                                          disabledBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                          ),
                                                          errorBorder:
                                                              OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            borderSide:
                                                                const BorderSide(
                                                              color: Colors
                                                                  .transparent,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    StreamBuilder<
                                                            QuerySnapshot>(
                                                        stream:
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "levels")
                                                                .snapshots(),
                                                        builder: (context,
                                                            snapshot) {
                                                          if (snapshot
                                                              .hasData) {
                                                            var date = snapshot
                                                                .data!.docs;
                                                            return DropdownButtonHideUnderline(
                                                              child:
                                                                  DropdownButton(
                                                                dropdownColor: Theme.of(
                                                                        context)
                                                                    .scaffoldBackgroundColor,
                                                                iconEnabledColor:
                                                                    Theme.of(
                                                                            context)
                                                                        .iconTheme
                                                                        .color,
                                                                items: date.map(
                                                                    (item) {
                                                                  return DropdownMenuItem(
                                                                    onTap: () {
                                                                      cubit.changeLevelId(
                                                                          item.id);
                                                                    },
                                                                    value: item[
                                                                        "name"],
                                                                    child: Text(
                                                                      item[
                                                                          "name"],
                                                                      style: TextStyle(
                                                                          color: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1!
                                                                              .color),
                                                                    ),
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (newValue) {
                                                                  cubit.changeLevel(
                                                                      newValue!
                                                                          .toString());
                                                                },
                                                              ),
                                                            );
                                                          } else {
                                                            return Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: color2,
                                                              ),
                                                            );
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormFieldWidget(
                                            controller: cubit
                                                .parentsPhoneNumberController,
                                            type: TextInputType.phone,
                                            context: context,
                                            labelText: "Parent's phone number",
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "Parent's phone number is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormFieldWidget(
                                            controller: cubit
                                                .studentPhoneNumberController,
                                            type: TextInputType.phone,
                                            context: context,
                                            labelText: "Student Phone Number",
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "Student Phone Number is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormFieldWidget(
                                            controller:
                                                cubit.passwordController2,
                                            type: TextInputType.visiblePassword,
                                            context: context,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                cubit.isPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              onPressed: () {
                                                cubit.passwordChange();
                                              },
                                              color: Colors.black,
                                            ),
                                            labelText: "Password",
                                            obscureText: cubit.isPassword,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "password is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          TextFormFieldWidget(
                                            controller:
                                                cubit.confirmPasswordController,
                                            type: TextInputType.visiblePassword,
                                            context: context,
                                            suffixIcon: IconButton(
                                              icon: Icon(
                                                cubit.isConfirmPassword
                                                    ? Icons.visibility
                                                    : Icons.visibility_off,
                                                color: Theme.of(context)
                                                    .iconTheme
                                                    .color,
                                              ),
                                              onPressed: () {
                                                cubit.confirmPasswordChange();
                                              },
                                              color: Colors.black,
                                            ),
                                            labelText: "Confirm Password",
                                            obscureText: cubit.isPassword,
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "Confirm Password is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Text(
                                              "The email used to reset the password",
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1!
                                                    .color!,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          TextFormFieldWidget(
                                            controller: cubit.emailController,
                                            type: TextInputType.emailAddress,
                                            context: context,
                                            labelText: "Email",
                                            validate: (value) {
                                              if (value!.isEmpty) {
                                                return "Email is required";
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                        ],
                                      ),
                                //LogIn
                                cubit.isLoading
                                    ? Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : Container(
                                        width: double.infinity,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
                                        ),
                                        child: MaterialButton(
                                          onPressed: () {
                                            if (cubit.isLogin) {
                                              if (cubit.formKey.currentState!
                                                  .validate()) {
                                                cubit.formKey.currentState!
                                                    .save();
                                                cubit.userLogin(
                                                    context: context);
                                              }
                                            } else {
                                              if (cubit.formKey.currentState!
                                                  .validate()) {
                                                cubit.formKey.currentState!
                                                    .save();
                                                cubit.userRegister(
                                                    context: context);
                                              }
                                            }
                                          },
                                          color: cubit.isLogin
                                              ? Color.fromRGBO(74, 93, 170, 1)
                                              : Color.fromRGBO(0, 168, 132, 1),
                                          height: 50.0,
                                          child: Text(
                                            cubit.isLogin
                                                ? 'Login'
                                                : 'Register',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Center(
                                  child: Text(
                                    "OR",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color!,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: double.infinity,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      /*Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => RegisterScreen()),
                                      );*/
                                      cubit.loginChange();
                                    },
                                    color: cubit.isLogin
                                        ? Color.fromRGBO(0, 168, 132, 1)
                                        : Color.fromRGBO(74, 93, 170, 1),
                                    height: 50.0,
                                    child: Text(
                                      cubit.isLogin ? 'Register' : 'Login',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
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

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(size.width * 0.3, size.height, size.width / 2, size.height,
        size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ClippingClass2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 2);
    path.cubicTo(size.width * 0.1, size.height, size.width * 0.9,
        size.height * 0.5, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class ClippingClass3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.51);
    path.cubicTo(size.width * 0.1, size.height, size.width * 0.9,
        size.height * 0.5, size.width, size.height * 0.7);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
