
import 'package:dio/dio.dart';
import 'package:flutter_app/service/base_service.dart';

class HomePageService extends BaseService{



  Future<Response> getHomePageSwiper(){
    var data={
      'key':'e8fe01a770583ce1309f74d614a7cf56',
      'num':4
    };
    dio.options.baseUrl='http://api.tianapi.com/meinv/index';
    return dio.get('',queryParameters: data,options:Options(

    ) ).then((val){
      return val;
    },onError: (e){
      throw e;
    });
  }


}