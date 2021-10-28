import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/subject_lectures.dart';

class LectureAttendanceScreen extends StatefulWidget {
  static const routName = 'LectureAttendanceScreen';

  @override
  _LectureAttendanceScreenState createState() =>
      _LectureAttendanceScreenState();
}

class _LectureAttendanceScreenState extends State<LectureAttendanceScreen> {
  List<Map<String, String>> _studentFilter(List students, String number) {
    List<Map<String, String>> search = [];
    for (int i = 0; i < students.length; i++) {
      if (students[i]['studentNum'].toString().startsWith(number)) {
        search.add(students[i]);
      }
    }
    setState(() {
      _filter = search;
    });
    return search;
  }

  List<Map<String, dynamic>>? _filter;
  List<Map<String, dynamic>>? _students;

  Future _getAttendance(String lecture, String subject) async {
    _students = await Provider.of<SubjectLectures>(context, listen: false)
        .getLectureAttendance(subject, lecture);
    _filter = _students!;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> lectureData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${lectureData['lectureName']}',
          style: TextStyle(
              color: Color(0xff222831),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
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
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xffEEEEEE), width: 1),
                    //color: Color(0xffEEEEEE),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      hintText: 'Search by student number',
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _studentFilter(_students!, value);
                      } else {
                        setState(() {
                          _filter = _students;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              //margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              decoration: BoxDecoration(
                color: Colors.white,
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
                  )),
                  Expanded(
                      child: Text(
                    'Date',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  )),
                  Expanded(
                    child: Text(
                      'Scans',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: _getAttendance(
                    lectureData['lectureName'], lectureData['subject']),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  return ListView.builder(
                    itemCount: _filter!.length,
                    itemBuilder: (ctx, i) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                        decoration: BoxDecoration(
                          //borderRadius: BorderRadius.circular(20),
                          color: i % 2 == 0 || i == 0
                              ? Colors.white
                              : Color(0xffEEEEEE),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Text(
                              '${_filter![i]['studentNum']}',
                              textAlign: TextAlign.left,
                            )),
                            Expanded(
                                child: Text(
                              '${_filter![i]['studentName']}',
                              textAlign: TextAlign.left,
                            )),
                            Expanded(
                                child: Text(
                              '${_filter![i]['date']}',
                              textAlign: TextAlign.left,
                            )),
                            Expanded(
                              child: Text(
                                '${_filter![i]['scans']}',
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
