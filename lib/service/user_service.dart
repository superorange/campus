import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/service/base_service.dart';

class UserService extends BaseService {
  Future<Response> validate() {
    return dio.post(Api.validate).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> smsLogin({@required var data}) {
    return dio.post(Api.smsLogin, data: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> pwdLogin({@required var data}) {
    return dio.post(Api.pwdLogin, data: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> autoLogin({@required var data}) {
    return dio.post(Api.autoLogin, data: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> updateUser({@required var data}) {
    return dio.put(Api.user, data: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> userCollection({@required var data}) {
    return dio.get(Api.userCollection, queryParameters: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> goodsCollection({@required var data}) {
    return dio.get(Api.goodsCollection, queryParameters: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> goodsReport({@required var data}) {
    return dio.get(Api.goodsReport, queryParameters: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }
}
