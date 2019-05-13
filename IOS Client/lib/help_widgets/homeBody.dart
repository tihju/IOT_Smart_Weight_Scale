import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter/cupertino.dart';

class HomeBody extends StatelessWidget {
  String text1 = "1. Please register an account in the app.";
  String text2 = "2. Please turn on the device for setup. "
      "Once the device is on, the device will automatically start bootstrap function.";
  String text3 =
      "3. After the device is bootstraped, register the device to the network.";
  String text4 =
      "4. Please turn on the observe function in device management page to keep records in the system.";
  String text5 =
      "5. Start using the app and check records and recommendation in account page.";

  @override
  Widget build(BuildContext context) {
    return new Scaffold(body: _buildPage());
  }

  Widget _buildPage() {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Welcome to the DWMS app!",
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.blue,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Text(
            "Here are the setup procedure, please follow it step by step.",
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text1,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text2,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text3,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text4,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )),
              Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    text5,
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
