import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/live_lecture.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:async';
class QrCode extends StatefulWidget {
  @override
  _QrCodeState createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {

  int _seconds = 60;
  Timer? _timer;
  void _startTimer(){
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(oneSec, (timer) {
      setState(() {
        --_seconds;
        if(_seconds == 0) {
          //Provider.of<LiveLecture>(context,listen: false).toggleFetch();
          Provider.of<LiveLecture>(context,listen: false).toggleFetchAtt();
          _timer!.cancel ();
        }

      });
    });
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
    final qr = Provider.of<LiveLecture>(context, listen: false).lectureName;
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Scan to Attend',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Time left : ${_seconds}s'),
          SizedBox(height: 10,),
          QrImage(
            data:
            '${qr['full_subject']}|${qr['Lecture_Name']}|${qr['firstQr']['hour']}:${qr['firstQr']['minute']}|${qr['secondQr']['hour']}:${qr['secondQr']['minute']}',
            version: QrVersions.auto,
            size: 100.0,
          ),
        ],
      ),
    );
  }
}
