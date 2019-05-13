
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_273/help_widgets/recordCard.dart';
import 'package:project_273/models/record.dart';
import 'package:project_273/models/user.dart';
import 'package:project_273/pages/analytic.dart';
import 'package:project_273/pages/recordPage.dart';
import 'package:project_273/scope_models/mainModel.dart';

class UserCard extends StatefulWidget {
  final User user;
  MainModel model;

  UserCard(this.user, this.model);

  @override
  State<StatefulWidget> createState() {
    return _UserState();
  }
}

class _UserState extends State<UserCard> {

  @override
  void initState() {
    widget.model.fetchUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(widget.user.userId, style: TextStyle(fontSize: 16.0)),
                    ),
                    Container(
                        padding: EdgeInsets.only(right: 8.0, bottom: 8.0),
                        child: Text(widget.user.name))
                  ]),
              FlatButton(
                child: Text("Click to see records", style: TextStyle(color: Colors.black),),
                color: Colors.red[100],
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => RecordPage(widget.user.records)
                  )
                ),
              ),
              FlatButton(
                child: Text("Get Analytics and recommendation", style: TextStyle(color: Colors.black),),
                color: Colors.blue[100],
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => AnalyticPage(widget.user, widget.model)
                    )
                ),
              )
            ]));
    }


  }