import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app_desk/providers/live_lecture.dart';
import 'package:flutter_app_desk/providers/subjects.dart';
import 'package:provider/provider.dart';
import '../providers/subject_lectures.dart';
import './new_lecture_screen.dart';
import './new_lecture_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import './lecture_attendance_screen.dart';
import 'package:intl/intl.dart';
import '../providers/last_5_lectures_chart.dart';
class LecturesScreen extends StatelessWidget {
  static const routeName = 'LecturesScreen';

  List<String> lecture = [];

  bool _isAfter(String endDate, String startDate) {
    //print(date);

    final aDate = endDate.substring(0, 11);
    //print(aDate);
    final am_pm1 = endDate.substring(11);
    //final nowDate = DateTime.now();

    final bDate = startDate.substring(0, 11);
    final am_pm2 = startDate.substring(11);

    //print('am_pm1:$am_pm1 , am_pm2:$am_pm2');

    final nowDate = DateTime.now().toLocal();
    final currentDate = new DateFormat(
      "yyyy-MM-dd HH:mm a",
    ).format(nowDate);

    final dateOfCurrent = currentDate.substring(0, 11);
    final timeOfCurrent = currentDate.substring(11);
    //print('am_pm1 : $am_pm1 \n am_pm2 : $am_pm2 ');

    //print('endDate : $endDate\n , startDate : $startDate\n , aDate:$aDate\n , bDate:$bDate\n , dateOfCurrent:$dateOfCurrent\n , timeOfCurrent:$timeOfCurrent\n');

    if (bDate == dateOfCurrent) {
      //print('yes');
      if (timeOfCurrent.compareTo(am_pm2) >= 0 &&
          timeOfCurrent.compareTo(am_pm1) < 0) {
        return true;
      }
      return false;
    } else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    final String? tableName =
        ModalRoute.of(context)!.settings.arguments as String;
    final doctorId = Provider.of<Subjects>(context, listen: false).UserId;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        //backgroundColor: Colors.white,
        title: Text(
          'Lectures',
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
        future: Provider.of<SubjectLectures>(context)
            .getLectures(tableName!, doctorId),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitFadingCircle(
                color: Color(0xff00ADB5),
              ),
            );
          }
          //lecture = [];
          final lectures =
              Provider.of<SubjectLectures>(context, listen: false).lectures;
          List<bool> endDate = [];
          for (int i = 0; i < lectures.length; i++) {
            //final dates = lectures[i].toString().split('|');
            //print(dates);
            endDate
                .add(_isAfter(lectures[i]['endsIn'], lectures[i]['startsIn']));
            //lecture.add(dates[0]);
          }
          //print(Provider.of<SubjectLectures>(context, listen: false).lectures);

          return lectures.length == 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'No lectures for this subject added!',
                        style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                              NewLectureScreen.routeName,
                              arguments: tableName);
                        },
                        child: Text('Add New Lecture'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 5 / 2,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  itemCount: lectures.length + 1,
                  itemBuilder: (ctx, i) {
                    if (i == lectures.length) {
                      return TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            NewLectureScreen.routeName,
                            arguments: tableName,
                          );
                        },
                        child: Center(
                          child: Icon(Icons.add),
                        ),
                      );
                    }
                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned.fill(
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pushNamed(
                              LectureAttendanceScreen.routName,
                              arguments: {
                                'lectureName': lectures[i]['Lecture_name'],
                                'subject': tableName
                              },
                            ),
                            child: Text(
                              lectures[i]['Lecture_name'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                        if (endDate[i] && i <= endDate.length)
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Chip(
                              label: Text('Live'),
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 30,
                          left: 0,
                          right: 0,
                          child: Text(
                            'Start Date : ${lectures[i]['startsIn']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xffEEEEEE), fontSize: 10),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          right: 0,
                          child: Text(
                            'End Date : ${lectures[i]['endsIn']}',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xffEEEEEE), fontSize: 10),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: IconButton(
                            iconSize: 20,
                            onPressed: () async {
                              await Provider.of<SubjectLectures>(context,
                                      listen: false)
                                  .deleteLecture(
                                tableName,
                                doctorId,
                                lectures[i]['Lecture_name'],
                              );
                              Provider.of<LiveLecture>(context,listen: false).toggleFetch();
                              Provider.of<LiveLecture>(context,listen: false).toggleFetchAtt();
                              Provider.of<Chart>(context,listen: false).toggleFetch();
                              Provider.of<Chart>(context,listen: false).notify();
                            },
                            color: Colors.red,
                            icon: Icon(
                              Icons.delete,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
        },
      ),
    );
  }
}
