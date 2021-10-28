import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'dart:math';
class LiveLecture with ChangeNotifier {
  Map<String, dynamic> _info = {
    'Lecture_Name': null,
    'Subject_Name': null,
    'type': null,
    'sub_type': null,
    'endIn': null,
    'full_subject' : null,
    'firstQr' : {
      'hour' : 0,
      'minute' : 0
    },
    'secondQr' : {
      'hour' : 0,
      'minute' : 0
    },
  };
  List<Map<String, dynamic>> _attendance = [];
  bool _isFetch = false;
  bool _isFetchAtt = false;
  bool get isFetch{
    return _isFetch;
  }
  bool get isFetchAtt{
    return _isFetchAtt;
  }
  void toggleFetch(){
    _isFetch = false;
  }
  void toggleFetchAtt(){
    _isFetchAtt = false;
    notifyListeners();
  }

  final _fireUrl = 'https://qr-react-default-rtdb.firebaseio.com/';

  Map<String, dynamic> get lectureName {
    return _info;
  }
  List<Map<String, dynamic>> get attendance {
    return _attendance;
  }

  Future getLiveLecture(String doctorId) async {
    final url = _fireUrl + 'doctors/$doctorId/.json';
    _info['Lecture_Name'] = _info['Subject_Name'] = null;
    try {
      final response = await http.get(Uri.parse(url));

      final responseData = json.decode(response.body) as Map<String,dynamic>;

      //print(responseData);

      final date = new DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.now());
      //print(date);
      responseData.forEach((key, value) {
        final subject = key.toString().split(',');

        Map<String,dynamic> lectures = value['lectures'];

        lectures.forEach((lectureName, value) {
          if(value['startsIn'].substring(0, 11).compareTo(date.substring(0, 11)) == 0){
            final nowDateStart = date.substring(11);
            final lectureStart =value['startsIn'].substring(11);
            final lectureEnd = value['endsIn'].substring(11);
            if (nowDateStart.compareTo(lectureStart) >= 0 &&
                nowDateStart.compareTo(lectureEnd) < 0) {
              _info['Lecture_Name'] = lectureName;
              _info['endIn'] = value['endsIn'];
              _info['type'] = value['type'];
              _info['sub_type'] = value['qrCode'];
              _info['Subject_Name'] = subject[2] + ' ' + subject[3];
              _info['full_subject'] = key;


              int rndNum = int.parse(_info['sub_type']!.substring(6,8));
              var random = new Random();
              var firstRnd = 2;
              var secondRnd = 2;
//                print(firstRnd);
//                print(secondRnd);
              String startDate = value['startsIn'].substring(11);
              String endDate = value['endsIn'].substring(11);
              int mainStartHour;
              int mainStartMinute;

              int mainEndHour;
              int mainEndMinute;

              if (startDate[0] == '0') {
                mainStartHour = int.parse(startDate.substring(1, 2));
              } else {
                mainStartHour = int.parse(startDate.substring(0, 2));
              }
              if (startDate[3] == '0') {
                mainStartMinute = int.parse(startDate.substring(4));
              } else {
                mainStartMinute = int.parse(startDate.substring(3));
              }

              if(firstRnd + mainStartMinute >= 60){
                mainStartHour++;
                if(mainStartHour == 24)
                  mainStartHour = 0;
                _info['firstQr']['hour'] = mainStartHour;
                _info['firstQr']['minute'] = ((firstRnd + mainStartMinute) - 60).abs();
              }else{
                _info['firstQr']['hour'] = mainStartHour;
                _info['firstQr']['minute'] = firstRnd + mainStartMinute;
              }

              if (endDate[0] == '0') {
                mainEndHour = int.parse(endDate.substring(1, 2));
              } else {
                mainEndHour = int.parse(endDate.substring(0, 2));
              }
              if (endDate[3] == '0') {
                mainEndMinute = int.parse(endDate.substring(4));
              } else {
                mainEndMinute = int.parse(endDate.substring(3));
              }
              if( mainEndMinute - secondRnd <= 0){
                mainEndHour--;
                if(mainEndHour < 0)
                  mainEndHour = 23;
                _info['secondQr']['hour'] = mainEndHour;
                _info['secondQr']['minute'] = 60 - (secondRnd - mainEndMinute);
              }else{
                _info['secondQr']['hour'] = mainEndHour;
                _info['secondQr']['minute'] = mainEndMinute - secondRnd;
              }

              _isFetch = true;
              return;
            }
          }else{
          }
        });



//        if (value['lectures'].toString() != "") {
//
//          final lectures = value['Lectures'].toString().split(',');
//          for (int i = 0; i < lectures.length; i++) {
//            final List<String> dates = lectures[i].split('|');
//            print(dates);
//            if (dates[1].substring(0, 11).compareTo(date.substring(0, 11)) ==
//                0) {
//              //print('yes');
//
//            } else {
//              //print('no');
//            }
//          }
//        }
      });
    } catch (err) {
      print(err);
    }
  }

  Future getLiveLectureAttendance(String subject, String lecture) async {
    final url = _fireUrl + "$subject/Student_att/$lecture.json";
    _attendance.clear();
    try {
      final response = await http.get(
        Uri.parse(url),
      );
      print(json.decode(response.body));
      _isFetchAtt = true;
      final resData = json.decode(response.body) as Map<String,dynamic>;

      resData.forEach((key, value) {
        _attendance.add({
          'studentName' : key,
          'studentNum' : value['number'],
          'date' : value['Date'],
          'scans' : value['scans'],
        });
      });

    } catch (err) {
      print(err);
    }
  }
}
