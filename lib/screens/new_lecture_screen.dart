import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import '../providers/subject_lectures.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

enum QrCodeType { Random, NotRandom }

class NewLectureScreen extends StatefulWidget {
  static const routeName = 'NewLectureScreen';

  @override
  _NewLectureScreenState createState() => _NewLectureScreenState();
}

class _NewLectureScreenState extends State<NewLectureScreen> {
  String _notRandomValue = '10min';
  String _randomValue = 'First 10 minutes and last 10 minutes';
  QrCodeType _type = QrCodeType.NotRandom;
  String? _character = 'Random';
  TimeOfDay? _timeStart;
  TimeOfDay? _timeEnd;
  TextEditingController _controller = TextEditingController();
  bool _success = true;
  bool _isLoading = false;

//  bool _isAfter(String endDate, String startDate) {
//    //print(date);
//
//    final aDate = endDate.substring(0, 11);
//    //print(aDate);
//    final am_pm1 = endDate.substring(11);
//    //final nowDate = DateTime.now();
//
//    final bDate = startDate.substring(0, 11);
//    final am_pm2 = startDate.substring(11);
//
//    //print('am_pm1 : $am_pm1 \n am_pm2 : $am_pm2 ');
//
//    if (aDate == bDate) {
//      //print('yes');
//      if(){
//        return true;
//      }
//      return false;
//    }else
//      return false;
//  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Subjects>(context, listen: false).UserId;
    final String? tableName =
        ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(context).pop();
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: SpinKitFadingCircle(
                color: Color(0xff00ADB5),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text(
                          'Lecture name :',
                          style: TextStyle(
                            color: _success ? Color(0xff222831) : Colors.red,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          onChanged: (value) {
                            if (value == '') {
                              setState(() {
                                _success = false;
                              });
                            } else {
                              setState(() {
                                _success = true;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text('Qr Code type :'),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Random'),
                          value: 'Random',
                          groupValue: _character,
                          onChanged: (String? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Not Random'),
                          value: 'Not Random',
                          groupValue: _character,
                          onChanged: (String? value) {
                            setState(() {
                              _character = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  if (_character == 'Random')
                    Row(
                      children: [
                        Container(
                          width: 200,
                          child: Text('Show QR code randomly :'),
                        ),
                        DropdownButton<String>(
                          value: _randomValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _randomValue = newValue!;
                            });
                          },
                          items: <String>[
                            'First 10 minutes and last 10 minutes',
                            'First 15 minutes and last 15 minutes',
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  if (_character == 'Not Random')
                    Row(
                      children: [
                        Container(
                          width: 200,
                          child: Text('Show QR code every :'),
                        ),
                        DropdownButton<String>(
                          value: _notRandomValue,
                          icon: const Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: const TextStyle(color: Colors.deepPurple),
                          underline: Container(
                            height: 2,
                            color: Colors.deepPurpleAccent,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              _notRandomValue = newValue!;
                            });
                          },
                          items: <String>[
                            '10min',
                            '15min',
                            '20min',
                            '25min',
                            '30min',
                            '35min',
                            '40min'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text('Lecture starts at :'),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: DateTime.now().hour,
                              minute: DateTime.now().minute,
                            ),
                            initialEntryMode: TimePickerEntryMode.input,
                          );
                          setState(() {
                            _timeStart = selectedTime;
                            print(_timeStart);
                            print(_timeStart!.hourOfPeriod);
                          });
                        },
                        icon: Icon(Icons.timelapse_outlined),
                        label: Text(_timeStart == null
                            ? 'Pick time'
                            : '${_timeStart!.hour}:${_timeStart!.minute}'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 200,
                        child: Text('Lecture end in :'),
                      ),
                      TextButton.icon(
                        onPressed: () async {
                          final selectedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                              hour: DateTime.now().hour,
                              minute: DateTime.now().minute,
                            ),
                            initialEntryMode: TimePickerEntryMode.input,
                          );
                          setState(() {
                            _timeEnd = selectedTime;
                            print(_timeEnd);
                            print(_timeEnd!.hourOfPeriod);
                          });
                        },
                        icon: Icon(Icons.timelapse_outlined),
                        label: Text(_timeEnd == null
                            ? 'Pick time'
                            : '${_timeEnd!.hour}:${_timeEnd!.minute}'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          onPressed: () {
                            print(_controller.text);
                            if (_controller.text == '') {
                              setState(() {
                                _success = false;
                              });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    bool can = true;
                                    Map<String,dynamic> lecture = {};
                                    return AlertDialog(
                                      title: Text('QR code'),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              _isLoading = true;
                                            });
                                            DateTime startDate =
                                                DateTime.now().toLocal();
                                            startDate = new DateTime(
                                              startDate.year,
                                              startDate.month,
                                              startDate.day,
                                              _timeStart!.hour,
                                              _timeStart!.minute,
                                            );
                                            DateTime endDate =
                                                DateTime.now().toLocal();
                                            endDate = new DateTime(
                                              startDate.year,
                                              startDate.month,
                                              startDate.day,
                                              _timeEnd!.hour,
                                              _timeEnd!.minute,
                                            );
                                            final format = new DateFormat(
                                              "yyyy-MM-dd HH:mm",
                                            ).format(endDate);
                                            final format1 = new DateFormat(
                                                    "yyyy-MM-dd HH:mm")
                                                .format(startDate);

                                            final lectures =
                                                Provider.of<SubjectLectures>(
                                                    context,
                                                    listen: false);
                                            for (int i = 0;
                                                i < lectures.lectures.length;
                                                i++) {
                                              final lec = lectures.lectures[i];
                                              //final dates = s.split('|');
                                              //print(dates);

                                              if (format1.substring(0, 11) ==
                                                  lec['startsIn']) {
                                                //print('2');
                                                var a = format1.substring(11);

                                                var e = format.substring(11);
                                                var b = lec['startsIn'].substring(11);
                                                var s = lec['endsIn'].substring(11);
                                                //print('a : $a e:$e b:$b s:$s');
                                                print('3');
                                                if ((a.compareTo(b) < 0 &&
                                                        e.compareTo(b) > 0) ||
                                                    (a.compareTo(b) > 0 &&
                                                        a.compareTo(s) < 0) ||
                                                    (a.compareTo(s) > 0 &&
                                                        (e.compareTo(b) >= 0 &&
                                                            e.compareTo(s) <
                                                                0))) {
                                                  can = false;
                                                  //print('dates : $dates');
                                                  lecture = lec;
                                                  break;
                                                }
                                              }
                                            }

                                            if (can)
                                              await lectures.addNewLecture(
                                                  tableName!,
                                                  _controller.text,
                                                  format,
                                                  format1,
                                                  _character!,
                                                  _character == 'Random'
                                                      ? _randomValue
                                                      : _notRandomValue,
                                                  userId);
                                            setState(() {
                                              _isLoading = false;
                                            });
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  can
                                                      ? '${_controller.text} Lecture added successfully!'
                                                      : 'Error! you have lecture name : ${lecture['Lecture_name']} start at : ${lecture['startsIn']} end in : ${lecture['endsIn']}',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                backgroundColor: can
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            );
                                          },
                                          child: Text('Save'),
                                        ),
                                        TextButton(
                                          onPressed: () {},
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                      content: Container(
                                        height: 200,
                                        width: 200,
                                        alignment: Alignment.center,
                                        child: QrImage(
                                          data:
                                              '${tableName}|${_controller.text}|${userId}',
                                          version: QrVersions.auto,
                                          size: 200.0,
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                          child: Text("Generate QR code"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
