import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:englizy_app/modules/student/change_password/cubit/cubit.dart';
import 'package:englizy_app/modules/student/change_password/cubit/states.dart';
import 'package:englizy_app/modules/student/settings_student/settings_student_screen.dart';
import 'package:englizy_app/shared/color.dart';
import 'package:englizy_app/shared/components.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (BuildContext context) => ChangePasswordCubit(),
      child: BlocConsumer<ChangePasswordCubit, ChangePasswordStates>(
          listener: (context, state) {},
          builder: (context, state) {
            ChangePasswordCubit cubit = ChangePasswordCubit.get(context);
            return Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  'Change password',
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
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Form(
                              key: cubit.formKey,
                              child: Column(
                                children: [
                                  TextFormFieldWidget(
                                    controller: cubit.lastPasswordController,
                                    context: context,
                                    type: TextInputType.visiblePassword,
                                    labelText: 'Last password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        cubit.isPassword
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        cubit.passwordChange();
                                      },
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    obscureText: cubit.isPassword,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "Last password is required";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormFieldWidget(
                                    controller: cubit.newPasswordController,
                                    context: context,
                                    type: TextInputType.visiblePassword,
                                    labelText: 'New Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        cubit.isPassword2
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        cubit.passwordChange2();
                                      },
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    obscureText: cubit.isPassword2,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "New Password is required";
                                      }
                                      return null;
                                    },
                                  ),const SizedBox(
                                    height: 8.0,
                                  ),
                                  TextFormFieldWidget(
                                    controller: cubit.confirmNewPasswordController,
                                    context: context,
                                    type: TextInputType.visiblePassword,
                                    labelText: 'Confirm New Password',
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        cubit.isPassword3
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                      onPressed: () {
                                        cubit.passwordChange3();
                                      },
                                      color: Theme.of(context).iconTheme.color,
                                    ),
                                    obscureText: cubit.isPassword3,
                                    validate: (value) {
                                      if (value!.isEmpty) {
                                        return "Confirm New Password is required";
                                      }else if(value != cubit.newPasswordController.text){
                                        return "Password is not match";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  cubit.loading
                                      ? Center(
                                          child: CircularProgressIndicator(
                                            color: colorButton,
                                          ),
                                        )
                                      : Container(
                                          width: size.width * 0.7,
                                          clipBehavior:
                                              Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                          ),
                                          child: MaterialButton(
                                            onPressed: () {
                                              cubit.changePassword(context: context);
                                            },
                                            color: Colors.indigo,
                                            height: 50.0,
                                            child: Text(
                                              'Change Password',
                                              style: TextStyle(
                                                color: Theme.of(context).textTheme.bodyText1!.color,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
