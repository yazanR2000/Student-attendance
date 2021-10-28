import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app_desk/providers/attendance_pdf.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import '../providers/subject_lectures.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

enum Stages { SubjectStage, LectureStage }

class PdfLecture extends StatefulWidget {
  @override
  _PdfLectureState createState() => _PdfLectureState();
}

class _PdfLectureState extends State<PdfLecture> {
  Future _getSubjects(BuildContext context) async {
    if (Provider.of<Subjects>(context, listen: false).subject.length == 0)
      await Provider.of<Subjects>(context, listen: false).getDoctorSubjects();
  }

  Stages _stages = Stages.SubjectStage;
  String? _subject;

  Future _createPdf(
      String lectureName, List<Map<String, dynamic>> students) async {
    final pdf = pw.Document();
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
                      return pw.Container(
                        padding: pw.EdgeInsets.symmetric(
                            vertical: 15, horizontal: 8),
                        decoration: pw.BoxDecoration(
                            //borderRadius: BorderRadius.circular(20),
                            ),
                        child: pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
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
    try {
      final output = await getDownloadsDirectory();
      var rng = new Random();
      final rndNumber = rng.nextInt(1000);
      print(output!.path);
      final file = File("${output.path}/$_subject-$lectureName\n$rndNumber");
      await file.writeAsBytes(await pdf.save());
      print('done');
    } on FileSystemException catch (err) {
      print(err);
    } catch (err) {
      print(err);

    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = Provider.of<Subjects>(context,listen: false).UserId;
    return AlertDialog(
      title: Text('PDF'),
      content: Container(
        height: 300,
        width: 200,
        child: _stages == Stages.SubjectStage
            ? FutureBuilder(
                future: _getSubjects(context),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final subjects =
                      Provider.of<Subjects>(context, listen: false).subject;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Subject'),
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
                            final subject = subjects[i].toString().split(",");
                            return ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _stages = Stages.LectureStage;
                                  _subject = subjects[i];
                                });
                              },
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
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
                  );
                },
              )
            : FutureBuilder(
                future: Provider.of<SubjectLectures>(context, listen: false)
                    .getLectures(_subject!,doctorId),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  //final lecture = [];
                  final lectures =
                      Provider.of<SubjectLectures>(context, listen: false)
                          .lectures;
//                  for (int i = 0; i < lectures.length; i++) {
//                    final dates = lectures[i].toString().split('|');
//                    //print(dates);
//                    //endDate.add(_isAfter(dates[2],dates[1]));
//                    lecture.add(dates[0]);
//                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select Lecture'),
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
                            return ElevatedButton(
                              onPressed: () async {
                                final attProvider = Provider.of<AttendancePdf>( context, listen: false);
                                await attProvider.getAttendanceForLecture( _subject!, lectures[i]['Lecture_name']);
                                await _createPdf(lectures[i]['Lecture_name'], attProvider.LectureAttendance);
                              },
                              child: Text(
                                lectures[i]['Lecture_name'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            );
                          },
                          itemCount: lectures.length,
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
