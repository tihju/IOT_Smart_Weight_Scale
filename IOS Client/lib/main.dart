import 'package:flutter/material.dart';
import 'package:project_273/pages/devicePage.dart';
import 'package:project_273/pages/home.dart';
import 'package:project_273/pages/myUser.dart';
import 'package:project_273/pages/payment.dart';
import 'package:project_273/pages/register.dart';
import 'package:scoped_model/scoped_model.dart';
import './scope_models/mainModel.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: new MaterialApp (
        theme: new ThemeData(
          brightness: Brightness.light,
          primarySwatch: Colors.red,
          accentColor: Colors.redAccent,
          buttonColor: Colors.redAccent,
        ),
        routes: {
          '/': (BuildContext context) => HomePage(model),
          '/device': (BuildContext context) => DevicePage(model),
          '/user/myUser': (BuildContext context) => MyUserPage(model),
          '/user/payment': (BuildContext context) => PaymentPage(model),
          '/userRegistration': (BuildContext context) => RegistrationPage(model),
        },
      ),
    );
  }
}
