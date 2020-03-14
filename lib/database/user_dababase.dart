import 'dart:convert';

import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:synchronized/synchronized.dart';

class UserDataBase {
  UserDataBase._init();
  static UserDataBase _userDataBase;
  factory UserDataBase() => _userDataBase ??= UserDataBase._init();
  Box box;
  var lock = new Lock(reentrant: true);

  Future<Box> init() async {
    try {
      return await lock.synchronized(() async {
        if (box == null) {
          var a = DateTime.now().millisecondsSinceEpoch;
          await Hive.initFlutter();
          box = await Hive.openBox('user_data');
          print('Hive初始化成功，耗时${DateTime.now().millisecondsSinceEpoch - a}毫秒');
          setUserState();
          return box;
        }
        return box;
      });
    } catch (e) {
      throw Exception(HiveState.Failed);
    }
  }

  void insertUser(UserModel user, String token) {
    if (box.isOpen) {
      box.put('user', jsonDecode(jsonEncode(user.toJson())));
      box.put('token', token);
      setUserState();
    }
  }

  void setUserState() {
    if (box.isOpen) {
      Api.token = box.get('token', defaultValue: '');
      var user = box.get('user', defaultValue: '');
      if (user is Map) {
        Api.userId = UserModel.fromJson(Map.castFrom(box.get('user'))).userId;
      }
    }
  }

  void clear() {
    if (box.isOpen) {
      box.clear();
    }
  }

  String getToken() => box.get('token');
  dynamic getUser() async {
    if (box.isOpen) {
      var user = box.get('user', defaultValue: '');
      if (user is Map) {
        print('getCacheUser:${Map.castFrom(box.get('user'))}');
        return UserModel.fromJson(Map.castFrom(box.get('user')));
      }
      return user;
    }
  }

  void dispose() {
    box.close();
  }
}
