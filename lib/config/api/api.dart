import 'dart:io';

class Api {
//  static const baseUrl = 'http://api.ifree.top:8899';
  static String url = '127.0.0.1';
  static String baseUrl = 'http://$url:100';
  static String socketUrl = 'ws://$url:100';
  static const smsLogin = '/api/user/login/sms';
  static const pwdLogin = '/api/user/login/pwd';
  static const autoLogin = '/api/user/login/auto';
  static const validate = '/api/user/validate';
  static const chat = '/api/user/chat';
  static const imageKey = '/api/goods/imageskey';
  static const user = '/api/user';
  static const good = '/api/goods';

  static String token = '';
  static String userId = '';
  static init() {
    if (Platform.isAndroid) {
      url = '10.0.2.2';
    }
  }
}
