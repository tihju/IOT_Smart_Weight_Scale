import 'dart:convert';
import 'dart:async';
import 'dart:io';

import 'package:project_273/models/auth.dart';
import 'package:project_273/models/clientInfo.dart';
import 'package:project_273/models/record.dart';
import 'package:project_273/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

mixin ConnectedModels on Model {
  List<User> _users = [];
  List<Record> _records = [];
  bool _isLoading = false;
  ClientInfo _authenticatedClient;
  String serverUrl = 'http://localhost:8000/';
  String name;
  double targetWeight;
  double _payment;
  List<Map<String, dynamic>> _historyList = [];
  Map<String, dynamic> _recomm;
  Map<String, dynamic> _readData;
  Map<String, dynamic> _discoverData;
}

mixin UtilityModel on ConnectedModels {
  bool get isLoading {
    return _isLoading;
  }
}

mixin UserModel on ConnectedModels {
  ClientInfo get client {
    return _authenticatedClient;
  }

  void setClient(Map<String, dynamic> input) {
          _authenticatedClient = ClientInfo(
          clientId: input['clientId'],
          email: input['email'],
          premium: input['premium'],
      );
      name = input['name'];
      targetWeight = input['targetWeight'];
      print(_authenticatedClient);
      print(name);
      print(targetWeight);
  }

  Future<Map<String, dynamic>> authenticate(String email, String password, String clientId,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response response;
    http.Response serverRes;
    if (mode == AuthMode.Login) {
      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDEidKvPSnigxPXMxMec6yLesCnXtJiRTA',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      final Map<String, dynamic> data = {
        'clientId': _authenticatedClient.clientId,
        'email': _authenticatedClient.email,
        'premium': _authenticatedClient.premium ? 1 : 0,
        'name': name,
        'targetWeight': targetWeight
      };
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('clientId', _authenticatedClient.clientId);
      prefs.setBool('premium', _authenticatedClient.premium);
      print(prefs.toString());

      response = await http.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDEidKvPSnigxPXMxMec6yLesCnXtJiRTA',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
      serverRes = await http.post(serverUrl+'client/create', body: json.encode(data), headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Something went wrong.';
    print(responseData);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';
//      _authenticatedClient = ClientInfo(
//          clientId: clientId,
//          email: email,
//          token: responseData['idToken'],
//          premium: premium,
//      );
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
//      prefs.setString('clientEmail', email);
//      prefs.setString('clientId', clientId);

      print(prefs.toString());
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'This email already exists.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'This email was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'The password is invalid.';
    }
    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {

      final String clientEmail = prefs.getString('clientEmail');
      final String clientId = prefs.getString('clientId');
      print("client ID: " + clientId);
      bool premium = false;
      http.Response response = await http.get('http://localhost:8000/client/'+clientId);
      if(response.statusCode == 200) {
        final dynamic _data = json.decode(response.body);
        premium = _data['premium'];
        print("premium: " + premium.toString());
        prefs.setBool('premium', premium);
      }
      _authenticatedClient = ClientInfo(clientId: clientId, email: clientEmail,
          token: token, premium: premium);
      print(_authenticatedClient.clientId);
      notifyListeners();
    }
  }

  bool checkAuthentication(){
    if (_authenticatedClient != null) {
      return true;
    } else {
      return false;
    }
  }

  void logout() async {
    print('Logout');
    _authenticatedClient = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('clientEmail');
    prefs.remove('clientId');
    prefs.remove('premium');
  }


}

mixin UserPreferenceModel on ConnectedModels {

  List<User> get userList {
    return _users;
  }

  Future<void> fetchUserList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String clientId = prefs.get('clientId');
  //  String clientId = _authenticatedClient.clientId;


    _isLoading = true;
    notifyListeners();
    return http
        .get(serverUrl+'client/'+clientId+'/user')
        .then<Null>((http.Response response) {
      final List<User> _userListTemp = [];
      final List<dynamic> _userData = json.decode(response.body);

     // print(_userData);

      if (_userData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      _userData.forEach((dynamic _user) {
        final List<Record> _recordTemp = [];
        final List<dynamic> _recordData = _user["records"];
        if(_recordData != null){
          _recordData.forEach((dynamic r){
            final Record record = Record(
                deviceId: r["deviceId"],
                time: r["date"],
                weight: r["weight"]
            );
            _recordTemp.add(record);
          });
         // print(_recordTemp);
        }
        final User user = User(
            userId: _user["userId"],
            name: _user["name"],
            targetWeight: _user["targetWeight"],
            records: _recordTemp
        );
        _userListTemp.add(user);
      });

     // print("finish assigning");
      _users= _userListTemp;
      _isLoading = false;
      notifyListeners();
    });
  }

  Future<void> fetchAnalytics(String userId) {
    _isLoading = true;
    notifyListeners();
//    final SharedPreferences prefs = await SharedPreferences.getInstance();
//    final String clientId = prefs.get('clientId');
    String clientId = _authenticatedClient.clientId;
    return http
        .get(serverUrl+'records/analytics/'+clientId+'/'+userId)
        .then<Null>((http.Response response) {
      final List<Map<String, dynamic>> _historyTemp = [];
      final Map<String, dynamic> _historyData = json.decode(response.body);
      if (_historyData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      print("History data" + _historyData.toString());
      print("analytics: " + _historyData['history analytics'].toString());

      if (_historyData['history analytics'] != null) {
        _historyData['history analytics'].forEach((dynamic _data) {
          Map<String, dynamic> data = _data;
          _historyTemp.add(data);
        });
        _historyList = _historyTemp;
        print("History List" + _historyList.toString());
        Map<String, dynamic> recomm = _historyData['recommended diet'];
        print("RECOMM: " + recomm.toString());
        _recomm = recomm;
      }

      _isLoading = false;
      notifyListeners();
    });
  }

  List<Map<String, dynamic>> get historyList {
    return _historyList;
  }

  Map<String, dynamic> get rec {
    return _recomm;
  }

  double get payment {
    return _payment;
  }

  Future<bool> addUser(
      String userId, String name, double targetWeight) async {
    _isLoading = true;
    notifyListeners();

    String clientId = _authenticatedClient.clientId;
   // print(clientId);
    final Map<String, dynamic> userData = {
      'userId': userId,
      'name': name,
      'targetWeight': targetWeight,
    };
    print("User Data: " + userData.toString());

    try {
      final http.Response response = await http.post(
          serverUrl+'client/' + clientId + '/user/create',
          headers: {'Content-type': 'application/json'},
          body: json.encode(userData));

      print(response.statusCode);
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    //  print(response.statusCode);
      print(response.body);

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }

  }

  Future<bool> downgrade() async {

    String clientId = _authenticatedClient.clientId;
    try {
      final http.Response response = await http.post(serverUrl+'downgrade/'+clientId, );
      print(response.statusCode);
      _authenticatedClient.premium = false;
      _isLoading = false;
      notifyListeners();
      return true;

    }catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> upgrade() async {

    String clientId = _authenticatedClient.clientId;
    try {
      final http.Response response = await http.post(serverUrl+'upgrade/'+clientId, );
      print(response.statusCode);
      _authenticatedClient.premium = true;
      _isLoading = false;
      notifyListeners();
      return true;

    }catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> getPayment() async {
    String clientId = _authenticatedClient.clientId;
    try {
      final http.Response response = await http.get(serverUrl+'payment/'+clientId, );
      print("payment"+response.statusCode.toString());
      Map<String, dynamic> data = json.decode(response.body);
      _payment = data['balance'];
      print("payment amount: " + _payment.toString());
      _isLoading = false;
      notifyListeners();

    }catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> turnOn() async {
    String clientId = _authenticatedClient.clientId;
    Map<String, dynamic> data = {
      'flag': 'true'
    };
    try {
      final http.Response response = await http.post(serverUrl+'device/observe/'+clientId,
          headers: {'Content-type': 'application/json'},
          body: json.encode(data));
      print(response.statusCode);
      _isLoading = false;
      notifyListeners();

    }catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> turnOff() async {
    String clientId = _authenticatedClient.clientId;
    Map<String, dynamic> data = {
      'flag': 'false'
    };
    try {
      final http.Response response = await http.post(serverUrl+'device/observe/'+clientId,
          headers: {'Content-type': 'application/json'},
          body: json.encode(data));
      print(response.statusCode);
      _isLoading = false;
      notifyListeners();

    }catch (error) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<dynamic> read() {
    _isLoading = true;
    notifyListeners();
    String clientId = _authenticatedClient.clientId;
    return http.get(serverUrl+'device/read/'+clientId)
        .then((http.Response response){
      print(response.statusCode);
      print("read: "+response.body);
      Map<String, dynamic> data = json.decode(response.body);
      _readData = data;

      _isLoading = false;
      notifyListeners();

    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Map<String, dynamic> get readData {
    return _readData;
  }

  Map<String, dynamic> get discoverData {
    return _discoverData;
  }

  Future<dynamic> discover() {
    _isLoading = true;
    notifyListeners();
    String clientId = _authenticatedClient.clientId;
    return http.get(serverUrl+'device/discover/'+clientId)
        .then((http.Response response){
      print(response.statusCode);
      print("discover: "+response.body);
      Map<String, dynamic> data = json.decode(response.body);
      _discoverData = data;

      _isLoading = false;
      notifyListeners();

    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<dynamic> write() {
    _isLoading = true;
    notifyListeners();
    String clientId = _authenticatedClient.clientId;
    return http.post(serverUrl+'device/write/'+clientId)
        .then((http.Response response){
      print("write: " + response.statusCode.toString());

      _isLoading = false;
      notifyListeners();

    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<dynamic> create() {
    _isLoading = true;
    notifyListeners();
    String clientId = _authenticatedClient.clientId;
    return http.put(serverUrl+'device/create/'+clientId+'/'+clientId)
        .then((http.Response response){
      print("create: " + response.statusCode.toString());

      _isLoading = false;
      notifyListeners();

    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<dynamic> delete() {
    _isLoading = true;
    notifyListeners();
    String clientId = _authenticatedClient.clientId;
    return http.delete(serverUrl+'device/record/'+clientId)
        .then((http.Response response){
      print("delete: " + response.statusCode.toString());

      _isLoading = false;
      notifyListeners();

    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }



}
