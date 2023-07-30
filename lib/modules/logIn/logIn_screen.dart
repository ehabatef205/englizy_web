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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                      controller: cubit.emailLoginController,
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
                                      controller: cubit.passwordLoginController,
                                      type: TextInputType.visiblePassword,
                                      context: context,
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          cubit.isPassword
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color:
                                              Theme.of(context).iconTheme.color,
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
                                      mainAxisAlignment: MainAxisAlignment.end,
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
                                ),
                                //LogIn
                                cubit.isLoading
                                    ? const Center(
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
                                            if (cubit.formKey.currentState!
                                                .validate()) {
                                              cubit.formKey.currentState!
                                                  .save();
                                              cubit.userLogin(context: context);
                                            }
                                          },
                                          color: const Color.fromRGBO(
                                              74, 93, 170, 1),
                                          height: 50.0,
                                          child: const Text(
                                            'Login',
                                            style: TextStyle(
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
