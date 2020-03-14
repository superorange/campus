import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/database/user_dababase.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/service/user_service.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

class PersonPageVm extends BaseVm with ChangeNotifier {
  UserModel _user;
  @override
  Future loadMore() {
    return null;
  }

  UserModel get user => _user;

  @override
  Future<LoginState> loading() async {
    var userCache = await UserDataBase().getUser();
    print(userCache.runtimeType);
    if (userCache is UserModel) {
      print('fuzhi');
      _user = userCache;
    }
    if (_user == null) {
      return LoginState.Other;
    }
    return UserService().validate().then((val) {
      var model = BaseModel.fromJson(val.data);
      if (model.code == 200) {
        _user = UserModel.fromJson(model.data);

        UserDataBase().insertUser(user, model.token);
        notifyListeners();

        return LoginState.LoginOk;
      }
      notifyListeners();
      UserDataBase().clear();
      DataBaseManager().clearChatterTable();
      DataBaseManager().clearChatMsgTable();
      print('_user :$_user');
      return LoginState.LoginFailed;
    }, onError: (e) {
      notifyListeners();
      if (e is DioError) {
        if (e.response?.statusCode == 401) {
          return LoginState.LoginFailed;
        }
      }
      return LoginState.Other;
    });
  }

  Future clearUser(BuildContext context) async {
    await DataBaseManager().clearChatMsgTable();
    await DataBaseManager().clearChatterTable();
    Hive.box('user_data')..delete('user')..delete('token');
    Provider.of<ChatChattersPageVm>(context, listen: false).clearUser();
    _user = null;
    notifyListeners();
  }
}
