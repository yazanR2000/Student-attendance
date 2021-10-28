import 'dart:io';

import 'package:flutter/material.dart';
import '../providers/subjects.dart';
import 'package:intl/intl.dart';
import '../providers/subject_lectures.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import './pdf_subject.dart';
import './pdf_lecture.dart';
class PrintTheAttendanceSchedule extends StatelessWidget {
  Future _getSubjects(BuildContext context) async {
    await Provider.of<Subjects>(context, listen: false).getDoctorSubjects();
  }

  Future _createPDF() async {
    final pdf = pw.Document();

    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World"),
          ); // Center
        }));

    final output = await getDownloadsDirectory();

    print(output!.path);
    final file = File("${output.path}/example.pdf");
    try {
      await file.writeAsBytes(await pdf.save());
      print('done');
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 200,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.yellow.shade50,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          //mainAxisAlignment: MainAxisAlignment,
          children: [
            FittedBox(
              child: Text(
                'Schedule to Excel',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return PdfSubject();
                    });
              },
              child: Text('For subject'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                primary: Color(0xff393E46),
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) {
                      return PdfLecture();
                    });
              },
              child: Text('For Lecture'),
            ),
          ],
        ),
      ),
    );
  }
}
