
import 'package:meta/meta.dart';
import 'package:project_273/models/record.dart';

class User {
  final String userId;
  final String name;
  final double targetWeight;
  List<Record> records;

  User({
    @required this.userId,
    this.name,
    this.targetWeight,
    this.records});
}