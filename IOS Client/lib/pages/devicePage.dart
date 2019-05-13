import 'dart:math';
import 'package:flutter/material.dart';
import '../scope_models/mainModel.dart';
import 'package:flutter/cupertino.dart';

class DevicePage extends StatefulWidget {

  MainModel model;

  DevicePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _DeviceState();
  }
}

class _DeviceState extends State<DevicePage> {

  static bool isOn = false;
  Map<String, dynamic> data;

  @override
  void initState() {
    widget.model.read();
    widget.model.discover();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Device Management"),
      ),
      body: _buildDevice(),
    );
  }

  Widget _buildDevice() {
    return Column(
      children: <Widget>[
        _buildObserve(on, off),
        _buildRead(read),
        _buildDiscover(),
        _buildCreate(),
        _buildDelete(),
        _buildWrite(),
      ],
    );
  }

  Widget _buildObserve(void Function() on, void Function() off) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            "OBSERVE",
            style: TextStyle(fontSize: 18.0),
          ),
          FlatButton(
            onPressed: on,
            color: (isOn) ? Colors.red[100]: Colors.red,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "ON",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: off,
            color: (isOn) ? Colors.red: Colors.red[100],
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "OFF",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRead(Widget Function() read) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: read,
            color: Colors.red,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "READ",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Text(
            "value"
          )
        ],
      ),
    );
  }

  Widget _buildDiscover(){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: read,
            color: Colors.red,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Discover",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Text(
              "value"
          )
        ],
      ),
    );
  }

  Widget _buildWrite(){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: read,
            color: Colors.red,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Write",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Text(
              "value"
          )
        ],
      ),
    );
  }

  Widget _buildCreate(){
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: read,
            color: Colors.red,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "Create",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Text(
              "value"
          )
        ],
      ),
    );
  }

  Widget _buildDelete() {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 8.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: read,
            color: Colors.red,
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "DELETE",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void on() {
    setState(() {
      isOn = true;
      widget.model.turnOn();
    });
  }

  void off() {
    setState(() {
      isOn = false;
      widget.model.turnOff();
    });
  }

  Widget read() {
    setState(() {
      widget.model.read();
      data = widget.model.readData;
    });
    return AlertDialog(
      title: Text('Read Value'),
      content: Text(data.toString()),
      actions: <Widget>[
        FlatButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Okay'),
        )
      ],
    );
  }




}