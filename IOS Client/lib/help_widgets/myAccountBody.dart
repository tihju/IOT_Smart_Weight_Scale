import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_273/pages/addUser.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:image_picker/image_picker.dart';

import '../scope_models/mainModel.dart';

class MyAccountBody extends StatefulWidget {
  MainModel model;

  MyAccountBody(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MyAccountState();
  }
}

class _MyAccountState extends State<MyAccountBody> {

  File _imageFile;
  String s;
  String str;

  @override
  void initState() {
   // widget.model.autoAuthenticate();
    widget.model.getPayment();
    s = (widget.model.client.premium) ? "Premium" : "Basic";
    str = (widget.model.client.premium) ? "Downgrade" : "Upgrade";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return new Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: 50.0, bottom: 20.0, left: 20.0, right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: 200.0,
                      child: new Center(
                        child: Text(
                          model.checkAuthentication()
                               ? model.client.clientId
                               : "User Name",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                    top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/user/myUser');
                      },
                      child: Wrap(
                        children: <Widget>[
                          Icon(Icons.people),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            "My Users",
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.add_box),
                        color: Colors.redAccent,
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => AddUserPage(
                                  widget.model,
                                ))))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: _buildPayment(),
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                child: _buildPlan(changePlan),
              ),
            ],
          );
        });
  }

  Widget _buildPlan(void Function() callback) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          child: Text(
            'Plan: '+ s, style: TextStyle(fontSize: 20.0, color: Colors.black)
          ),
        ),
        FlatButton(
          onPressed: callback,
          color: Colors.red[100],
          child: Wrap(
            children: <Widget>[
              SizedBox(
                width: 5.0,
              ),
              Text(
                str,
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void changePlan() {
    setState(() {
      if(widget.model.client.premium){
        print("downgrade function");
        s = "Basic";
        str = "Upgrade";
        widget.model.downgrade();
      }else{
        print("upgrade function");
        s = "Premium";
        str = "Downgrade";
        widget.model.upgrade();
      }
    });
  }

  Widget _buildPayment(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pushNamed(context, '/user/payment');
          },
          child: Wrap(
            children: <Widget>[
              Icon(Icons.attach_money),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Payment",
                style: TextStyle(fontSize: 20.0),
              ),
            ],
          ),
        ),
      ],
    );
  }


}
