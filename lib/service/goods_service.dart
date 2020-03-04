import 'package:dio/dio.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/service/base_service.dart';

class GoodsService extends BaseService{
  
  Future<Response> getGoodsList({var data}){
    return dio.get(Api.goods,queryParameters: data??{}).then((val){
      return val;
    },onError: (e){
      throw e;
    });
  }
  
  
}