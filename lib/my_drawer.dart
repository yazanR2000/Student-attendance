import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './screens/my_subjects_screen.dart';
import './screens/home_screen.dart';
import './providers/auth.dart';
import 'package:provider/provider.dart';
import './side_bar.dart';

//enum SideBar { Dashboard, My_Subjects, LogOut }
class MyDrawer extends StatefulWidget {
  final SideBar _sideBar;
  final Function _changeScreen;

  MyDrawer(this._changeScreen, this._sideBar);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  Container _sideContainer = Container(
    height: 40,
    width: 3,
    decoration: BoxDecoration(
      color: Color(0xff222831),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(10),
        bottomRight: Radius.circular(10),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            children: [
              Row(
                children: [
                  if (widget._sideBar == SideBar.Dashboard)
                    _sideContainer,
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.home),
                      title: Text('DASHBOARD'),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (widget._sideBar != SideBar.Dashboard)
                          widget._changeScreen(SideBar.Dashboard);
//                    setState(() {
//                      widget._sideBar = SideBar.Dashboard;
//                    });
                      },
                    ),
                  ),
                ],
              ),
              //Divider(),
              Row(
                children: [
                  if (widget._sideBar == SideBar.My_Subjects)
                    _sideContainer,
                  Expanded(
                    child: ListTile(
                      leading: Icon(Icons.subject),
                      title: Text('MY SUBJECTS'),
                      onTap: () {
                        Navigator.of(context).pop();
                        if (widget._sideBar != SideBar.My_Subjects)
                          widget._changeScreen(SideBar.My_Subjects);
//                    setState(() {
//                      widget._sideBar = SideBar.My_Subjects;
//                    });
                      },
                    ),
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('LOG OUT'),
                onTap: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          title: Text('Log out'),
                          content: Text('Do you want to log out ?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                                Provider.of<Auth>(context, listen: false)
                                    .logout();
                              },
                              child: Text('YES'),
                              //style: TextButton.styleFrom(primary: Color(0xff222831)),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text('NO'),
                              //style: TextButton.styleFrom(primary: Colors.red),
                            ),
                          ],
                        );
                      });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
