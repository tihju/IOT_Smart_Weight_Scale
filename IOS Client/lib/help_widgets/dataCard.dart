import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_273/models/record.dart';

class DataCard extends StatelessWidget {

  Map<String, dynamic> data;
  DataCard(this.data);

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 8.0, top: 8.0),
                child: Text(data.keys.first, style: TextStyle(fontSize: 16.0)),
              ),
              Container(
                  padding: EdgeInsets.only(left: 8.0, top: 8.0),
                  child: Text(data.values.first,
                    style: TextStyle(fontSize: 16.0),))
            ]));
  }

}