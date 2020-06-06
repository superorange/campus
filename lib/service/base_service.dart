import 'package:dio/dio.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/utils/print_utils.dart';

class BaseService {
  Dio dio;
  var token;
  BaseOptions baseOptions;
  BaseService() {
    baseOptions = BaseOptions(
      baseUrl: Api.baseUrl,
      receiveTimeout: 6000,
      connectTimeout: 5000,
      receiveDataWhenStatusError: true,
      headers: {'Authorization': Api.token},
    );
    dio = Dio(baseOptions);
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (res) {
        Log.pt(flag: res.method, msg: res.uri);
        Log.pt(flag: 'Header', msg: res.headers,);
        Log.pt(msg: res.queryParameters, flag: 'queryParameters');
        Log.pt(msg: res.data, flag: 'data');
      },
      onResponse: (res) {
        Log.pt(flag: '收到数据', msg: res.data);
      },
    onError: (res){
      Log.pt(flag: '网络出错', msg: res.error);
    }
    ));
  }
}
