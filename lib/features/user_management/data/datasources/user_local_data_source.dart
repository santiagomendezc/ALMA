import 'dart:convert';
import 'package:aplicacion/features/user_management/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  Future<List<UserModel>> getUsers();
  Future<void> cacheUsers(List<UserModel> users);
}

const CACHED_USERS = 'CACHED_USERS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<UserModel>> getUsers() {
    final jsonString = sharedPreferences.getString(CACHED_USERS);
    if (jsonString != null) {
      List<dynamic> jsonList = json.decode(jsonString);
      List<UserModel> users = jsonList.map((json) => UserModel.fromJson(json)).toList();
      return Future.value(users);
    } else {
      return Future.value([]);
    }
  }

  @override
  Future<void> cacheUsers(List<UserModel> users) {
    List<Map<String, dynamic>> jsonList = users.map((user) => user.toJson()).toList();
    return sharedPreferences.setString(CACHED_USERS, json.encode(jsonList));
  }
}
