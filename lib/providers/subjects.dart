import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Subjects with ChangeNotifier {
  String? userId;
  bool _isFetch = false;
  bool get isFetch{
    return _isFetch;
  }
  final _fireUrl =
      'https://qr-react-default-rtdb.firebaseio.com/';
  List doctor_subject = [];



  Subjects({this.userId}) {
    print(userId);
  }

  String get UserId {
    return userId!;
  }

  List get subject {
    return doctor_subject;
  }

  Future addNewSubject(String table) async {
    final subject_url = _fireUrl + '$table.json';
    final doctor_url = _fireUrl + 'doctors/$userId/$table.json';
    try {
      final subject_response = await http.patch(
        Uri.parse(subject_url),
        body: json.encode({
          'creator': userId,
        }),
      );
      final doctor_response = await http.patch(
        Uri.parse(doctor_url),
        body: json.encode({
          'Lectures': '',
        }),
      );
      _isFetch = false;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  Future getDoctorSubjects() async {
    doctor_subject.clear();
    final url = _fireUrl + 'doctors/$userId.json';

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final resData = json.decode(response.body) as Map;
      resData.forEach((key, value) {
        doctor_subject.add(key);
      });
      print(doctor_subject);
      _isFetch = true;
    } catch (err) {
      print(err);
    }
  }
}
