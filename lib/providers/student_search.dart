import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class StudentSearch with ChangeNotifier {
  List<Map<String, dynamic>> _students = [];
  final _fireUrl = 'https://qr-react-default-rtdb.firebaseio.com/';

  List<Map<String, dynamic>> get students {
    return _students;
  }
  void notify(){

    notifyListeners();
  }

  Future getStudent(String pattern) async {

    var url = _fireUrl;
    final regExp = new RegExp("[0-9]");
    if (regExp.hasMatch(pattern)) {
      print('case:1');
      url += 'students/.json?orderBy="gmail"&startAt="$pattern"';
    } else {
      print('case:2');
      pattern = pattern[0].toUpperCase() + pattern.substring(1);

      url += 'students/.json?orderBy="name"&startAt="$pattern"';
    }
    print(pattern);

    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final responseData = json.decode(response.body) as Map<String,dynamic>;
      //print(responseData);
      if(_students.length != 0){
        _students.clear();
      }
      responseData.forEach((key, value) {
        final student = {
          'pic' : value["profile_picture"],
          'id' : value["gmail"],
          'name' : value["name"]
        };
        _students.add(student);
      });


    } catch (err) {
      print(err);
    }
  }
}
