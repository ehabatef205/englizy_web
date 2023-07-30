// import 'dart:io';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:englizy_app/shared/constant.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:internet_file/internet_file.dart';
// import 'package:pdfx/pdfx.dart';
//
// class ViewPdfLinkHomework extends StatefulWidget {
//   final String link;
//   final String name;
//   final String id;
//
//   const ViewPdfLinkHomework({required this.link, required this.name, required this.id, Key? key})
//       : super(key: key);
//
//   @override
//   State<ViewPdfLinkHomework> createState() => _ViewPdfLinkHomeworkState();
// }
//
// enum DocShown { sample, tutorial, hello, password }
//
// class _ViewPdfLinkHomeworkState extends State<ViewPdfLinkHomework> {
//   late PdfControllerPinch _pdfControllerPinch;
//   late PdfControllerPinch _pdfControllerPinch2;
//
//   @override
//   void initState() {
//     _pdfControllerPinch = PdfControllerPinch(
//       document: PdfDocument.openData(
//         InternetFile.get(
//           widget.link,
//         ),
//       ),
//       initialPage: 1,
//     );
//     super.initState();
//   }
//
//   @override
//   void dispose() {
//     _pdfControllerPinch.dispose();
//     super.dispose();
//   }
//
//   bool isLoading = false;
//   FilePickerResult? pdf;
//   UploadTask? uploadTask;
//
//   void choosePdf() async {
//     pdf = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: ["pdf"],
//         allowMultiple: false);
//     _pdfControllerPinch2 = PdfControllerPinch(
//       document: PdfDocument.openFile(pdf!.files[0].path!),
//       initialPage: 1,
//     );
//     setState(() {});
//   }
//
//   Future uploadPdf() async {
//     setState(() {
//       isLoading = true;
//     });
//     Reference reference = FirebaseStorage.instance
//         .ref()
//         .child("homework")
//         .child(userModel!.uid)
//         .child(
//             "${DateTime.now().millisecondsSinceEpoch}.${getName(File(pdf!.files[0].path!))}");
//
//     uploadTask =
//         reference.putData(await File(pdf!.files[0].path!).readAsBytes());
//     await uploadTask!.whenComplete(() async {
//       await reference.getDownloadURL().then((urlPdf) async {
//         await FirebaseFirestore.instance
//             .collection("units")
//             .doc(widget.id)
//             .collection("homework")
//             .doc(userModel!.uid)
//             .set({
//           "pdf": urlPdf,
//           "grade": "0",
//           "uid": userModel!.uid,
//           "time": DateTime.now(),
//         }).whenComplete(() async {
//           Navigator.pop(context);
//         });
//       });
//     }).catchError((error) {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   String getName(File video) {
//     return video.path.split(".").last;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.name,
//           style: TextStyle(
//             color: Theme.of(context).textTheme.bodyText1!.color,
//           ),
//         ),
//         actions: [
//           IconButton(
//               onPressed: () async {
//                 DocumentSnapshot doc = await FirebaseFirestore.instance
//                     .collection("units")
//                     .doc(widget.id)
//                     .collection("homework")
//                     .doc(userModel!.uid)
//                     .get();
//                 if(doc.exists){
//                   Fluttertoast.showToast(
//                     msg: "Your grade is ${doc.get("grade")}",
//                     toastLength: Toast.LENGTH_SHORT,
//                     gravity: ToastGravity.BOTTOM,
//                     timeInSecForIosWeb: 1,
//                     backgroundColor: Colors.green,
//                     textColor: Colors.white,
//                     fontSize: 16.0,
//                   );
//                 }else{
//                   if(pdf == null){
//                     choosePdf();
//                   }
//                 }
//               },
//               icon: Icon(Icons.add))
//         ],
//       ),
//       body: pdf == null
//           ? PdfViewPinch(
//               builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
//                 options: const DefaultBuilderOptions(),
//                 documentLoaderBuilder: (_) =>
//                     const Center(child: CircularProgressIndicator()),
//                 pageLoaderBuilder: (_) =>
//                     const Center(child: CircularProgressIndicator()),
//                 errorBuilder: (_, error) =>
//                     Center(child: Text(error.toString())),
//               ),
//               controller: _pdfControllerPinch,
//               padding: 10,
//             )
//           : Stack(
//               alignment: Alignment.bottomRight,
//               children: [
//                 PdfViewPinch(
//                   builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
//                     options: const DefaultBuilderOptions(),
//                     documentLoaderBuilder: (_) =>
//                         const Center(child: CircularProgressIndicator()),
//                     pageLoaderBuilder: (_) =>
//                         const Center(child: CircularProgressIndicator()),
//                     errorBuilder: (_, error) =>
//                         Center(child: Text(error.toString())),
//                   ),
//                   controller: _pdfControllerPinch2,
//                   padding: 10,
//                 ),
//                 isLoading? SizedBox() : Padding(
//                   padding: const EdgeInsets.all(10),
//                   child: Container(
//                     decoration: const BoxDecoration(
//                       color: Colors.indigo,
//                       shape: BoxShape.circle,
//                     ),
//                     child: IconButton(
//                       onPressed: () {
//                         uploadPdf();
//                       },
//                       icon: const Icon(
//                         Icons.send,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//     );
//   }
// }
