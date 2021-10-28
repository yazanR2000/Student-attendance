import 'package:flutter/material.dart';
import 'package:flutter_app_desk/providers/subject_lectures.dart';
import '../dummy_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import '../providers/student_attendance.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StudentAttendanceScreen extends StatefulWidget {
  static const routeName = 'StudentAttendanceScreen';

  @override
  State<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  final list = Dummy().students;

  Future _studentAttendance() async {
    await Provider.of<Subjects>(context, listen: false).getDoctorSubjects();
    final subjects = Provider.of<Subjects>(context, listen: false).subject;
  }

  Future _getDoctorSubject() async {
    bool isFetch = Provider.of<Subjects>(context, listen: false).isFetch;
    if (!isFetch)
      await Provider.of<Subjects>(context, listen: false).getDoctorSubjects();
    else
      return Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    final stdNumber = ModalRoute.of(context)!.settings.arguments as String;
    final stdAtt = Provider.of<StudentAttendance>(context, listen: false);
    final lectureAtt = Provider.of<SubjectLectures>(context, listen: false);
    return ResponsiveBuilder(
      builder: (ctx, constraints) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            //backgroundColor: Colors.white,
            title: Text(
              'Student Attendance',
              style: TextStyle(
                  color: Color(0xff222831),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
          ),
          body: FutureBuilder(
            future: _getDoctorSubject(),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              final subjects =
                  Provider.of<Subjects>(context, listen: false).subject;
              return GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                itemCount: subjects.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        constraints.screenSize.width <= 1000 ? 1 : 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15),
                itemBuilder: (ctx, i) {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    decoration: BoxDecoration(
                      color: Color(0xffF4F9F9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subjects[i],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xff222831),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Lecture Name',
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Lecture type',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Date',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Attend',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Scans',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xffEEEEEE),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Lectures(subjects[i], stdNumber)
                      ],
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}

class DidAttend extends StatefulWidget {
  final String _lectureName;
  final String _subject;
  final String _stdNumber;

  DidAttend(this._subject, this._lectureName, this._stdNumber);

  @override
  _DidAttendState createState() => _DidAttendState();
}

class _DidAttendState extends State<DidAttend> {
  bool? _attend;

  Future _checkAttend() async {
    _attend = await Provider.of<StudentAttendance>(context, listen: false)
        .getStudentAttendanceForSubject(
      widget._subject,
      widget._stdNumber,
      widget._lectureName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder(
        future: _checkAttend(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          return Icon(
            _attend! ? Icons.done : Icons.clear,
            color: _attend! ? Colors.green : Colors.red,
          );
        },
      ),
    );
  }
}

class Lectures extends StatefulWidget {
  final String _subject;
  final String _stdNumber;

  Lectures(this._subject, this._stdNumber);

  @override
  _LecturesState createState() => _LecturesState();
}

class _LecturesState extends State<Lectures> {
  List<Map<String,dynamic>>? _lectures = [];

  Future _getLectures(String doctorId) async {
    _lectures = await Provider.of<SubjectLectures>(context, listen: false)
        .getLectures(widget._subject,doctorId);
  }

  @override
  Widget build(BuildContext context) {
    final lectureAtt = Provider.of<SubjectLectures>(context, listen: false);
    final doctorId = Provider.of<Subjects>(context,listen: false).UserId;
    return Expanded(
      child: FutureBuilder(
        future: _getLectures(doctorId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          final lectures = lectureAtt.lectures;
          return ListView.builder(
            itemCount: _lectures == null ? 0 : _lectures!.length,
            itemBuilder: (ctx, index) {
              //List<String> lectureData = _lectures![index].split('|');
              return Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _lectures![index]['Lecture_name'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _lectures![index]['type'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        _lectures![index]['startsIn'],
                        textAlign: TextAlign.center,
                      ),
                    ),
                    DidAttend(
                      widget._subject,
                      _lectures![index]['Lecture_name'],
                      widget._stdNumber,
                    ),
                    Expanded(
                      child: Text(
                        '3',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
