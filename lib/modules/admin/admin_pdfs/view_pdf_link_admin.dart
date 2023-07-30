import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';
import 'package:pdfx/pdfx.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ViewPdfLinkAdmin extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> data;

  const ViewPdfLinkAdmin({required this.data, Key? key}) : super(key: key);

  @override
  State<ViewPdfLinkAdmin> createState() => _ViewPdfLinkAdminState();
}

enum DocShown { sample, tutorial, hello, password }

class _ViewPdfLinkAdminState extends State<ViewPdfLinkAdmin> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.data["name"],
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseFirestore.instance
                    .collection("pdfs")
                    .doc(widget.data.id)
                    .delete()
                    .whenComplete(() {
                  Navigator.pop(context);
                });
              },
              icon: Icon(Icons.delete_outline)),
        ],
      ),
      body: SfPdfViewer.network(
        widget.data["pdf"],
        key: _pdfViewerKey,
      ),
    );
  }
}
