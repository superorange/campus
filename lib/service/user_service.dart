import 'package:flutter_app/service/base_service.dart';

class UserService extends BaseService{


   Future getUserInformation(){
    return dio.post('').then((val){
      return val;
    },onError: (e){
      throw Exception(e);
    });
  }


}