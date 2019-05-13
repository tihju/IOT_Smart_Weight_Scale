import 'package:flutter/material.dart';
import 'dart:io';

import 'package:scoped_model/scoped_model.dart';
import '../scope_models/mainModel.dart';

class AddUserPage extends StatefulWidget {
  MainModel model;

  AddUserPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _AddUserPageState();
  }
}

class _AddUserPageState extends State<AddUserPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> _userData = {
    'userId': null,
    'name': null,
    'targetWeight': null,
  };

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Add User'),
              ),
              body: _buildPageContent(context, model));
        });
  }

  Widget _buildPageContent(BuildContext context, MainModel model) {
    if (_authenticate(model.checkAuthentication)) {
      return Form(
          key: _formKey,
          child: Container(
              margin: EdgeInsets.all(10.0),
              child: ListView(
                children: <Widget>[
                  Text(
                    'Client ID: '+widget.model.client.clientId,
                    style:
                    TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 10.0),
                  _buildUserIdTextField(),
                  new SizedBox(
                    height: 30.0,
                  ),
                //  _chooseStar(),
                  _buildNameField(),
                  new SizedBox(
                    height: 30.0,
                  ),
                  _buildWeightField(),
                  new SizedBox(
                    height: 30.0,
                  ),
                 // _buildComment(),
                  SizedBox(height: 10.0),
                //  ImageInput(_setImage),
                  _buildSubmitButton(),
                ],
              )));
    } else {

    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
            child: Text('Submit'),
            onPressed: () {
              _submitUser(model.addUser);
            });
      },
    );
  }

  Widget _buildUserIdTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'User Id',
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
          return 'Please enter a user Id';
        }
      },
      onSaved: (String value) {
        _userData["userId"] = value;
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
        _userData["name"] = value;
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
        _userData["targetWeight"] = double.parse(value);
      },
    );
  }

//  Widget _chooseStar() {
//    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
//      Container(
//          padding: EdgeInsets.only(left: 8.0),
//          child: Text('Choose your rating:')),
//      Row(
//        mainAxisSize: MainAxisSize.min,
//        children: [
//          StartScoreButton(1, _score, _setScore),
//          StartScoreButton(2, _score, _setScore),
//          StartScoreButton(3, _score, _setScore),
//          StartScoreButton(4, _score, _setScore),
//          StartScoreButton(5, _score, _setScore),
//        ],
//      ),
//    ]);
//  }

//  Widget _buildComment() {
//    return TextFormField(
//      maxLines: 4,
//      decoration: InputDecoration(labelText: 'Your comments'),
//      onSaved: (String value) {
//        _reviewData['comment'] = value;
//      },
//    );
//  }

  void _submitUser(Function addUser) {
    _formKey.currentState.save();

    addUser(_userData['userId'], _userData['name'],
        _userData['targetWeight'])
        .then((bool success) {
      if (success) {
        Navigator.pop(context);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Something went wrong!'),
                content: Text('Please try again!'),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Okay'),
                  )
                ],
              );
            });
      }
    });
  }

  bool _authenticate(Function checkAuthentication) {
    if(checkAuthentication()){
      return true;
    }else{
      return false;
    }
  }

//  void _setScore(int s) {
//    setState(() {
//      _score = s;
//    });
//  }
//
//  void _setImage(File image) {
//    _reviewData['image'] = image;
//  }
}

//class StartScoreButton extends StatelessWidget {
//  StartScoreButton(this.index, this.score, this._callback);
//
//  final int index;
//  final int score;
//  final void Function(int) _callback;
//
//  void _selectStar() {
//    _callback(index);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      padding: EdgeInsets.all(0.0),
//      child: IconButton(
//        icon: (index <= score ? Icon(Icons.star) : Icon(Icons.star_border)),
//        color: Colors.red[500],
//        onPressed: _selectStar,
//      ),
//    );
//  }
//}
