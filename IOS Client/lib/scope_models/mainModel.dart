import 'package:scoped_model/scoped_model.dart';

import './connectedModels.dart';

class MainModel extends Model with ConnectedModels, UtilityModel, UserModel, UserPreferenceModel {
}