import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';

enum Colleges {
  Hijjawi,
  Faculty_of_medicine,
}

class NewSubjectsScreen extends StatefulWidget {
  static const routeName = 'New Subject Screen';

  @override
  State<NewSubjectsScreen> createState() => _NewSubjectsScreenState();
}

class _NewSubjectsScreenState extends State<NewSubjectsScreen> {
  TextEditingController _controller = TextEditingController();
  String? _character = 'Hijjawi';
  String? _character1 = 'CPE';
  String? _character2 = 'CPE 252';
  String? table;
  bool _isLoading = false;
  List<String> _stages = [
    'Colleges',
    'Sections',
    'Subject Number',
    'Code',
  ];
  String _state = 'Colleges';
  int _index = 0;
  List<String> _colleges = [
    'Hijjawi',
    'Faculty of medicine',
  ];
  List<String> _sections = [
    'CPE',
    'EPE',
    'ELE',
    'CME',
  ];
  List<String> _subjectNum = [
    'CPE 252',
    'CPE 450',
    'CPE 312',
    'CPE 560',
  ];

  @override
  void initState() {
    table = _character! +
        ',' +
        _character1! +
        ',' +
        _character2! +
        _controller.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'New Subject',
          style: TextStyle(color: Colors.black),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
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
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: Color(0xffEEEEEE),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                _index == 0 ? 'College' : '$_character',
                                style: TextStyle(
                                  color: _state == _stages[0]
                                      ? Color(0xffEEEEEE)
                                      : Color(0xff222831),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: _state == _stages[0]
                                  ? Color(0xff393E46)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                _index == 1
                                    ? 'Section'
                                    : _index > 1
                                        ? '$_character1'
                                        : 'Section',
                                style: TextStyle(
                                    color: _state == _stages[1]
                                        ? Color(0xffEEEEEE)
                                        : Color(0xff222831),),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: _state == _stages[1]
                                  ? Color(0xff393E46)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                _index == 2
                                    ? 'Subject Number'
                                    : _index > 2
                                        ? '$_character2'
                                        : 'Subject Number',
                                style: TextStyle(
                                  color: _state == _stages[2]
                                      ? Color(0xffEEEEEE)
                                      : Color(0xff222831),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: _state == _stages[2]
                                  ? Color(0xff393E46)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: Center(
                              child: Text(
                                _index == 3
                                    ? 'Division No'
                                    : _index > 3
                                        ? '1'
                                        : 'Division No',
                                style: TextStyle(
                                  color: _state == _stages[3]
                                      ? Color(0xffEEEEEE)
                                      : Color(0xff222831),
                                ),
                              ),
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: _state == _stages[3]
                                  ? Color(0xff393E46)
                                  : Colors.transparent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.topLeft,
                      child: _state == _stages[0]
                          ? ListView.builder(
                              padding: EdgeInsets.only(top: 10),
                              itemCount: _colleges.length,
                              itemBuilder: (ctx, i) {
                                return RadioListTile<String>(
                                  title: Text(_colleges[i]),
                                  value: _colleges[i],
                                  groupValue: _character,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _character = value;
                                    });
                                  },
                                );
                              })
                          : _state == _stages[1]
                              ? ListView.builder(
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: _sections.length,
                                  itemBuilder: (ctx, i) {
                                    return RadioListTile<String>(
                                      title: Text(_sections[i]),
                                      value: _sections[i],
                                      groupValue: _character1,
                                      onChanged: (String? value) {
                                        setState(() {
                                          _character1 = value;
                                        });
                                      },
                                    );
                                  })
                              : _state == _stages[2]
                                  ? ListView.builder(
                                      padding: EdgeInsets.only(top: 10),
                                      itemCount: _subjectNum.length,
                                      itemBuilder: (ctx, i) {
                                        return RadioListTile<String>(
                                          title: Text(_subjectNum[i]),
                                          value: _subjectNum[i],
                                          groupValue: _character2,
                                          onChanged: (String? value) {
                                            setState(() {
                                              _character2 = value;
                                            });
                                          },
                                        );
                                      })
                                  : Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 30),
                                      child: Row(
                                        children: [
                                          Text('Division NO :'),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              color: Colors.grey.shade100,
                                              child: TextField(
                                                controller: _controller,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20, left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(
                            Icons.arrow_back,
                            size: 12,
                          ),
                          onPressed: _index > 0
                              ? () {
                                  setState(() {
                                    --_index;
                                    if (_index < 0) {
                                      _index = 0;
                                    }
                                    _state = _stages[_index];
                                  });
                                }
                              : null,
                          label: Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            final index = _index + 1;
                            setState(() {
                              ++_index;
                              if (_index > 3) {
                                _isLoading = true;
                                _index = 0;
                              }
                              _state = _stages[_index];
                              table = _character! +
                                  ',' +
                                  _character1! +
                                  ',' +
                                  _character2! +
                                  ',' +
                                  _controller.text;
                            });
                            if (index > 3 && _controller.text.isNotEmpty) {
                              await Provider.of<Subjects>(context,
                                      listen: false)
                                  .addNewSubject(table!);
                              setState(() {
                                _isLoading = false;
                              });

                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    return Dialog(
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Container(
                                          height: 200,
                                          width: 200,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                margin:
                                                    EdgeInsets.only(bottom: 10),
                                                child: Center(
                                                  child: Image.network(
                                                    'https://icon-library.com/images/success-icon-png/success-icon-png-8.jpg',
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                'New Subject Added Successfully.',
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                          child: Row(
                            children: [
                              Text(_index == 3 ? 'Done' : 'Next'),
                              if (_index != 3)
                                SizedBox(
                                  width: 10,
                                ),
                              if (_index != 3)
                                Icon(
                                  Icons.arrow_forward,
                                  size: 12,
                                )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
