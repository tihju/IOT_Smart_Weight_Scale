import 'package:flutter/material.dart';
import 'package:project_273/help_widgets/userCard.dart';
import 'package:project_273/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scope_models/mainModel.dart';


class MyUserPage extends StatefulWidget {


  MainModel model;

  MyUserPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _MyUserState();
  }
}

class _MyUserState extends State<MyUserPage> {

  @override
  void initState() {
    widget.model.fetchUserList();
    widget.model.getPayment();
    super.initState();
  }

  Widget _buildUserList(List<User> _userList) {
    if (_userList.length > 0) {
      return new ListView.builder(
          itemCount: _userList.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              child: Column(
                children: <Widget>[
                  UserCard(_userList[index], widget.model),
                ],
              ),
            );
          }
      );
    } else {
      return new Container();
    }
  }

  build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("My Users"),
      ),
      body: ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
          Widget content =
          Center(child: Text('No Users Found!'));
          if (!model.isLoading && model.userList != null && model.userList.length > 0) {
           // print("inside userList function");
            content = _buildUserList(model.userList);
          } else if (model.isLoading) {
            content = new Center(child: CircularProgressIndicator());
          }
          return new RefreshIndicator(
            onRefresh: model.fetchUserList,
            child: content,
          );
        },
      ),
    );
  }
}