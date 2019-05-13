import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_273/models/auth.dart';
import 'package:project_273/scope_models/mainModel.dart';

class UserLoginBody extends StatefulWidget {

  MainModel model;

  UserLoginBody(this.model);

  @override
  State<StatefulWidget> createState() {
    return _UserLoginBodyState();
  }
}

class _UserLoginBodyState extends State<UserLoginBody> {


  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
  //  'clientId': null
  };

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return new Container(
      child: Center(
        child: SingleChildScrollView(
          child: new Container(
            width: deviceWidth * 0.7,
            child: new Form(
              key: _formKey,
              child: new Column(
                children: <Widget>[
                  //new SizedBox(
                  //  height: 200.0,
                  //),
                  _buildClientIdTextField(),
                  new SizedBox(
                    height: 30.0,
                  ),
                  _buildUserNameTextField(),
                  new SizedBox(
                    height: 30.0,
                  ),
                  _buildPasswordTextField(),
                  new SizedBox(
                    height: 50.0,
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/userRegistration');
                    },
                    child: new Text(
                      "No account? Register now!",
                      style: new TextStyle(
                        fontSize: 16.0,
                        fontStyle: FontStyle.italic,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      _submitForm(widget.model.authenticate);
                    },
                    color: Colors.red,
                    child: new Text(
                      "Submit",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClientIdTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Client Id',
        filled: true,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a client Id';
        }
      },
      onSaved: (String value) {
        _formData["clientId"] = value;
      },
    );
  }

  Widget _buildUserNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter a valid email';
        }
      },
      onSaved: (String value) {
        _formData["email"] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      obscureText: true,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Password is required!';
        }
      },
      onSaved: (String value) {
        _formData["password"] = value;
      },
    );
  }

  void _submitForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'], _formData['clientId'], _authMode);
    if (successInformation['success']) {
      Navigator.pushReplacementNamed(context, '/');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred!'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

}