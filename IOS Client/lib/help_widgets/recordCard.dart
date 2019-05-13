

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_273/models/record.dart';

class RecordCard extends StatelessWidget {
  final Record record;

  RecordCard(this.record);

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(record.time, style: TextStyle(fontSize: 16.0)),
              ),
              Container(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(record.weight.toString() + " kg",
                    style: TextStyle(fontSize: 20.0),))
        ]));
  }

}