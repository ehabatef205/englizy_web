import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_unit/cubit/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminAddUnitCubit extends Cubit<AdminAddUnitStates> {
  AdminAddUnitCubit() : super(AdminAddUnitInitialState());

  static AdminAddUnitCubit get(context) => BlocProvider.of(context);

  TextEditingController nameUnitController = TextEditingController();
  TextEditingController levelController = TextEditingController();
  TextEditingController descriptionUnitController = TextEditingController();
  TextEditingController priceUnitController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;

  FilePickerResult? pdf;
  UploadTask? uploadTask;

  UploadTask? uploadTask2;

  String? levelId;

  XFile? image;
  XFile? video;

  Uint8List webImage = Uint8List(8);
  Uint8List webVideo = Uint8List(8);
  Uint8List webPDF = Uint8List(8);

  String imageUrl = "";
  String videoUrl = "";
  String pdfUrl = "";

  void chooseImage() async {
    image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    webImage = await image!.readAsBytes();
    emit(ChangeImageState());
  }

  void changeLevelId(String? id) {
    levelId = id;
    emit(ChangeState());
  }

  void changeLevel(String? level) {
    levelController.text = level!;
    emit(ChangeIsAddState());
  }

  Future<void> addUnit({required BuildContext context}) async {
    if (formKey.currentState!.validate() && image != null) {
      formKey.currentState!.save();
      isLoading = true;
      emit(LoadingState());
      uploadPhoto().whenComplete(() async {
        uploadVideo().whenComplete(() async {
          uploadPdf().whenComplete(() async {
            await FirebaseFirestore.instance.collection("units").add({
              "name": nameUnitController.text,
              "level": levelId,
              "video": videoUrl,
              "homework": pdfUrl,
              "description": descriptionUnitController.text,
              "price": priceUnitController.text,
              "students": [],
              "view": false,
              "image": imageUrl,
              "time": DateTime.now(),
            }).whenComplete(() async {
              isLoading = false;
              Navigator.pop(context);
              emit(LoadingSuccessState());
            }).catchError((error) {
              emit(LoadingErrorState());
            });
          });
        });
      });
    }
  }

  Future uploadPhoto() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("units")
        .child(nameUnitController.text)
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${image!.name}");

    UploadTask uploadTask =
        reference.putData(webImage);
    await uploadTask.whenComplete(() async {
      await reference.getDownloadURL().then((urlImage) {
        imageUrl = urlImage;
        emit(ChooseImageState());
      });
    });
  }

  void chooseVideo() async {
    video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );

    webVideo = await video!.readAsBytes();
    print(video!.readAsBytes());
    emit(ChangeVideoState());
  }

  void choosePdf() async {
    pdf = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ["pdf"],
        allowMultiple: false);

    webPDF = pdf!.files.first.bytes!;
    emit(ChangePDFState());
  }

  Future uploadPdf() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("units")
        .child("pdfs")
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${pdf!.files[0].name}");

    uploadTask =
        reference.putData(webPDF);
    await uploadTask!.whenComplete(() async {
      await reference.getDownloadURL().then((urlPdf) async {
        pdfUrl = urlPdf;
        emit(AddPDFState());
      });
    });
  }

  Future uploadVideo() async {
    Reference reference = FirebaseStorage.instance
        .ref()
        .child("units")
        .child("videos")
        .child(
            "${DateTime.now().millisecondsSinceEpoch}.${video!.name}");

    uploadTask2 =
        reference.putData(webVideo);
    await uploadTask2!.whenComplete(() async {
      await reference.getDownloadURL().then((urlVideo) async {
        videoUrl = urlVideo;
        emit(AddPDFState());
      });
    });
  }
}
