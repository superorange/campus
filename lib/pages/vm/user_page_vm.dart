import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/goods_list_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/user_service.dart';

class UserPageVm extends BaseVm with ChangeNotifier{
  UserModel userModel;
  GoodsListModel goodsListModel;
  @override
  Future loadMore() {
    // TODO: implement loadMore
    return null;
  }

  @override
  Future loading({String userId}) {
    UserService().getUser(userId).then((val){
      if(val.data['code']==200){
        userModel=UserModel.fromJson(val.data['data']);
        notifyListeners();
      }
    });
    return null;
  }
  void loadGoods(String userId){
    UserService().myGoods(userId).then((val){
      if(val.data['code']==200){
        goodsListModel=GoodsListModel.fromJson(val.data);
        notifyListeners();
      }
    });
  }





}