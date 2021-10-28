import 'package:flutter/material.dart';
import 'package:flutter_app_desk/providers/show_qr_code.dart';
import './add_subject_dialog.dart';
import './add_lecture_dialog.dart';
import 'package:provider/provider.dart';
import '../providers/student_search.dart';
import '../screens/student_attendance_screen.dart';

class QuickAccessTools extends StatefulWidget {
  @override
  State<QuickAccessTools> createState() => _QuickAccessToolsState();
}

class _QuickAccessToolsState extends State<QuickAccessTools> {
  TextEditingController _searchController = TextEditingController();

  FocusNode _focus = new FocusNode();

  @override
  void initState() {
    super.initState();

    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    super.dispose();
    _focus.removeListener(() {});
    _focus.dispose();
    _searchController.dispose();
  }

  void _onFocusChange() {
    if (_focus.hasFocus && _searchController.text.isNotEmpty) {
      setState(() {
        _showSearchResult = true;
      });
    } else {
//      setState(() {
//        _showSearchResult = false;
//      });
    }
  }

  bool _showSearchResult = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 200,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: Color(0xffFAF1E6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FittedBox(
                    child: Text(
                      'Quick Access Tools',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AddSubjectDialog());
                    },
                    child: FittedBox(child: Text('Add new subject')),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        elevation: 0, primary: Color(0xff393E46)),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (ctx) => AddLectureDialog(context));
                    },
                    child: FittedBox(child: Text('Add new Lecture')),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: TextField(
                      focusNode: _focus,
                      controller: _searchController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search for a student',
                        hintStyle: TextStyle(fontSize: 12),
                        isDense: true,
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            _showSearchResult = true;
                          });
                          Provider.of<StudentSearch>(context, listen: false)
                              .notify();
                        } else {
                          setState(() {
                            _showSearchResult = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_showSearchResult)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 25,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black12,
                          offset: Offset(3, 3),
                          blurRadius: 15,
                          spreadRadius: 5),
                    ],
                  ),
                  constraints: BoxConstraints(
                    minHeight: 50,
                    maxHeight: 150,
                  ),
                  child: FutureBuilder(
                    future: Provider.of<StudentSearch>(context)
                        .getStudent(_searchController.text),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      List<Map<String, dynamic>> _students =
                          Provider.of<StudentSearch>(context, listen: false)
                              .students;
                      return Column(
                        children: [
                          _students.length == 0
                              ? Expanded(
                                  child: Center(
                                    child: FittedBox(
                                      child: Text('No students found'),
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: ListView.builder(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 5,
                                    ),
                                    itemCount: _students.length,
                                    itemBuilder: (ctx, i) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        child: TextButton.icon(
                                          style: TextButton.styleFrom(
                                              alignment: Alignment.centerLeft),
                                          onPressed: () {
                                            final stdNumber = _students[i]['id']
                                                .toString()
                                                .substring(0, 10);
                                            Navigator.of(context).pushNamed(
                                              StudentAttendanceScreen.routeName,
                                              arguments: stdNumber
                                            );
                                          },
                                          label: Text(
                                            _students[i]['name'],
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          icon: CircleAvatar(
                                            backgroundImage: NetworkImage(
                                                _students[i]['pic']),
                                            radius: 10,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                primary: Color(0xff00ADB5),
                                padding: EdgeInsets.all(0)),
                            onPressed: () {
                              setState(() {
                                _showSearchResult = false;
                              });
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
