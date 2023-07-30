import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/admin/admin_add_part/cubit/states.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

class AdminAddPartCubit extends Cubit<AdminAddPartStates> {
  AdminAddPartCubit() : super(AdminAddPartInitialState());

  static AdminAddPartCubit get(context) => BlocProvider.of(context);

  TextEditingController descriptionUnitController = TextEditingController();
  TextEditingController numberOfQuestionsController = TextEditingController();
  TextEditingController namePartController = TextEditingController();
  List<TextEditingController> controllers = [];
  List<Map<String, dynamic>> questions = [];
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  VideoPlayerController? controller;
  ChewieController? chewieController;
  int numberOfQuestions = 0;
  bool isLoading = false;
  FilePickerResult? result;
  UploadTask? uploadTask;
  List<String> videosUrl = [];
  List<bool> isDone = [];

  void createChewieController(PlatformFile video) {
    VideoPlayerController controller =
        VideoPlayerController.file(File(video.path!))..initialize();
    chewieController = ChewieController(
      videoPlayerController: controller,
      autoPlay: false,
      looping: false,
      allowFullScreen: true,
      showOptions: true,
    );
    emit(VideoState());
  }

  void chooseNumberOfQuestions() async {
    questions.clear();
    numberOfQuestions = int.parse(numberOfQuestionsController.text);
    for (int i = 0; i < numberOfQuestions; i++) {
      controllers.add(TextEditingController());
      questions.add({
        "question${i + 1}": "",
        "answer1": "",
        "answer2": "",
        "answer3": "",
        "answer4": "",
        "correct": ""
      });
    }
    emit(ChooseNumberOfQuestionsState());
  }

  void changeQuestion(String question, int index) {
    questions[index]["question${index + 1}"] = question;
    emit(QuestionState());
  }

  void changeAnswer1(String answer1, int index) {
    questions[index]["answer1"] = answer1;
    emit(Answer1State());
  }

  void changeAnswer2(String answer2, int index) {
    questions[index]["answer2"] = answer2;
    emit(Answer2State());
  }

  void changeAnswer3(String answer3, int index) {
    questions[index]["answer3"] = answer3;
    emit(Answer3State());
  }

  void changeAnswer4(String answer4, int index) {
    questions[index]["answer4"] = answer4;
    emit(Answer4State());
  }

  void changeCorrect(String correct, int index) {
    questions[index]["correct"] = correct;
    emit(CorrectState());
  }

  void chooseVideo() async {
    result = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: true);
    for (int i = 0; i < result!.files.length; i++) {
      isDone.add(false);
    }
    emit(ChangeVideoState());
  }

  void chooseVideo2() async {
    FilePickerResult? result1 = await FilePicker.platform
        .pickFiles(type: FileType.video, allowMultiple: true);
    for (int i = 0; i < result1!.files.length; i++) {
      result!.files.add(result1.files[i]);
      isDone.add(false);
    }
    emit(ChangeVideoState());
  }

  Future uploadVideos(BuildContext context, String name, String id) async {
    isLoading = true;
    emit(LoadingState());
    for (int i = 0; i < result!.files.length; i++) {
      isDone[i] = true;
      Reference reference = FirebaseStorage.instance
          .ref()
          .child("units")
          .child(name)
          .child("${DateTime.now().millisecondsSinceEpoch}.${result!.files[i].name}");

      uploadTask = reference.putData(result!.files[i].bytes!);
      await uploadTask!.whenComplete(() async {
        await reference.getDownloadURL().then((urlVideo) {
          videosUrl.add((urlVideo));
          emit(AddVideoState());
        });
      });
    }

    await FirebaseFirestore.instance
        .collection("units")
        .doc(id)
        .collection("parts")
        .add({
      "name": namePartController.text,
      "videos": videosUrl,
      "description": descriptionUnitController.text,
      "questions": questions,
      "time": DateTime.now(),
      "view": false,
      "viewGrade": false,
    }).whenComplete(() async {
      isLoading = false;
      emit(LoadingState());
      Navigator.pop(context);
    }).catchError((error) {
      isLoading = false;
      emit(LoadingState());
    });
  }

  String getName(File video) {
    return video.path.split(".").last;
  }
}
