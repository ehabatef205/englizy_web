import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/parts/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentViewPartsCubit extends Cubit<StudentViewPartsStates> {
  StudentViewPartsCubit() : super(StudentViewPartsInitialState());

  static StudentViewPartsCubit get(context) => BlocProvider.of(context);
  bool isLoading = false;
  FilePickerResult? pdf;
  UploadTask? uploadTask;

  Stream<QuerySnapshot> getParts(String id) {
    return FirebaseFirestore.instance.collection("units").doc(id).collection("parts").orderBy("time").snapshots();
  }

  void choosePdf() async {
    pdf = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ["pdf"], allowMultiple: false);
    emit(ChangePDFState());
  }

  Future uploadPdf({required BuildContext context, required String id}) async {
    isLoading = true;
    emit(LoadingState());
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("homework")
        .child(userModel!.uid)
        .child("${DateTime.now().millisecondsSinceEpoch}.${getName(File(pdf!.files[0].path!))}");

    uploadTask = reference.putData(await File(pdf!.files[0].path!).readAsBytes());
    await uploadTask!.whenComplete(() async {
      await reference.getDownloadURL().then((urlPdf) async {
        await FirebaseFirestore.instance.collection("units").doc(id).collection("homework").doc(userModel!.uid).set({
          "pdf": urlPdf,
          "uid": userModel!.uid,
          "time": DateTime.now(),
        }).whenComplete(() async{
          Navigator.pop(context);
        });
        emit(AddVideoState());
      });
    }).catchError((error) {
      isLoading = false;
      emit(LoadingErrorState());
    });
  }

  String getName(File video) {
    return video.path.split(".").last;
  }
}