import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import '../screens/lecture_attendance_screen.dart';
class ChartLast5Lectures extends StatelessWidget {

  final Map _attendance;
  final String name;
  final String fullName;
  ChartLast5Lectures(this._attendance,this.name,this.fullName);

  List<AttendanceData> columnData = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SfCartesianChart(
        //onDataLabelTapped: (_){print(_.text);},
        title: ChartTitle(
          text: 'Last 5 lectures Attendance',
        ),
        primaryXAxis: CategoryAxis(),
        primaryYAxis: NumericAxis(),
        palette: [
          Color(0xff222831),
          Color(0xff222831),
          Color(0xff222831),
          Color(0xff222831),
          Color(0xff222831),
        ],
        legend: Legend(
          isVisible: true,
          itemPadding: 2,
          position: LegendPosition.bottom
        ),
        //plotAreaBorderColor: Colors.black,
        series: <ChartSeries>[
          ColumnSeries<AttendanceData, String>(
            name: name,
            dataSource: getColumnData(),
            xValueMapper: (AttendanceData a, _) => a.x,
            yValueMapper: (AttendanceData a, _) => a.y,
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
            ),
            //onPointTap: (_){print(_.);},
            onPointDoubleTap: (_){
              //print(columnData[_.pointIndex!].x);
              Navigator.of(context).pushNamed(LectureAttendanceScreen.routName,arguments: {
                'lectureName' : columnData[_.pointIndex!].x,
                'subject' : fullName
              });
            },
            emptyPointSettings: EmptyPointSettings(
              mode: EmptyPointMode.zero,
            ),

            selectionBehavior: SelectionBehavior(
              enable: true,
              selectedColor: Colors.blue,
              unselectedColor: Color(0xff222831),
              unselectedOpacity: 1.0,
              //selectedBorderWidth: 50,
            ),
          ),
        ],
//        tooltipBehavior: TooltipBehavior(
//          enable: true,
//          activationMode: ActivationMode.singleTap
//        ),
//        onAxisLabelTapped: (_){print(_.text);},
//        onDataLabelTapped: (_){print(_.text);},


      ),
    );
  }
  dynamic getColumnData() {

  _attendance.forEach((key, value) {
    if(key == 'null')
      columnData.add(AttendanceData('Lectures is empty',value));
    else
      columnData.add(AttendanceData(key,value));
  });
  return columnData;
  }
}

class AttendanceData {
  String x;
  int y;

  AttendanceData(this.x, this.y);
}


