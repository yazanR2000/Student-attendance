import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class StudentAttendance with ChangeNotifier {
  final _fireUrl = 'https://qr-react-default-rtdb.firebaseio.com/';
  Future<bool?> getStudentAttendanceForSubject(
      String subject, String studentNumber,String lectureName) async {
    final url = _fireUrl +
        '$subject/Student_att/$lectureName.json?orderBy="number"&equalTo="$studentNumber"';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      //print(json.decode(response.body));
      final _attend = json.decode(response.body) as Map<String,dynamic>;
      return _attend.isNotEmpty;
    } catch (err) {
      print(err);
    }
  }
}
