import 'dart:io';

class Api {
//  static String url = 'http:  192.168.1.121:100';
  static String url = 'http://vps-jdy.ifree.top:100';
  static String baseUrl = 'http://${url.substring(7)}';
  static String ws = 'ws://${url.substring(7)}';
  static const smsLogin = '/api/user/login/sms';
  static const pwdLogin = '/api/user/login/pwd';
  static const autoLogin = '/api/user/login/auto';
  static const validate = '/api/user/validate';
  static const chat = '/api/user/chat';
  static const imageKey = '/api/goods/imageskey';
  static const user = '/api/user';
  static const good = '/api/goods';
  static const goodsComment = '/api/comment/goods';
  static const userCollection = '/api/user/collect';
  static const goodsCollection = '/api/goods/collect';
  static const goodsReport = '/api/goods/report';
  static const myGoods = '/api/user/goods';
  static const qiNiu = 'http://upload-z2.qiniup.com';
  static String token = '';
  static String userId = '';
  static const JLoginKEy='477d2dad7d19abe2ae0b42f6';
  static init() {
    if (Platform.isAndroid) {
//      url = 'http:  10.0.2.2:100';
    }

  }

}
