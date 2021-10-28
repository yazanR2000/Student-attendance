import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subjects.dart';
import '../providers/last_5_lectures_chart.dart';
class AddSubjectDialog extends StatefulWidget {
  @override
  _AddSubjectDialogState createState() => _AddSubjectDialogState();
}

class _AddSubjectDialogState extends State<AddSubjectDialog> {
  String collegeValue = 'Hijjawi';
  String sectionValue = 'CPE';
  String sectionNumValue = 'CPE 252';
  TextEditingController _controller = TextEditingController();

  bool _isLoading = false;
  bool _done = false;

  Widget _selection(List<String> items, String name) {
    print(name);
    print(items);
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name),
          Expanded(
            child: DropdownButton<String>(
              menuMaxHeight: 140,
              value: name.startsWith('College')
                  ? collegeValue
                  : name.startsWith('Subject')
                      ? sectionValue
                      : sectionNumValue,
              icon: const Icon(Icons.arrow_downward),
              iconSize: 20,
              elevation: 10,
              style: const TextStyle(color: Color(0xff222831)),
              //isExpanded: true,
              alignment: Alignment.center,
              underline: Container(
                height: 2,
                color: Color(0xff222831),
              ),
              onChanged: (String? newValue) {
                setState(() {
                  if (name.startsWith('College'))
                    collegeValue = newValue!;
                  else if (name.startsWith('Subject'))
                    sectionValue = newValue!;
                  else
                    sectionNumValue = newValue!;
                });
              },
              items: items.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('New Subject'),
      //titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
      content: Container(
        height: 200,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : FutureBuilder(
          future: _done ? Future.delayed(Duration(seconds: 1)) : Future.delayed(Duration.zero),
              builder:(ctx,snapshot){
            if(snapshot.connectionState == ConnectionState.waiting)
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done,color: Colors.green,size: 30,),
                  SizedBox(height: 10,),
                  Text('New Subject Added Successfully'),
                ],
              );
            return SingleChildScrollView(
                      child: Column(
                        children: [
                          _selection([
                            'Hijjawi',
                            'Faculty of medicine',
                          ], 'College : '),
                          _selection([
                            'CPE',
                            'EPE',
                            'ELE',
                            'CME',
                          ], 'Subject : '),
                          _selection([
                            'CPE 252',
                            'CPE 450',
                            'CPE 312',
                            'CPE 560',
                          ], 'Section Number : '),
                          SizedBox(
                            height: 5,
                          ),
                          Container(
                            height: 50,
                            child: Row(
                              children: [
                                Text('Division No : '),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 0),
                                    decoration: BoxDecoration(
                                      color: Color(0xffEEEEEE),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: _controller,
                                      decoration: InputDecoration(
                                          isDense: true,
                                          border: InputBorder.none),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );},
            ),
      ),
      actions: [
        TextButton(
          onPressed: () async {
            setState(() {
              _isLoading = true;
              _done = false;
            });
            await Provider.of<Subjects>(context, listen: false).addNewSubject(
              collegeValue +
                  ',' +
                  sectionValue +
                  ',' +
                  sectionNumValue +
                  ',' +
                  _controller.text,
            );
            Provider.of<Chart>(context,listen: false).toggleFetch();
            Provider.of<Chart>(context,listen: false).notify();
            setState(() {
              _isLoading = false;
              _done = true;
            });
            Future.delayed(Duration(seconds: 1)).then((value){
              Navigator.of(context).pop();
            });
          },
          child: Text('SAVE'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('CANCEL'),
        ),
      ],
    );
  }
}
