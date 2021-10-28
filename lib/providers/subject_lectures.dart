import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class SubjectLectures with ChangeNotifier {
  List<Map<String, dynamic>> _lectures = [];
  final _fireUrl = 'https://qr-react-default-rtdb.firebaseio.com/';

  List get lectures {
    return _lectures;
  }

  Future<List<Map<String, dynamic>>?> getLectures(
      String tableName, String doctorId) async {
    _lectures.clear();
    final url = _fireUrl + 'doctors/$doctorId/$tableName/lectures/.json';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final data = json.decode(response.body) as Map<String, dynamic>;
      print(data);
      if (data.isNotEmpty) {
        data.forEach((key, value) {
          final Map<String, dynamic> lecture = {
            'Lecture_name': key,
            'startsIn': value['startsIn'],
            'endsIn': value['endsIn'],
            'type': value['type'],
            'attendance_NO': value['attendance_NO'],
            'qrCode': value['qrCode'],
          };
          _lectures.add(lecture);
        });
      }
      return _lectures;
    } catch (err) {
      print(err);
    }
  }

  Future addNewLecture(String tableName, String lectureName, String endTime,
      String startTime, String type, String qrCode, String doctorId) async {
    //final url = _fireUrl + 'doctors/$doctorId/$tableName/Lectures.json';
    //final updateAndPushUrl = _fireUrl + '$tableName/.json';
    final addNewLectureUrl =
        _fireUrl + 'doctors/$doctorId/$tableName/lectures/$lectureName/.json';
    //final pushLectureUrl = _fireUrl + 'doctors/$doctorId/$tableName.json';
    try {
//      final lectures = await http.get(
//        Uri.parse(url),
//      );
//      String lectureData =
//          json.decode(lectures.body) == null ? '' : json.decode(lectures.body);
//
//      //print(endDate);
//      lectureData += lectureData == ''
//          ? '$lectureName|${startTime}|${endTime}|$type|$qrCode'
//          : ',$lectureName|${startTime}|${endTime}|$type|$qrCode';
//      final update = await http.patch(
//        Uri.parse(updateAndPushUrl),
//        body: json.encode({'Lectures': lectureData}),
//      );
      final postAttendance = await http.patch(
        Uri.parse(addNewLectureUrl),
        body: json.encode(
          {
            'attendance_NO': 0,
            'startsIn': startTime,
            'endsIn': endTime,
            'type': type,
            'Lecture_name': lectureName,
            'qrCode': qrCode
          },
        ),
      );
//      final updateDoctor = await http.put(
//        Uri.parse(pushLectureUrl),
//        body: json.encode(
//          {'Lectures': lectureData},
//        ),
//      );
      notifyListeners();
    } catch (err) {
      print(err);
    }
  }

  Future<List<Map<String, dynamic>>?> getLectureAttendance(
      String subject, String lecture) async {
    print(subject);
    print(lecture);
    final url = _fireUrl + "$subject/Student_att/$lecture.json";
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      print(json.decode(response.body));
      if (json.decode(response.body) == null) return [];
      final resData = json.decode(response.body) as Map<String, dynamic>;
      List<Map<String, dynamic>> attendance = [];
      resData.forEach((key, value) {
        attendance.add({
          "studentName": key,
          "studentNum": value['number'],
          "scans": value['scans'],
          "date": value['Date']
        });
      });
      print(attendance);
      return attendance;
    } catch (err) {
      print(err);
    }
  }

  Future deleteLecture(
      String subject, String doctorId, String lectureName) async {
    final url =
        _fireUrl + 'doctors/$doctorId/$subject/lectures/$lectureName.json';
    final deleteFromSubject =
        _fireUrl + '$subject/Student_att/$lectureName.json';
    try {
      final response = await http.delete(
        Uri.parse(url),
      );
      final resFromSubject = await http.delete(
        Uri.parse(deleteFromSubject),
      );
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
}
