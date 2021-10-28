import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../my_drawer.dart';
import './new_subject_screen.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import '../providers/subject_lectures.dart';
import './lectures_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

class MySubjectsScreen extends StatelessWidget {
  static const routeName = 'My Subjects Screen';
  final double screenWidth;
  MySubjectsScreen(this.screenWidth);
  Future _fetchSubjects(BuildContext ctx) async {
    final isFetch = Provider.of<Subjects>(ctx).isFetch;
    return !isFetch
        ? Provider.of<Subjects>(ctx, listen: false).getDoctorSubjects()
        : Future.delayed(Duration(seconds: 0));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchSubjects(context),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitFadingCircle(
              color: Color(0xff00ADB5),
            ),
          );
        }
        final subjects =
            Provider.of<Subjects>(context, listen: false).doctor_subject;
        //print(subjects.length);
        return subjects.length == 0
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Subjects are empty!',
                      style: TextStyle(
                        //fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          NewSubjectsScreen.routeName,
                        );
                      },
                      child: Text('Add New Subject'),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My subjects',
                      style: TextStyle(
                        color: Color(0xff222831),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        //fontFamily: GoogleFonts.getFont('Roboto').fontFamily,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: screenWidth > 1000 ? 3 : 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 5 / 2,
                        ),
                        itemCount: subjects.length + 1,
                        itemBuilder: (ctx, i) {
                          if (i == subjects.length) {
                            return TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(NewSubjectsScreen.routeName),
                              child: Center(
                                child: Icon(Icons.add),
                              ),
//                    style: TextButton.styleFrom(
//                        backgroundColor: Colors.blue.shade50),
                            );
                          }
                          final subject = subjects[i].toString().split(",");
//                for(var i = 0;i<subject.length;i++){
//                  int index = subject[i].indexOf('|');
//                  print(index);
//                  subjects[i] = subject[i].substring(0,index);
//                }
                          //print(subject);

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(),
                            onPressed: () {
                              //Provider.of<SubjectLectures>(context,listen: false).getLectures(subjects[i].toString());
                              Navigator.of(context).pushNamed(
                                  LecturesScreen.routeName,
                                  arguments: subjects[i].toString());
                            },
                            child: FittedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'College : ${subject[0]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Section : ${subject[1]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Subject Number : ${subject[2]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 5,),
                                  Text(
                                    'Division No : ${subject[3]}',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
