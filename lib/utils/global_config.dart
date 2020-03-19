import 'dart:async';

import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/database/user_dababase.dart';

class GlobalConfig {
  static GlobalConfig _globalConfig;
  GlobalConfig._init();
  factory GlobalConfig() => _globalConfig ??= GlobalConfig._init();
  Future initSqlite() async {
    return await DataBaseManager().init().catchError((e) {
      throw e;
    });
  }

  Future initHive() async {
    return await UserDataBase().init().then((_) {
      UserDataBase().setUserState();
    }, onError: (e) {
      throw e;
    });
  }

  void dispose() {
    DataBaseManager().dispose();
    UserDataBase().dispose();
  }

  Future<bool> initGlobalConfig() async {
    try {
//      Api.init();
      await initSqlite();
      await initHive();
      return true;
    } catch (e) {
      return false;
    }
  }
}
