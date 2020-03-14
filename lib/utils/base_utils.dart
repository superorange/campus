import 'package:encrypt/encrypt.dart';
import 'package:flutter/services.dart';

enum LoadState {
  LoadSuccess,
  LoadFailed,
  NullData,
  NetError,
}
enum LoginState {
  LoginOk,
  LoginFailed,
  Other,
}
enum GlobalState {
  Ok,
  Failed,
}
enum SqliteState { Ok, Failed }
enum HiveState { Ok, Failed }

class BaseUtils {}

class Regular {
  ///手机号验证
  static bool isChinaPhoneLegal(String str) {
    return RegExp(
            r"^1([38][0-9]|4[579]|5[0-3,5-9]|6[6]|7[0135678]|9[89])\d{8}$")
        .hasMatch(str);
  }

  ///邮箱验证
  static bool isEmail(String str) {
    return RegExp(r"^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$")
        .hasMatch(str);
  }

  ///验证URL
  static bool isUrl(String value) {
    return RegExp(r"^((https|http|ftp|rtsp|mms)?:\/\/)[^\s]+").hasMatch(value);
  }

  ///验证身份证
  static bool isIdCard(String value) {
    return RegExp(r"\d{17}[\d|x]|\d{15}").hasMatch(value);
  }

  ///验证中文
  static bool isChinese(String value) {
    return RegExp(r"[\u4e00-\u9fa5]").hasMatch(value);
  }
}

class JiaMi {
  static final parser = RSAKeyParser();

  static Future<String> jm(String text) async {
    final privateKeyString =
        await rootBundle.loadString('assets/pem/private.pem');
    final privateKey = parser.parse(privateKeyString);

    final encrypter = Encrypter(RSA(privateKey: privateKey));

    var decTetx = encrypter.decrypt64(text);

    return decTetx;
  }
}
