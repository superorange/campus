import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/database/user_dababase.dart';
import 'package:flutter_app/utils/base_utils.dart';

class GlobalConfig {
  StreamController streamController = StreamController.broadcast();
  StreamSubscription streamSubscription;
  static GlobalConfig _globalConfig;
  Connectivity _connectivity;
  bool initAllisOk = false;
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

  void initConnectivity() {
    _connectivity ??= Connectivity();
    _connectivity.onConnectivityChanged.listen((r) {
      streamController.sink.add(r);
    });
  }

  void dispose() {
    DataBaseManager().dispose();
    UserDataBase().dispose();
    streamController.close();
    streamSubscription.cancel();
  }

  void initGlobalConfig() async {
    try {
      Api.init();
      await initSqlite();
      await initHive();
      initConnectivity();
      initAllisOk = true;
      streamController.sink.add(GlobalState.Ok);
    } catch (e) {
      initAllisOk = false;
      streamController.sink.add(GlobalState.Failed);
    }
  }
}
