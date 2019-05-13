import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_273/help_widgets/dataCard.dart';
import 'package:project_273/help_widgets/recordCard.dart';
import 'package:project_273/models/record.dart';
import 'package:project_273/models/user.dart';
import 'package:project_273/scope_models/mainModel.dart';
import 'package:scoped_model/scoped_model.dart';

class AnalyticPage extends StatefulWidget {
  User user;
  MainModel model;

  AnalyticPage(this.user, this.model);

  @override
  State<StatefulWidget> createState() {
    return _AnalyticState();
  }
}

class _AnalyticState extends State<AnalyticPage> {
  @override
  void initState() {
    if(widget.model.client.premium){
      widget.model.fetchAnalytics(widget.user.userId);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.model.client.premium) {
      return Scaffold(
        appBar: new AppBar(
          title: new Text("My Analytics"),
        ),
        body: ScopedModelDescendant<MainModel>(
          builder: (BuildContext context, Widget child, MainModel model) {
            Widget content = Center(child: Text('No Analytics Found!'));
            if (!model.isLoading) {
              content = _buildPage();
            } else if (model.isLoading) {
              content = new Center(child: CircularProgressIndicator());
            }
            return content;
          },
        ),
      );
    } else {
      return AlertDialog(
        title: Text('Not Authorized!'),
        content: Text('Only premium member can access this feature'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Okay'),
          )
        ],
      );
    }
  }

  Widget _buildHistoryList(List<Map<String, dynamic>> _historyList) {
    print("inside buildHistoryList function");
    if (_historyList != null && _historyList.length > 0) {
      return Column(
        children: <Widget>[
          new DataCard(_historyList[0]),
          new DataCard(_historyList[1])
        ],
      );
//      return new ListView.builder(
//          itemCount: _historyList.length,
//          itemBuilder: (BuildContext context, int index) {
//            return new Container(
//              child: Column(
//                children: <Widget>[
//                  new DataCard(_historyList[index]),
//                ],
//              ),
//            );
//          });
    } else {
      return new Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No History Records Yet",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
  }

  Widget _buildRecList(Map<String, dynamic> _rec) {
    print("inside buildRecList function");
    if(_rec != null) {
      return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text('Recommendation Meal Plan',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text('Breakfast: ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(_rec['breakfast'], style: TextStyle(fontSize: 16.0)),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text('Lunch: ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(_rec['lunch'], style: TextStyle(fontSize: 16.0)),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text('Dinner: ',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
          ),
          Container(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(_rec['dinner'], style: TextStyle(fontSize: 16.0)),
          ),
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text('History Data Analytics',
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
          )
        ],
      );
    }else{
      return new Container(
        padding: EdgeInsets.all(8.0),
        child: Text(
          "No recommendation without history data",
          style: TextStyle(fontSize: 20.0),
        ),
      );
    }
  }

  Widget _buildPage() {
    return ListView(
      children: <Widget>[
        _buildRecList(widget.model.rec),
        _buildHistoryList(widget.model.historyList)
      ],
    );
  }
}
