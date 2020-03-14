import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/login_model.dart';

class PwdLoginVm with ChangeNotifier {
  bool _permitLogin = false;
  bool _loginProcess = false;
  String _username = '';
  String _password = '';
  String get username => _username;
  String get password => _password;
  LoginModel getData() {
    return LoginModel(password: _password, phone: _password);
  }

  set username(String username) {
    _username = username;
    if (_username.length >= 6 && _password.length >= 6) {
      if (!_permitLogin) {
        print('刷新！');
        _permitLogin = true;
        notifyListeners();
      }
    } else {
      if (_permitLogin) {
        print('刷新！');
        _permitLogin = false;
        notifyListeners();
      }
    }
  }

  set password(String password) {
    _password = password;
    if (_username.length >= 6 && _password.length >= 6) {
      if (!_permitLogin) {
        print('刷新！');
        _permitLogin = true;
        notifyListeners();
      }
    } else {
      if (_permitLogin) {
        print('刷新！');
        _permitLogin = false;
        notifyListeners();
      }
    }
  }

  bool get permitLogin => _permitLogin;
  bool get loginProcess => _loginProcess;
  set loginProcess(bool loginProcess) {
    _loginProcess = loginProcess;
    notifyListeners();
  }
}
