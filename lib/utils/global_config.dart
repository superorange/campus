import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/database/user_dababase.dart';

class GlobalConfig {
  static GlobalConfig _globalConfig;
  static GlobalKey<NavigatorState> globalKey=GlobalKey();
  GlobalConfig._init();
  factory GlobalConfig() => _globalConfig ??= GlobalConfig._init();
  Future initSqlite() async {
    return  DataBaseManager().init();
  }

  Future initHive() async {
    return await UserDataBase().init().then((_) {
      UserDataBase().setUserState();
    });
  }

  void dispose() {
    DataBaseManager().dispose();
    UserDataBase().dispose();
  }

  Future<bool> initGlobalConfig() async {
    try {
      Api.init();
      await initSqlite();
      await initHive();
      return true;
    } catch (e) {
      return false;
    }
  }
}
