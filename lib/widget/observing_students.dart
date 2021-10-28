import 'package:flutter/material.dart';
import '../screens/student_attendance_screen.dart';
import 'package:provider/provider.dart';
import '../providers/student_attendance.dart';
import '../providers/observing_students.dart' as observing;
import '../providers/subjects.dart';
import '../dummy_data.dart';
class ObservingStudents extends StatelessWidget {
  final List<Map<String,String>> _students = Dummy().students;
  @override
  Widget build(BuildContext context) {
    final obsStd =
        Provider.of<observing.ObservingStudents>(context, listen: false);
    final doc_id = Provider.of<Subjects>(context, listen: false).UserId;
    return Expanded(
      flex: 1,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 200,
        decoration: BoxDecoration(
          color: Color(0xffE4EFE7),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FittedBox(
              child: Text(
                'Observing Students',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Expanded(
              child: FutureBuilder(
                future: obsStd.getObservingStudents(doc_id),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  final obsData = obsStd.observingStd;
                  return ListView.builder(
                    itemCount: _students.length,
                    itemBuilder: (ctx, index) {
                      return TextButton.icon(
                        style: TextButton.styleFrom(
                            alignment: Alignment.centerLeft),
                        onPressed: () async {
                          Navigator.of(context).pushNamed(
                            StudentAttendanceScreen.routeName,
                            arguments: _students[index]['studentNum'],
                          );
                        },
                        label: Text(
                          _students[index]['studentName']!,
                          overflow: TextOverflow.ellipsis,
                        ),
                        icon: Icon(Icons.person_outline),
                      );
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 5,
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
