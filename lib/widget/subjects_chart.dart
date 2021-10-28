import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app_desk/widget/add_subject_dialog.dart';
import './chart_last_5_lectures.dart';
import 'package:provider/provider.dart';
import '../providers/last_5_lectures_chart.dart';
import '../providers/subjects.dart';
import '../providers/last_5_lectures_chart.dart';
import './add_subject_dialog.dart';

class SubjectsChart extends StatefulWidget {
  final int _flex;

  SubjectsChart(this._flex);

  @override
  _SubjectsChartState createState() => _SubjectsChartState();
}

class _SubjectsChartState extends State<SubjectsChart> {
  Future _getAttendance() async {
    bool isFetch = Provider.of<Chart>(context).isFetch;
    if (!isFetch)
      await Provider.of<Chart>(context, listen: false).getAttendance(
        Provider.of<Subjects>(context, listen: false).UserId,
      );
  }

  final CarouselController buttonCarouselController = CarouselController();
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final subjects = Provider.of<Chart>(context, listen: false).list;
    return Expanded(
      flex: widget._flex,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
        height: 200,
        decoration: BoxDecoration(
          color: Color(0xffFDFAF6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: FutureBuilder(
          future: _getAttendance(),
          builder: (ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : subjects.isEmpty
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('You don\'t have any subject yet Add One'),
                            SizedBox(
                              height: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (ctx) => AddSubjectDialog(),
                                );
                              },
                              child: Text('Add Subject'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            buttonCarouselController.previousPage(
                              duration: Duration(milliseconds: 500),
                              curve: Curves.linear,
                            );
                          },
                          icon: Icon(Icons.arrow_back_ios_rounded),
                        ),
                        Expanded(
                          child: CarouselSlider.builder(
                            carouselController: buttonCarouselController,
                            itemCount: subjects.length,
                            itemBuilder: (ctx, index, _) {
                              final subject =
                                  subjects[index] as Map<String, dynamic>;
                              final s = subject.keys.toString();
                              final s1 = s.substring(1, s.length - 1);
                              final name = s1.split(',');
                              final name1 = name[2] + ' ' + name[3];

                              return Row(
                                children: [
                                  ChartLast5Lectures(subject[s1], name1, s1),
                                ],
                              );
                            },
                            options: CarouselOptions(
                              autoPlay: false,
                              aspectRatio: 1.5,
                              viewportFraction: 1,
                              enableInfiniteScroll: false,
                              scrollDirection: Axis.horizontal,
//                  onPageChanged: (index, reason) {
//                    setState ( () {
//                      _current = index;
//                    });
//                  },
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            buttonCarouselController.nextPage(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.linear,
                            );
                          },
                          icon: Icon(Icons.arrow_forward_ios_rounded),
                        ),
                      ],
                    ),
        ),
      ),
    );
  }
}
