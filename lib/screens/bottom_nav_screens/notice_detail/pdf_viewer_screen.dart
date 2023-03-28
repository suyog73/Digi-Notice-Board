// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:notice_board/helpers/constants.dart';
import 'package:path/path.dart' as path;

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({Key? key, required this.file, this.pdfName = ""})
      : super(key: key);
  final File file;
  final String pdfName;

  @override
  Widget build(BuildContext context) {
    final name = pdfName == "" ? path.basename(file.path) : pdfName;

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        backgroundColor: mainColor(context),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
