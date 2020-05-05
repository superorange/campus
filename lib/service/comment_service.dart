import 'package:dio/dio.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/service/base_service.dart';

class CommentService extends BaseService{

  Future<Response> getGoodsComments(String gId){
    return dio.get(Api.goodsComment+'/$gId').then((val){
      return val;
    },onError: (e){
      throw e;
    });
  }
  Future<Response> addGoodsComments(Map data){
    return dio.post(Api.goodsComment,data: data).then((val){
      return val;
    },onError: (e){
      throw e;
    });
  }

}