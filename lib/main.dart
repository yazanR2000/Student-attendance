import 'package:flutter/material.dart';
import 'package:flutter_app_desk/screens/new_subject_screen.dart';
import './screens/home_screen.dart';

import './screens/auth_screen.dart';
import 'package:provider/provider.dart';
import './providers/auth.dart';
import './providers/subjects.dart';
import './providers/subject_lectures.dart';
import './screens/lectures_screen.dart';
import './screens/new_lecture_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import './screens/lecture_attendance_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import './providers/last_5_lectures_chart.dart';
import './providers/live_lecture.dart';
import './providers/student_search.dart';
import './screens/student_attendance_screen.dart';
import './providers/attendance_pdf.dart';
import './providers/student_attendance.dart';
import './providers/observing_students.dart';
import './providers/show_qr_code.dart';
import 'package:window_manager/window_manager.dart';

import './screen_size.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  SystemChrome.setEnabledSystemUIOverlays(
      [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  //WindowManager _windowManager = WindowManager.instance;
  windowManager.setTitle('Student Attendance');
  windowManager.waitUntilReadyToShow().then((_) async{
    // Set to frameless window

    Size size = await windowManager.getSize();
    ScreenSize().size = size;
    await windowManager.setMinimumSize(Size(540.0, size.height * 0.95));

    windowManager.show();
  });


  //print(await _windowManager.getSize());


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Init.instance.initialize(),
      builder: (ctx, snapshot) =>
          snapshot.connectionState == ConnectionState.waiting
              ? MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Splash(),
                )
              : MultiProvider(
                  providers: [
                    ChangeNotifierProvider.value(
                      value: Auth(),
                    ),
                    ChangeNotifierProvider.value(
                      value: SubjectLectures(),
                    ),
                    ChangeNotifierProvider.value(
                      value: Chart(),
                    ),
                    ChangeNotifierProvider.value(
                      value: LiveLecture(),
                    ),
                    ChangeNotifierProvider.value(
                      value: StudentSearch(),
                    ),
                    ChangeNotifierProvider.value(
                      value: AttendancePdf(),
                    ),
                    ChangeNotifierProvider.value(
                      value: StudentAttendance(),
                    ),
                    ChangeNotifierProvider.value(
                      value: ObservingStudents(),
                    ),
                    ChangeNotifierProvider.value(
                      value: ShowQrCode(),
                    ),
                    ChangeNotifierProxyProvider<Auth, Subjects>(
                      create: (ctx) => Subjects(),
                      update: (ctx, auth, _) => Subjects(userId: auth.userId),
                    ),
                  ],
                  child: Consumer<Auth>(
                    builder: (ctx, auth, _) {
                      return MaterialApp(
                        debugShowCheckedModeBanner: false,
                        title: 'Flutter Demo',
                        theme: ThemeData(
                          //primarySwatch: Color(0xff222831),
                          appBarTheme: AppBarTheme(
                            backgroundColor: Color(0xff393E46),
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xffEEEEEE),
                              primary: Color(0xff222831),
                            ),
                          ),
                          elevatedButtonTheme: ElevatedButtonThemeData(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff222831),
                            ),
                          ),
                          fontFamily: GoogleFonts.getFont('Rubik').fontFamily,
                        ),
                        home: auth.isAuth
                            ? HomeScreen()
                            : FutureBuilder(
                                future: auth.tryAutoLogin(),
                                builder: (context, authResultSnapshot) {
                                  print(authResultSnapshot);
                                  return authResultSnapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? Container()
                                      : AuthScreen();
                                },
                              ),
                        routes: {
                          'Home Screen': (ctx) => HomeScreen(),
                          //'My Subjects Screen': (ctx) => MySubjectsScreen(),
                          'New Subject Screen': (ctx) => NewSubjectsScreen(),
                          'Auth Screen': (ctx) => AuthScreen(),
                          'LecturesScreen': (ctx) => LecturesScreen(),
                          'NewLectureScreen': (ctx) => NewLectureScreen(),
                          'LectureAttendanceScreen': (ctx) =>
                              LectureAttendanceScreen(),
                          'StudentAttendanceScreen': (ctx) =>
                              StudentAttendanceScreen()
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash.png',height: 200,width: 180,),
            SizedBox(height: 20,),
            SpinKitThreeBounce(
              color: Color(0xff00ADB5),
            ),
          ],
        ),
      ),
    );
  }
}

class Init {
  Init._();

  static final instance = Init._();

  Future initialize() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(Duration(seconds: 3));
  }
}
