import 'dart:math';
import 'package:flutter/material.dart';
import '../scope_models/mainModel.dart';
import 'package:flutter/cupertino.dart';

import 'loginBody.dart';

class DeviceBodyPage extends StatefulWidget {
  MainModel model;

  DeviceBodyPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _DeviceBodyState();
  }
}

class _DeviceBodyState extends State<DeviceBodyPage> {
  static bool isOn = false;
  Map<String, dynamic> data;

  @override
  void initState() {
    if(widget.model.client != null){
      widget.model.read();
      widget.model.discover();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.model.client == null || widget.model.client.clientId == null) {
      return AlertDialog(
        title: Text('Not logged in'),
        content: Text('Please login first.'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/'),
            child: Text('Okay'),
          )
        ],
      );
    }else{
      return new Scaffold(
        body: _buildDevice(),
      );
    }
  }

  Widget _buildDevice() {
    return Column(
      children: <Widget>[
        _buildObserve(on, off),
        _buildRead(read),
        _buildDiscover(discover),
        _buildWrite(write),
        _buildCreate(create),
        _buildDelete(delete),
      ],
    );
  }

  Widget _buildObserve(void Function() on, void Function() off) {
    return Center(
      child: Container(
      padding: EdgeInsets.only(top: 30.0, bottom: 20.0, left: 50.0, right: 8.0),
      child: Row(
        children: <Widget>[
          Text(
            "OBSERVE    ",
            style: TextStyle(fontSize: 18.0),
          ),
          FlatButton(
            onPressed: on,
            color: (isOn) ? Colors.blue[100] : Colors.blue,
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
            color: (isOn) ? Colors.blue[300] : Colors.blue[100],
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
      ));
  }

  Widget _buildRead(void Function() read) {
    return Center(
      child: Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 100.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: read,
            color: Colors.blue[300],
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
        ],
      ),
      ));
  }

  Widget _buildDiscover(void Function() discover) {
    return Center(
      child: Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 100.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: discover,
            color: Colors.blue[300],
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "DISCOVER",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
      ));
  }

  Widget _buildWrite(void Function() write) {
    return Center(
      child: Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 100.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: write,
            color: Colors.blue[300],
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "WRITE",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
      ));
  }

  Widget _buildCreate(void Function() create) {
    return Center(
      child: Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left:100.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: create,
            color: Colors.blue[300],
            child: Wrap(
              children: <Widget>[
                SizedBox(
                  width: 5.0,
                ),
                Text(
                  "CREATE",
                  style: TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
        ],
      ),
      ));
  }

  Widget _buildDelete(void Function() delete) {
    return Center(
      child: Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 20.0, left: 100.0, right: 8.0),
      child: Row(
        children: <Widget>[
          FlatButton(
            onPressed: delete,
            color: Colors.blue[300],
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
    ));
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

  void read() {
    setState(() {
      data = widget.model.readData;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Read a record'),
              content: Text(data.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
    });
  }

  void discover() {
    setState(() {
      data = widget.model.discoverData;
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Discover the attributes for device'),
              content: Text(data.toString()),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
    });
  }

  void write(){
    widget.model.write();
    setState((){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Write Value'),
              content: Text('Deregister the device successfully.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
    });
  }

  void create(){
    widget.model.create();
    setState((){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Create Record'),
              content: Text('Record created successfully.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
    });
  }

  void delete(){
    widget.model.delete();
    setState((){
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Delete all records'),
              content: Text('Deleted all the records on the device side.'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Okay'),
                )
              ],
            );
          });
    });
  }
}