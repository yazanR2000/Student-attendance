import 'package:flutter/material.dart';
import '../widget/subjects_chart.dart';
import '../widget/quick_access_tools.dart';
import '../widget/observing_students.dart';
import '../widget/live_lecture.dart';
import '../widget/print_the_attendance_schedule.dart';
import 'package:responsive_builder/responsive_builder.dart';

class DashboardScreen extends StatelessWidget {
  final double screenWidth;

  DashboardScreen(this.screenWidth);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 40,
          ),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: Color(0xff222831),
              fontSize: 30,
              fontWeight: FontWeight.bold,
              //fontFamily: GoogleFonts.getFont('Roboto').fontFamily,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: 0,
              horizontal: 40,
            ),
            child: Column(
              children: [
                if (screenWidth > 1000)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubjectsChart(3),
                      SizedBox(
                        width: 30,
                      ),
                      QuickAccessTools(),
                      SizedBox(
                        width: 20,
                      ),
                      ObservingStudents(),
                      SizedBox(
                        width: 20,
                      ),
                      PrintTheAttendanceSchedule(),
                    ],
                  ),

                if (screenWidth <= 1000)
                  Row(
                    children: [
                      QuickAccessTools(),
                      SizedBox(
                        width: 20,
                      ),
                      ObservingStudents(),
                      SizedBox(
                        width: 20,
                      ),
                      PrintTheAttendanceSchedule(),
                    ],
                  ),
                if (screenWidth <= 1000)
                  SizedBox(
                    height: 20,
                  ),
                if (screenWidth <= 1000)
                  Row(
                    children: [
                      SubjectsChart(1),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                if (screenWidth <= 1000)
                  Row(
                    children: [
                      LiveLectureWidget(1),
                    ],
                  ),

                if (screenWidth > 1000)
                  Row(
                    children: [
                      LiveLectureWidget(1),
//                      SizedBox(
//                        width: 20,
//                      ),
//                      Expanded(
//                        flex: 1,
//                        child: Container(
//                          height: 300,
//                          decoration: BoxDecoration(
//                            color: Colors.black,
//                            borderRadius: BorderRadius.circular(10),
//                          ),
//                        ),
//                      ),
                    ],
                  ),

              ],
            ),
          ),
        ),
      ],
    );
  }
}
