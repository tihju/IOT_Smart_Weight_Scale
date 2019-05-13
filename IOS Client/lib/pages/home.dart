import "package:flutter/material.dart";
import 'package:project_273/help_widgets/deviceBody.dart';
import 'package:project_273/help_widgets/homeBody.dart';
import 'package:project_273/help_widgets/loginBody.dart';
import 'package:project_273/help_widgets/myAccountBody.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scope_models/mainModel.dart';

class HomePage extends StatefulWidget {

  final MainModel model;

  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int currentIndex;

  @override
  void initState() {
    currentIndex = 0;
    widget.model.autoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _appBar(context, currentIndex),
      body: _body(context, currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.device_hub), title: Text('Device')),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), title: !widget.model.checkAuthentication() ? Text('Login') : Text('MyAccount')),
        ],
        currentIndex: currentIndex,
        fixedColor: Colors.red,
        onTap: (int index) =>
            setState(() {
              currentIndex = index;
            }),
      ),
    );
  }

  Widget _appBar(BuildContext context, int index) {
    List<Widget> _appBarList = new List<Widget>();
    if (widget.model.checkAuthentication()) {
      _appBarList
          .addAll([_homeAppBar(context), _deviceAppBar(), _myAccountAppBar()]);
    } else {
      _appBarList
          .addAll([_homeAppBar(context), _deviceAppBar(), _loginAppBar()]);
    }

    return _appBarList[index];
  }

  Widget _body(BuildContext context, int index) {
    List<Widget> _bodyList = new List<Widget>();
    if(widget.model.checkAuthentication()) {
      _bodyList.addAll([HomeBody(), DeviceBodyPage(widget.model), MyAccountBody(widget.model)]);
    } else {
      _bodyList.addAll([HomeBody(), DeviceBodyPage(widget.model), UserLoginBody(widget.model)]);
    }

    return _bodyList[index];
  }

  Widget _homeAppBar(BuildContext context) {
    return new AppBar(
      title: new Container(
        child: Center(
          child: new Text("Home"),
        ),
      ),
    );
  }

  Widget _deviceAppBar() {
    return new AppBar(
      title: new Container(
        child: Center(
          child: Text("Device Management"),
        ),
      ),
    );
  }

  Widget _myAccountAppBar() {
    return new AppBar(
      title: new Container(
        child: Center(
          child: Text("My Account"),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            widget.model.logout();
            Navigator.pushReplacementNamed(context, '/');
          },
        )
      ],
    );
  }

  Widget _loginAppBar() {
    return new AppBar(
      title: new Container(
        child: new Center(
          child: Text("Member Login"),
        ),
      ),
    );
  }
}
