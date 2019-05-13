import 'dart:math';
import 'package:flutter/material.dart';
import '../scope_models/mainModel.dart';
import 'package:flutter/cupertino.dart';

class PaymentPage extends StatelessWidget {
  MainModel model;

  PaymentPage(this.model);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Text("Payment"),
      ),
      body: _buildPayment(),
    );
  }

  Widget _buildPayment() {
    
    return Container(
      padding: EdgeInsets.all(12.0),
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Your balance amount: ",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        Container(
            child: Row(
          children: <Widget>[
            Icon(Icons.attach_money),
            Text(
              model.payment.toString(),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            )
          ],
        ))
      ],
    ));
  }
}
