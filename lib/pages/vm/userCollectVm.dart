import 'package:flutter/cupertino.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/user_service.dart';
import 'package:oktoast/oktoast.dart';
class UserCollectionModel{
  String userId;
  String userName;
  String headPic;
  UserCollectionModel.fromJson(Map json){
    userId=json['userId'];
    userName=json['userName'];
    headPic=json['headPic'];
  }
}
class UserCollectVm with ChangeNotifier{
 List<UserCollectionModel> models;

  bool isDispose=false;
  Future getUsers(){
    UserService().getUserCollection().then((value) {
      print(value.data);
      if(value.data['code']==200){
        (value.data['data'] as List).forEach((element) {
          models??=[];
          models.add(UserCollectionModel.fromJson(element));
        });
        Future.microtask(()=>notifyListeners());
      }
    });

  }
 Future delete(String id){
   var data = {
     'type': 'cancle',
     'userId': id,
   };
   UserService().userCollection(data: data).then((val) {
     if (val.data['code'] == 200) {
       models.clear();
       getUsers();
     } else {
       showToast('更新失败');
     }
   });
 }


  @override
  void notifyListeners() {
    if(isDispose){
      return;
    }
    super.notifyListeners();
  }
  @override
  void dispose() {
    isDispose=true;
    super.dispose();
  }


}