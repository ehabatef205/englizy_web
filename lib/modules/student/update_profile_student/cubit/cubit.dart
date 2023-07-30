import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/update_profile_student/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileStudentCubit extends Cubit<UpdateProfileStudentStates> {
  UpdateProfileStudentCubit() : super(UpdateProfileStudentInitialState());

  static UpdateProfileStudentCubit get(context) => BlocProvider.of(context);

  TextEditingController parentsPhoneNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController centerController = TextEditingController();
  String? academicYear;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isLoading = false;
  XFile? image;
  String img64 = '';
  String dropdownValue = 'academic year';
  String? levelId;

  void changeLevelId(String? id) {
    levelId = id;
    emit(ChangeState());
  }

  void changeLevel(String? level) {
    levelController.text = level!;
    emit(ChangeState());
  }

  void changeItem2(newValue) {
    centerController.text = newValue;
    emit(ChangeState());
  }

  void dataUser() {
    parentsPhoneNumberController.text = userModel!.parentPhone;
    nameController.text = userModel!.studentName;
    phoneController.text = userModel!.studentPhone;
    FirebaseFirestore.instance
        .collection("levels")
        .doc(userModel!.level)
        .get()
        .then((value) {
      levelController.text = value["name"];
    });
    emit(ChangeDataState());
  }

  List<String> academicYearList = [
    'First year of high school',
    'Second year of high school',
    'Third year of high school',
  ];

  void changeItem(newValue) {
    dropdownValue = newValue;
    academicYear = dropdownValue;
    emit(ChangeState());
  }

  void chooseImage() async {
    image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    emit(ChangeImageState());
  }

  Future uploadImage(BuildContext context) async {
    if (image != null) {
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("users")
          .child(userModel!.uid)
          .child(
              "${DateTime.now().millisecondsSinceEpoch}.${getName(File(image!.path))}");

      UploadTask uploadTask =
          reference.putData(await File(image!.path).readAsBytes());
      await uploadTask!.whenComplete(() async {
        await reference.getDownloadURL().then((urlImage) async {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userModel!.uid)
              .update({
            "image": urlImage,
            "parentPhone": parentsPhoneNumberController.text,
            "studentName": nameController.text,
            "studentPhone": phoneController.text,
            "level": levelId == null? userModel!.level : levelId,
          }).whenComplete(() async {
            userModel!.image = urlImage;
            userModel!.parentPhone = parentsPhoneNumberController.text;
            userModel!.studentName = nameController.text;
            userModel!.studentPhone = phoneController.text;
            userModel!.level = levelId == null? userModel!.level : levelId!;
            emit(UpdateSuccessState());
            Navigator.pop(context);
          });
        });
      });
    } else {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userModel!.uid)
          .update({
        "parentPhone": parentsPhoneNumberController.text,
        "studentName": nameController.text,
        "studentPhone": phoneController.text,
        "level": levelId == null? userModel!.level : levelId,
      }).whenComplete(() async {
        userModel!.parentPhone = parentsPhoneNumberController.text;
        userModel!.studentName = nameController.text;
        userModel!.studentPhone = phoneController.text;
        userModel!.level = levelId == null? userModel!.level : levelId!;
        emit(UpdateSuccessState());
        Navigator.pop(context);
      });
    }
  }

  String getName(File imageFile) {
    return imageFile.path.split(".").last;
  }
}
