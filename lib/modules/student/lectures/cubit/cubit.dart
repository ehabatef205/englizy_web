import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:englizy_app/modules/student/lectures/cubit/states.dart';
import 'package:englizy_app/shared/constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LecturesCubit extends Cubit<LecturesStates> {
  LecturesCubit() : super(LecturesInitialState());

  static LecturesCubit get(context) => BlocProvider.of(context);

  int index = 0;
  bool done = false;
  bool exist = false;
  String textName = "Next";
  int grade = 0;

  List<String> answers = [];

  void changeIndex() async{
    index++;
    emit(ChangeState());
  }

  void checkExist({required String unitId,required String partId}) async{
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("units").doc(unitId)
        .collection("parts").doc(partId)
        .collection("answers").doc(
        userModel!.uid).get();

    exist = doc.exists;
    print("Hello ${doc.exists}");
    emit(ExistState());
  }

  void changeAnswers({required int length}) {
    for (int i = 0; i < length; i++) {
      answers.add("");
    }
    emit(ChangeAnswersState());
  }

  void changeAnswer({required int index, required String answer}) {
    answers[index] = answer;
    emit(ChangeAnswerState());
  }

  void changeIndex2() {
    index--;
    emit(ChangeState());
  }

  void changeTextName() {
    textName = "Done";
    emit(ChangeState());
  }

  void submitAnswers(
      {required String id,
      required String partId,
      required List<dynamic> data,
      required BuildContext context}) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("units")
        .doc(id)
        .collection("parts")
        .doc(partId)
        .collection("answers")
        .doc(userModel!.uid)
        .get();
    if (!doc.exists) {
      for (int i = 0; i < answers.length; i++) {
        if (answers[i] == data[i]["correct"]) {
          grade++;
        }
      }

      await FirebaseFirestore.instance
          .collection("units")
          .doc(id)
          .collection("parts")
          .doc(partId)
          .collection("answers")
          .doc(userModel!.uid)
          .set({
        "answers": answers,
        "time": DateTime.now(),
        "grade": grade.toString(),
      }).whenComplete(() async {
        Navigator.pop(context);
      });
    } else {
      Fluttertoast.showToast(
        msg: "You answered before that",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }
}
