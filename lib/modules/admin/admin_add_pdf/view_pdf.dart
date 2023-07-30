// /*
// import 'package:flutter/material.dart';
// import 'package:pdfx/pdfx.dart';
//
// class ViewPdf extends StatefulWidget {
//   final String path;
//   const ViewPdf({required this.path, Key? key}) : super(key: key);
//
//   @override
//   State<ViewPdf> createState() => _ViewPdfState();
// }
//
// enum DocShown { sample, tutorial, hello, password }
//
// class _ViewPdfState extends State<ViewPdf> {
//   late PdfControllerPinch _pdfControllerPinch;
//
//   @override
//   void initState() {
//     _pdfControllerPinch = PdfControllerPinch(
//       document: PdfDocument.openFile(widget.path),
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
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey,
//       appBar: AppBar(
//         title: Text(widget.path.split("/").last),
//       ),
//       body: PdfViewPinch(
//         builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
//           options: const DefaultBuilderOptions(),
//           documentLoaderBuilder: (_) =>
//           const Center(child: CircularProgressIndicator()),
//           pageLoaderBuilder: (_) =>
//           const Center(child: CircularProgressIndicator()),
//           errorBuilder: (_, error) => Center(child: Text(error.toString())),
//         ),
//         controller: _pdfControllerPinch,
//         padding: 10,
//       ),
//     );
//   }
// }*/
