import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../providers/subjects.dart';
import 'package:intl/intl.dart';
import '../providers/subject_lectures.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import '../dummy_data.dart';
import '../providers/attendance_pdf.dart';

class PdfSubject extends StatefulWidget {
  @override
  _PdfSubjectState createState() => _PdfSubjectState();
}

class _PdfSubjectState extends State<PdfSubject> {
  final list = Dummy().students;
  List<Map<String, List<Map<String, dynamic>>>>? _subjectAtt;

  String? _subject;

  Future _getSubjects(BuildContext context) async {
    if (Provider.of<Subjects>(context, listen: false).subject.length == 0)
      await Provider.of<Subjects>(context, listen: false).getDoctorSubjects();
  }

  Future _getAttendance(String subject) async {
    setState(() {
      _isLoading = true;
    });
    final attProvider = Provider.of<AttendancePdf>(context, listen: false);
    await attProvider.getAttendanceForSubject(subject);
    _subjectAtt = attProvider.Attendance;
    _createPDF();
  }

  Future _createPDF() async {
    final pdf = pw.Document();
    _subjectAtt!.forEach((lecture) {
      lecture.forEach((lectureName, students) {
        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '$_subject',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.SizedBox(height: 5),
                    pw.Text('Lecture : $lectureName'),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      padding: pw.EdgeInsets.all(10),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              'Student Number',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              'Student Name',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              'Date',
                              textAlign: pw.TextAlign.left,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          pw.Expanded(
                            child: pw.Text(
                              'Scan count',
                              textAlign: pw.TextAlign.center,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    pw.Divider(),
                    pw.Expanded(
                      child: pw.ListView.builder(
                        padding: pw.EdgeInsets.symmetric(horizontal: 8),
                        itemCount: students.length,
                        itemBuilder: (ctx, i) {
                          final format = new DateFormat('yyyy-MM-dd hh:mm');
                          var date = format.format(DateTime.now());
                          return pw.Container(
                            padding: pw.EdgeInsets.symmetric(
                                vertical: 15, horizontal: 8),
                            decoration: pw.BoxDecoration(
                                //borderRadius: BorderRadius.circular(20),
                                ),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Expanded(
                                  child: pw.Text(
                                    '${students[i]['studentNum']}',
                                    textAlign: pw.TextAlign.left,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${students[i]['studentName']}',
                                    textAlign: pw.TextAlign.left,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${students[i]['date']}',
                                    textAlign: pw.TextAlign.left,
                                  ),
                                ),
                                pw.Expanded(
                                  child: pw.Text(
                                    '${students[i]['scans']}',
                                    textAlign: pw.TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ); // Center
            },
          ),
        );
      });
    });

    try {
      final output = await getDownloadsDirectory();
      var rng = new Random();
      final rndNumber = rng.nextInt(1000);
      print(output!.path);
      final file = File("${output.path}/$_subject-$rndNumber");
      await file.writeAsBytes(await pdf.save());
      print('done');
      setState(() {
        _isLoading = false;
        _showResult = true;
      });
    } on FileSystemException catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
        _showResult = true;
        _error = err.toString();
      });
    } catch (err) {
      print(err);
      setState(() {
        _isLoading = false;
        _showResult = true;
        _error = err.toString();
      });
    }
    setState(() {
      _isLoading = false;
      _showResult = true;
    });
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _showResult = false;
        _error = null;
      });
    });
  }

  bool _isLoading = false;
  bool _showResult = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('PDF'),
      content: Container(
        height: 300,
        width: 200,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
                future: _getSubjects(context),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final subjects =
                      Provider.of<Subjects>(context, listen: false).subject;
                  return Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned.fill(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Select subject'),
                            SizedBox(
                              height: 10,
                            ),
                            Expanded(
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 1,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 5 / 2,
                                ),
                                itemBuilder: (ctx, i) {
                                  final subject =
                                      subjects[i].toString().split(",");
                                  return ElevatedButton(
                                    onPressed: () {
                                      _subject = subject[2] + ',' + subject[3];
                                      _getAttendance(subjects[i]);
                                    },
                                    child: FittedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'College : ${subject[0]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Section : ${subject[1]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Subject Number : ${subject[2]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Division No : ${subject[3]}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: subjects.length,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_showResult)
                        Positioned(
                          top: 10,
                          left: 10,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: _error == null
                                  ? Color(0xff393E46)
                                  : Colors.red,
                            ),
                            child: FittedBox(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    _error == null ? Icons.done : Icons.error,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    _error == null
                                        ? 'Downloaded successfully'
                                        : 'Something went wrong',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
      ),
    );
  }
}
