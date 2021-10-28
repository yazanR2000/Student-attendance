import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_desk/providers/live_lecture.dart';
import 'package:flutter_app_desk/screens/my_subjects_screen.dart';

import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import './dashboard_screen.dart';
import './logout_screen.dart';
import '../providers/auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/show_qr_code.dart';

import 'package:responsive_builder/responsive_builder.dart';
import '../my_drawer.dart';
import '../side_bar.dart';
import '../widget/qr_code.dart';
//enum SideBar { Dashboard, My_Subjects, LogOut }

class HomeScreen extends StatefulWidget {
  static const routeName = 'Home Screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SideBar _sideBar = SideBar.Dashboard;
  void _changeScreen(SideBar screen){
    setState(() {
      _sideBar = screen;
    });
  }
  @override
  Widget build(BuildContext context) {
    final id = Provider.of<Subjects>(context, listen: false).userId;
    final showQr = Provider.of<ShowQrCode>(context);
    final qr = Provider.of<LiveLecture>(context, listen: false).lectureName;
    //print(id);
    return ResponsiveBuilder(
      builder: (ctx, constraints) {

        return Scaffold(
          backgroundColor: showQr.show ? Colors.white : Color(0xff222831),
          drawer: constraints.screenSize.width <= 1000 && !showQr.show ? MyDrawer(_changeScreen,_sideBar) : null,
          appBar: constraints.screenSize.width <= 1000 && !showQr.show ? AppBar(
            //backgroundColor: Colors.white,
            //iconTheme: IconThemeData(color: Colors.black),
            elevation: 0.5,
          ) : null,
          body: showQr.show
              ? QrCode()
              : Padding(
                  padding:constraints.screenSize.width > 1000 ? EdgeInsets.only(top: 10, right: 10, bottom: 10) : EdgeInsets.zero,
                  child: Container(
                    height: double.infinity,
                    child: Row(
                      children: [
                        if (constraints.screenSize.width > 1000)
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Color(0xff222831),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      if (_sideBar == SideBar.Dashboard)
                                        Container(
                                          height: 40,
                                          width: 1,
                                          color: Color(0xffEEEEEE),
                                        ),
                                      Expanded(
                                        child: IconButton(
                                          tooltip: 'Dashboard',
                                          onPressed: () {
                                            if (_sideBar != SideBar.Dashboard)
                                              setState(() {
                                                _sideBar = SideBar.Dashboard;
                                              });
                                          },
                                          icon: Icon(
                                            Icons.home,
                                            color: Color(0xffEEEEEE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      if (_sideBar == SideBar.My_Subjects)
                                        Container(
                                          height: 40,
                                          width: 1,
                                          color: Color(0xffEEEEEE),
                                        ),
                                      Expanded(
                                        child: IconButton(
                                          tooltip: 'My subjects',
                                          onPressed: () {
                                            if (_sideBar != SideBar.My_Subjects)
                                              setState(() {
                                                _sideBar = SideBar.My_Subjects;
                                              });
                                          },
                                          icon: Icon(
                                            Icons.subject,
                                            color: Color(0xffEEEEEE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    children: [
                                      if (_sideBar == SideBar.LogOut)
                                        Container(
                                          height: 40,
                                          width: 1,
                                          color: Color(0xffEEEEEE),
                                        ),
                                      Expanded(
                                        child: IconButton(
                                          tooltip: 'Logout',
                                          onPressed: () async {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return AlertDialog(
                                                    title: Text('Log out'),
                                                    content: Text(
                                                        'Do you want to log out ?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                          Provider.of<Auth>(
                                                                  context,
                                                                  listen: false)
                                                              .logout();
                                                        },
                                                        child: Text('YES'),
                                                        //style: TextButton.styleFrom(primary: Color(0xff222831)),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('NO'),
                                                        //style: TextButton.styleFrom(primary: Colors.red),
                                                      ),
                                                    ],
                                                  );
                                                });
                                          },
                                          icon: Icon(
                                            Icons.logout,
                                            color: Color(0xffEEEEEE),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        Expanded(
                          flex: constraints.screenSize.width > 1000 ? 15 : 1,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:constraints.screenSize.width > 1000 ? BorderRadius.circular(20) : BorderRadius.zero,
                              color: Colors.white,
                            ),
                            child: _sideBar == SideBar.Dashboard
                                ? DashboardScreen(constraints.screenSize.width)
                                : _sideBar == SideBar.My_Subjects
                                    ? MySubjectsScreen(constraints.screenSize.width)
                                    : Container(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          //drawer: MyDrawer(),
        );
      },
    );
  }
}
