import 'package:dio/dio.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/service/base_service.dart';

class GoodsService extends BaseService {
  Future<Response> getGoods({var data}) {
    return dio.get(Api.good, queryParameters: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> getOneGood(String gId) {
    return dio.get(Api.good + '/$gId').then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> deleteGood(String gId) {
    return dio.delete(Api.good + '/$gId').then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> updateGood(String gId, Map data) {
    return dio.put(Api.good + '/$gId', data: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> addGood(Map data) {
    return dio.post(Api.good, data: data).then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }

  Future<Response> getImageToken() async {
    return dio.post(Api.imageKey).then((val) {
      return val;
    }, onError: (e) {
      return e;
    });
  }
}
