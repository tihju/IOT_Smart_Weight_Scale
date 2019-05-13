import 'package:flutter/material.dart';

import '../models/auth.dart';
import '../scope_models/mainModel.dart';

class RegistrationPage extends StatefulWidget {

  MainModel model;

  RegistrationPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _RegistrationState();
  }
}

class _RegistrationState extends State<RegistrationPage> {
  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'clientId': null,
    'premium': false,
    'name': null,
    'targetWeight': 0
  };

  List<String> _plan = new List<String>();
  String _value;

  @override
  void initState() {
    _plan.addAll(["Basic", "Premium"]);
    super.initState();
  }

  void _onChanged(String value) {
    setState(() {
      _value = value;
      _formData["premium"] = value == "Basic" ? false : true;
    });
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = new TextEditingController();
  AuthMode _authMode = AuthMode.Signup;

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return new Scaffold(
      appBar: new AppBar(
        title: Text("Member Registration"),
      ),
      body: new Container(
        child: new Center(
          child: SingleChildScrollView(
            child: new Container(
              width: deviceWidth * 0.7,
              child: new Form(
                key: _formKey,
                child: new Column(
                  children: <Widget>[
                    _buildClientIdTextField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    _buildEmailTextField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordTextField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    _buildPasswordConfirmTextField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    _buildNameField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    _buildWeightField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    _buildPremiumField(),
                    new SizedBox(
                      height: 30.0,
                    ),
                    RaisedButton(
                      onPressed: () {
                        _submitForm(widget.model.authenticate, widget.model.setClient);
                      },
                      color: Colors.red,
                      child: new Text(
                        "Sign up",
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
      ),
    );
  }

  Widget _buildEmailTextField() {
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
      controller: _passwordTextController,
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

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm Password',
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
        if (_passwordTextController.text != value) {
          return 'Password do not match!';
        }
      },
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Name',
        filled: true,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      onSaved: (String value) {
        _formData["name"] = value;
      },
    );
  }

  Widget _buildWeightField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Target Weight in kg',
        filled: true,
        fillColor: Colors.white,
        border: new OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      onSaved: (String value) {
        _formData["targetWeight"] = double.parse(value);
      },
    );
  }

  Widget _buildPremiumField() {
    return new Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Colors.grey[600],
            width: 1.0,
          )),
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton(
          value: _value,
          hint: Text("Plan"),
          items: _plan.map((String value) {
            return new DropdownMenuItem(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          onChanged: (String value) {
            _onChanged(value);
          },
        ),
      ),
      padding:
      EdgeInsets.symmetric(vertical: 0.0, horizontal: 60.0),
    );
  }


  void _submitForm(Function authenticate, Function setClient) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    //  getToken(_formData['email'], _formData['password']);
    final Map<String, dynamic> data = {
      'clientId': _formData['clientId'],
      'email': _formData['email'],
      'premium':_formData['premium'],
      'name': _formData['name'],
      'targetWeight': _formData['targetWeight']
    };
    setClient(data);
    Map<String, dynamic> successInformation;
    successInformation = await authenticate(
        _formData['email'], _formData['password'],_formData['clientId'], _authMode);
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
