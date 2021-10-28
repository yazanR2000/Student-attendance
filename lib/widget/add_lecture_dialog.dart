import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import 'package:intl/intl.dart';
import '../providers/subject_lectures.dart';
import 'dart:async';

enum Stages { SubjectStage, LectureStage }

class AddLectureDialog extends StatefulWidget {
  final BuildContext _ctx;

  AddLectureDialog(this._ctx);

  @override
  _AddLectureDialogState createState() => _AddLectureDialogState();
}

class _AddLectureDialogState extends State<AddLectureDialog> {
  Stages _stages = Stages.SubjectStage;
  String _randomValue = 'First 10 minutes and last 10 minutes';
  String _notRandomValue = '10min';
  String timeValue = '10min';
  TimeOfDay? _timeEnd;
  TimeOfDay? _timeStart;
  String? _subject;
  TextEditingController _controller = TextEditingController();
  String? _type = 'Random';
  bool _success = true;

  Future _getSubjects() async {
    await Provider.of<Subjects>(context, listen: false).getDoctorSubjects();
  }

  bool _isLoading = false;
  bool can = true;
  List<String?> lecture = [];

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<Subjects>(context, listen: false).UserId;

    return AlertDialog(
      title: Text('New Lecture'),
      content: Container(
        height: 300,
        width: 200,
        child: _stages == Stages.SubjectStage
            ? FutureBuilder(
                future: _getSubjects(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final subjects =
                      Provider.of<Subjects>(context, listen: false).subject;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Select subject'),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 5 / 2,
                          ),
                          itemBuilder: (ctx, i) {
                            final subject = subjects[i].toString().split(",");
                            return ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                  _subject = subjects[i].toString();
                                });
                                await Provider.of<SubjectLectures>(context,
                                        listen: false)
                                    .getLectures(_subject!, userId);
                                setState(() {
                                  _isLoading = false;
                                  _stages = Stages.LectureStage;
                                });
                              },
                              child: FittedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'College : ${subject[0]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Section : ${subject[1]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Subject Number : ${subject[2]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Division No : ${subject[3]}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          itemCount: subjects.length,
                        ),
                      ),
                    ],
                  );
                })
            : _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Text(
                              'Lecture name :',
                              style: TextStyle(
                                color: Color(0xff222831),
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
                      Row(
                        children: [
                          Text('Qr Code type :'),
                          DropdownButton<String>(
                            value: _type,
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
                                _type = newValue!;
                              });
                            },
                            items: <String>['Random', 'Not Random']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      if (_type == 'Random')
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButton<String>(
                                menuMaxHeight: 150,
                                value: _randomValue,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
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
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      if (_type == 'Not Random')
                        Row(
                          children: [
                            Text('Show Every : '),
                            Expanded(
                              child: DropdownButton<String>(
                                menuMaxHeight: 200,
                                value: _notRandomValue,
                                icon: const Icon(Icons.arrow_downward),
                                iconSize: 20,
                                elevation: 16,
                                style:
                                    const TextStyle(color: Colors.deepPurple),
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
                                    child: Text(
                                      value,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      Row(
                        children: [
                          Text('Starts at :'),
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
                      Row(
                        children: [
                          Container(
                            child: Text('Ends in :'),
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
                    ],
                  ),
      ),
      actions: [
        if (_stages == Stages.LectureStage && !_isLoading)
          TextButton(
            onPressed: () async {
              can = true;
              DateTime startDate = DateTime.now().toLocal();
              startDate = new DateTime(
                startDate.year,
                startDate.month,
                startDate.day,
                _timeStart!.hour,
                _timeStart!.minute,
              );
              DateTime endDate = DateTime.now().toLocal();
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
              final format1 =
                  new DateFormat("yyyy-MM-dd HH:mm").format(startDate);
//              print(startDate);
//              print(endDate);
              setState(() {
                _isLoading = true;
              });

              final lectures =
                  Provider.of<SubjectLectures>(context, listen: false);
              print(lectures.lectures);
              for (int i = 0; i < lectures.lectures.length; i++) {
                if (format1.substring(0, 11) ==
                    lectures.lectures[i]['startsIn'].substring(0, 11)) {
                  //print('2');
                  var a = format1.substring(11);

                  var e = format.substring(11);
                  var b = lectures.lectures[i]['startsIn'].substring(11);
                  var s = lectures.lectures[i]['endsIn'].substring(11);
//                  print('a : $a e:$e b:$b s:$s');
//                  print('3');
                  if ((a.compareTo(b) <= 0 && e.compareTo(b) > 0) ||
                      (a.compareTo(b) >= 0 && a.compareTo(s) < 0) ||
                      (a.compareTo(s) > 0 &&
                          (e.compareTo(b) >= 0 && e.compareTo(s) < 0))) {
                    can = false;
                    //print('dates : $dates');
                    print('4');
                    lecture.add(lectures.lectures[i]['Lecture_name']);
                    lecture.add(lectures.lectures[i]['startsIn']);
                    lecture.add(lectures.lectures[i]['endsIn']);
                    break;
                  }
                }
              }
              if(!can){
                setState(() {
                  _isLoading = false;
                });
              }
              if (can) {
                await lectures.addNewLecture(
                  _subject!,
                  _controller.text,
                  format,
                  format1,
                  _type!,
                  _type == 'Random' ? _randomValue : _notRandomValue,
                  userId,
                );
                setState(() {
                  _isLoading = false;
                });
              }
              showDialog(
                  context: context,
                  builder: (ctx) {
                    return can
                        ? Dialog(
                            child: Container(
                              height: 100,
                              width: 100,
                              child: FutureBuilder(
                                future: Future.delayed(Duration(seconds: 1)),
                                builder: (ctx, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.done,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            '${_controller.text} Lecture Added Successfully'),
                                      ],
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    Navigator.of(context).pop();
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          )
                        : AlertDialog(
                            title: Text('Something went wrong!'),
                            content: Text(
                                'you have lecture name : ${lecture[0]}\n start at : ${lecture[1]}\n ends in : ${lecture[2]}\n'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('CANCEL'),
                              )
                            ],
                          );
                  });
            },
            child: Text('SAVE'),
          ),
        if (_stages == Stages.LectureStage && !_isLoading)
          TextButton(
            onPressed: () {
              setState(() {
                _stages = Stages.SubjectStage;
              });
            },
            child: Text('BACK'),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCEL'),
        ),
      ],
    );
  }
}
