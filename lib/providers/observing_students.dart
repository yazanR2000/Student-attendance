import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ObservingStudents with ChangeNotifier {
  List<Map<String, dynamic>> _observingStd = [];
  final _fireUrl = 'https://qr-react-default-rtdb.firebaseio.com/';

  List<Map<String, dynamic>> get observingStd {
    return _observingStd;
  }

  Future getObservingStudents(String doctorId) async {
    final url = _fireUrl + "doctors/$doctorId/Observing_std.json";

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      print(json.decode(response.body));
      final Map<String,dynamic>? resData = json.decode(response.body) as Map<String,dynamic>?;
      if(resData != null){
        resData.forEach((key, value) {
          _observingStd.add(value);
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Future addStudent(Map<String, dynamic> student, String doctorId,Map<String,dynamic> studentData) async {
    final url = _fireUrl + "doctors/$doctorId/Observing_std.json";
    try {
      final response = await http.patch(
        Uri.parse(url),
        body: json.encode({
          'studentName' : studentData['studentName'],
          'studentNumber' : studentData['studentNumber'],
          'student_pic' : studentData['student_pic'],
        }),
      );
      print(json.decode(response.body));
    } catch (err) {
      print(err);
    }
  }
}
