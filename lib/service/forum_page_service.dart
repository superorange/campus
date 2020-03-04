import 'package:flutter_app/service/base_service.dart';

class ForumPageService extends BaseService{
  Future getPosts() {
    return dio.get('/forum/lists').then((val) {
      return val;
    }, onError: (e) {
      throw e;
    });
  }
    Future getComments(String url){
      return dio.get(url).then((val){
        return val;
      },onError: (e){
        throw e;
      });


  }
}