import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Chart with ChangeNotifier {
  List<Map<String, Map<String, int>>> _list = [];
  bool _isFetch = false;
  bool get isFetch{
    return _isFetch;
  }
  void notify(){
    notifyListeners();
  }

  void toggleFetch(){
    _isFetch = false;
  }
  List get list {
    return _list;
  }
  final _fireUrl =
      'https://qr-react-default-rtdb.firebaseio.com/';

  Future getAttendance(String doctorId) async {
    //print(doctorId);
    _list.clear();
    var url = _fireUrl + 'doctors/$doctorId/.json';
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      final subjects = json.decode(response.body) as Map<String, dynamic>;
      print(subjects);
      subjects.forEach((key, value) {

        Map<String,dynamic> lectures = value['lectures'] == null ? {} : value['lectures'];
        List<Map<String,dynamic>> _lectures = [];

        lectures.forEach((key, value) {
          _lectures.add(value);
        });

        Map<String,int> attendance = {};
        int i = _lectures.length - 1;
        print(i);
        int count = 5;
        while(count != 0 && i >=0){
          attendance.putIfAbsent(_lectures[i]['Lecture_name'], () => _lectures[i]['attendance_NO']);
          count--;
          i--;
        }
        _list.add(
          {
            "$key": attendance,
          },
        );
      });
      _isFetch = true;
      //print(_list);
    } catch (err) {
      print(err);
    }
  }
}
