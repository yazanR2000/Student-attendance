import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../providers/show_qr_code.dart';
import '../providers/live_lecture.dart';

class TimerLiveLecture extends StatefulWidget {
  final String endDate;

  TimerLiveLecture(this.endDate);

  @override
  _TimerLiveLectureState createState() => _TimerLiveLectureState();
}

class _TimerLiveLectureState extends State<TimerLiveLecture> {
  int _hours = 0;
  int _minutes = 0;
  int _seconds = 0;
  Timer? _timer;
  Map<String,dynamic> firstRnd = {};
  Map<String,dynamic> secondRnd = {};

  void _startTimer() {
    var qr = Provider.of<LiveLecture>(context, listen: false).lectureName;
    firstRnd = qr['firstQr'];
    secondRnd = qr['secondQr'];

    final hours = DateTime.now().hour;
    final minutes = DateTime.now().minute;
    final seconds = DateTime.now().second;
    print(qr);
    int mainHours;
    int mainMinutes;
    if (widget.endDate[0] == '0') {
      mainHours = int.parse(widget.endDate.substring(1, 2));
    } else {
      mainHours = int.parse(widget.endDate.substring(0, 2));
    }
    if (widget.endDate[3] == '0') {
      mainMinutes = int.parse(widget.endDate.substring(4));
    } else {
      mainMinutes = int.parse(widget.endDate.substring(3));
    }
    _hours = (hours - mainHours).abs();
    if (mainMinutes - minutes < 0) {
      --_hours;
      _minutes = 60 - minutes + mainMinutes;
    } else {
      _minutes = mainMinutes - minutes;
    }
    _seconds = seconds;

    const oneSec = const Duration(seconds: 1);

    _timer = new Timer.periodic(oneSec, (timer) {
      var currentHour = DateTime.now().hour;
      var currentMinute = DateTime.now().minute;
      var currentSecond = DateTime.now().second;
      if ((currentHour == firstRnd['hour'] &&
              currentMinute == firstRnd['minute'] && currentSecond == 1) ||
          (currentHour == secondRnd['hour'] &&
              currentMinute == secondRnd['minute']  && currentSecond == 1 )) {
        setState(() {
          timer.cancel();
        });
        Provider.of<ShowQrCode>(context,listen: false).testWindowFunctions();
      }
      if (_seconds - 1 < 0) {
        if (_minutes - 1 < 0) {
          if (_hours - 1 < 0) {
            Provider.of<LiveLecture>(context,listen: false).toggleFetch();
            Provider.of<LiveLecture>(context,listen: false).toggleFetchAtt();
            setState(() {
              timer.cancel();
            });
          } else {
            setState(() {
              _seconds = 59;
              _minutes = 59;
              --_hours;
            });
          }
        } else {
          setState(() {
            _seconds = 59;
            --_minutes;
          });
        }
      } else {
        setState(() {
          --_seconds;
        });
      }
    });
//    print('endDate : ${widget.endDate}');
//    print(mainHours);
//    print(mainMinutes);
//    print('..............');
//    print(_hours);
//    print(_minutes);
//    print(_seconds);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _startTimer();
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: Color(0xff393E46),
      labelStyle: TextStyle(color: Colors.white),
      avatar: Icon(
        Icons.timer,
        color: Colors.white,
        size: 20,
      ),
      label: Container(
        width: 50,
        child: FittedBox(
          child: Text(
              '${_hours < 10 ? '0$_hours' : _hours}:${_minutes < 10 ? '0$_minutes' : _minutes}:${_seconds < 10 ? '0$_seconds' : _seconds}'),
        ),
      ),
    );
  }
}
