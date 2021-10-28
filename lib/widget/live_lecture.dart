import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dummy_data.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/live_lecture.dart';
import '../providers/subjects.dart';
import './timer_live_lecture.dart';
import './add_lecture_dialog.dart';
import '../screens/student_attendance_screen.dart';

class LiveLectureWidget extends StatelessWidget {
  final int _flex;

  LiveLectureWidget(this._flex);

  Future _fetchLiveLecture(BuildContext context, String docId) async {
    bool isFetch = Provider.of<LiveLecture>(context,listen: false).isFetch;
    if (!isFetch)
      await Provider.of<LiveLecture>(context, listen: false)
          .getLiveLecture(docId);
    else {
      return Future.delayed(Duration(seconds: 0));
    }
  }

  Future _fetchLiveLectureAtt(
      BuildContext context, String subject, String lecture) async {
    bool isFetch = Provider.of<LiveLecture>(context).isFetchAtt;
    if (!isFetch)
      await Provider.of<LiveLecture>(context, listen: false)
          .getLiveLectureAttendance(subject, lecture);
    else {
      return Future.delayed(Duration(seconds: 0));
    }
  }

  @override
  Widget build(BuildContext context) {
    final doc_Id = Provider.of<Subjects>(context, listen: false).UserId;
    return Expanded(
      flex: _flex,
      child: Container(
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder(
            future: _fetchLiveLecture(context, doc_Id),
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final lectureName =
                  Provider.of<LiveLecture>(context, listen: false).lectureName;
              return lectureName['Lecture_Name'] == null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('There is no lecture live now!'),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return AddLectureDialog(context);
                                  });
                            },
                            child: Text('Add new lecture'),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ListTile(
                                hoverColor: Colors.red,
                                contentPadding: EdgeInsets.zero,
                                dense: true,
                                title: Text(
                                  '${lectureName['Lecture_Name']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                                subtitle:
                                    Text('${lectureName['Subject_Name']}'),
                                leading: Chip(
                                  label: Text('Live'),
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                trailing: TimerLiveLecture(
                                  lectureName['endIn']!.substring(11),
                                ),
                              ),
                            ),
                          ],
                        ),

//                  SizedBox(
//                    height: 15,
//                  ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Student Number',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Student Name',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Date',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Scan count',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Expanded(
                          child: FutureBuilder(
                            future: _fetchLiveLectureAtt(
                                context,
                                lectureName['full_subject']!,
                                lectureName['Lecture_Name']!),
                            builder: (ctx, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              final List<Map<String, dynamic>> attendance =
                                  Provider.of<LiveLecture>(context,
                                          listen: false)
                                      .attendance;
                              return ListView.builder(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                itemCount: attendance.length,
                                itemBuilder: (ctx, i) {
                                  return TextButton(
                                    style: TextButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      //elevation: 0.5,
                                      backgroundColor: i % 2 == 0 || i == 0
                                          ? Colors.white
                                          : Color(0xffEEEEEE),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pushNamed(
                                        StudentAttendanceScreen.routeName,
                                        arguments: attendance[i]['studentNum'].toString(),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                        horizontal: 8,
                                      ),
//                                      decoration: BoxDecoration(
//                                        //borderRadius: BorderRadius.circular(20),
//                                        color: i % 2 == 0 || i == 0
//                                            ? Colors.white
//                                            : Color(0xffEEEEEE),
//                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              '${attendance[i]['studentNum']}',
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Expanded(
                                              child: Text(
                                            '${attendance[i]['studentName']}',
                                            textAlign: TextAlign.left,
                                          )),
                                          Expanded(
                                              child: Text(
                                            '${attendance[i]['date']}',
                                            textAlign: TextAlign.left,
                                          )),
                                          Expanded(
                                            child: Text(
                                              '${attendance[i]['scans']}',
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
            }),
      ),
    );
  }
}
