import 'package:flutter/material.dart';
import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/database/user_dababase.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/pages/upload_page.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:flutter_app/service/user_service.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:hive/hive.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class PersonPageVm extends BaseVm with ChangeNotifier {
  UserModel _user;
  @override
  Future loadMore() {
    return null;
  }

  UserModel get user => _user;
  Future<bool> updateImage(Asset headPic) async {
    var data = await GoodsService().getImageToken();
    BaseModel model = BaseModel.fromJson(data.data);
    if (model.code == 200) {
      var ak = await JiaMi.jm(model.token);
      var image = await QiNiu().uploadImage(
        headPic,
        '$ak:${model.msg}',
      );
      if (image != null) {
        var data = {'type': 'headPic', 'headPic': image};
        var result = await UserService().updateUser(data: data);
        if (result.data['code'] == 200) {
          _user = UserModel.fromJson(result.data['data']);
          notifyListeners();
          return true;
        }
        return false;
      }
      return false;
    }
    return false;
  }

  void updateUser(Map data) {
    UserService().updateUser(data: data).then((val) {
      if (val.data['code'] == 200) {
        showToast('操作成功');
        _user = UserModel.fromJson(val.data['data']);
        notifyListeners();
      } else {
        showToast('操作失败');
      }
    });
  }

  @override
  Future<LoginState> loading() async {
    var userCache = await UserDataBase().getUser();
    if (userCache is UserModel) {
      _user = userCache;
      return UserService().validate().then((val) {
        var model = BaseModel.fromJson(val.data);
        if (model.code == 200) {
          _user = UserModel.fromJson(model.data);
          UserDataBase().insertUser(user, model.token);
          notifyListeners();
          return LoginState.LoginOk;
        }
        UserDataBase().clear();
        DataBaseManager().clearChatterTable();
        DataBaseManager().clearChatMsgTable();
        notifyListeners();
        return LoginState.LoginFailed;
      }, onError: (e) {
        notifyListeners();
        if (e?.response?.statusCode == 401) {
          return LoginState.LoginFailed;
        }
        return LoginState.Other;
      });
    }
    return LoginState.Other;
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
