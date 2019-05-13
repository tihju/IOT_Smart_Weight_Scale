

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_273/help_widgets/recordCard.dart';
import 'package:project_273/models/record.dart';
import 'package:project_273/models/user.dart';
import 'package:project_273/scope_models/mainModel.dart';

class RecordPage extends StatefulWidget {

  List<Record> records;

  RecordPage(this.records);

  @override
  State<StatefulWidget> createState() {
    return _RecordState();
  }
}

class _RecordState extends State<RecordPage> {

  @override
  void initState() {
    //widget.model.fetchUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("My Records"),
      ),
      body:
      _buildRecordList(widget.records),
    );
  }

  Widget _buildRecordList(List<Record> _recordList) {
    if (_recordList.length > 0) {
      return new ListView.builder(
          itemCount: _recordList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: Column(
                children: <Widget>[
                  RecordCard(_recordList[index]),
                ],
              ),
            );
          }
      );
    } else {
      return new Container(
        padding: EdgeInsets.all(8.0),
        child: Text("No Records Yet",
        style: TextStyle(fontSize: 20.0),),);
    }
  }

}