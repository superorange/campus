
import 'package:dio/dio.dart';
import 'package:flutter_app/service/base_service.dart';


class MiMaService extends BaseService{


  Future<Response> getImageToken()async{
    return dio.post('/images/token').then((val){
      return val;
    },onError: (e){
      return e;
    });
  }

}