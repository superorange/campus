import 'package:dio/dio.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/utils/print_utils.dart';
import 'package:flutter_app/utils/login_auth.dart';

class BaseService{
  Dio dio;
  var token;
   BaseOptions baseOptions;
  BaseService(){
    baseOptions=BaseOptions(
      baseUrl: Api.baseUrl,
      receiveTimeout: 6000,
      connectTimeout: 5000,
      headers: {
        'Authorization':
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1ODI5NzcxNTcsImlhdCI6MTU4Mjg5MDc1NywianRpIjoiMTU4Mjg5MDc1NzY0OTQwNDQyMjM3NjE1NzU3ODg4IiwicGxkIjp7ImNyZWF0ZVRpbWUiOiIxNTgyODkwNzU3NjQ5NDA0IiwiZ29vZHNDb3VudCI6bnVsbCwiZ3JhZGUiOm51bGwsImhlYWRQaWMiOm51bGwsImlzRm9yYmlkZGVuIjowLCJsb2NhdGlvbiI6bnVsbCwibWFpbklkIjoxLCJtYWpvck5hbWUiOm51bGwsIm5hbWUiOm51bGwsInBhc3N3b3JkIjoiMTU4Mjg5MDc1NzY0OTQwNDQyMjM3NjE1NzUiLCJwaG9uZSI6IjEzMTA4MDg0NDM5Iiwic2Nob29sTG9jYXRpb24iOm51bGwsInNleCI6bnVsbCwic2lnbiI6bnVsbCwidUNsYXNzIjpudWxsLCJ1c2VySWQiOiIxNTgyODkwNzU3NjQ5NDA0NDIyMzc2MTU3NTc4ODgiLCJ1c2VybmFtZSI6bnVsbCwieGgiOm51bGx9LCJzdWIiOiJsb2dpbiJ9.OwSr2rneZWuoiOIaAbOdkKuBQBwj5TlkClLpo8Jt4qw'
      },
    );
    dio=Dio(baseOptions);
    dio.interceptors.add(InterceptorsWrapper(
//      onRequest: (res){
//        Log.pt(flag: res.method, msg: res.uri);
//        Log.pt(msg: res.queryParameters,flag: 'queryParameters');
//        Log.pt(msg: res.data,flag: 'data');
//      },
//      onResponse: (res){
//        Log.pt(flag: '收到数据', msg: res.data);
//    },
//    onError: (res){
//      Log.pt(flag: '网络出错', msg: res.response.data);
//    }
    ));
  }
  void init()async{
    token=await LoginAuth().getToken()??'';
  }

}