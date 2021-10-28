import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AttendancePdf with ChangeNotifier {
  List<Map<String, List<Map<String, dynamic>>>> _attendance = [];
  List<Map<String,dynamic>> _lectureAttendance = [];
  final _fireUrl = 'https://qr-react-default-rtdb.firebaseio.com/';

  List<Map<String, List<Map<String, dynamic>>>> get Attendance {
    return _attendance;
  }

  List<Map<String,dynamic>> get LectureAttendance{
    return _lectureAttendance;
  }

  Future getAttendanceForSubject(String subject) async {
    _attendance.clear();
    final url = _fireUrl + '$subject/Student_att.json';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      print(json.decode(response.body));
      final resData = json.decode(response.body) as Map<String, dynamic>;
      resData.forEach((lectureName, students) {
        List<Map<String, dynamic>> att = [];
        students.forEach((studentName, value) {
          att.add({
            'studentName': studentName,
            'scans': value['scans'],
            'studentNum': value['number'],
            'date': value['Date'],
          });
        });
        _attendance.add({lectureName: att});
      });
      print(_attendance);
    } catch (err) {
      print(err);
    }
  }

  Future getAttendanceForLecture(String subject, String lecture) async {
    _lectureAttendance.clear();
    final url = _fireUrl + '$subject/Student_att/dsafas.json';

    try {
      final response = await http.get(
        Uri.parse(url),
      );

      final resData = json.decode(response.body) as Map<String,dynamic>;

      resData.forEach((studentName, data) {
        _lectureAttendance.add({
          'studentName': studentName,
          'scans': data['scans'],
          'studentNum': data['number'],
          'date': data['Date'],
        });
      });

    } catch (err) {
      print(err);
    }
  }
}
