import 'package:flutter/material.dart';
import 'package:project_273/models/device.dart';

class ClientInfo{
  String clientId;
  String email;
  String token;
  bool premium;
  Device device;

  ClientInfo({@required this.clientId,
    @required this.email,
    @required this.token,
    @required this.premium,
    this.device});
}