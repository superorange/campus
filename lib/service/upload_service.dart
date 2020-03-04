import 'package:dio/dio.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/service/base_service.dart';

class UploadService extends BaseService{


  Future<Response> uploadImages(var data)async{
    return dio.post(Api.goods,data: data).then((val){
      return val;
    },onError: (e){
      throw e;
    });
  }


}