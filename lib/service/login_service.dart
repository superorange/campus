import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/service/base_service.dart';

class LoginService extends BaseService{

    Future<Response> startLogin({@required var data}){
    return dio.post(Api.login,data: data).then((val){
      return val;
    },onError: (e){
      throw e;
    });
  }




}



