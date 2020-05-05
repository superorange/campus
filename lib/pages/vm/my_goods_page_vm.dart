import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/model/goods_list_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/user_service.dart';

class MyGoodsPageVm extends BaseVm with ChangeNotifier{

  GoodsListModel goodsListModel;
  @override
  Future loadMore() {

    return null;
  }

  @override
  Future loading(){
    UserService().myGoods(Api.userId).then((val){
      if(val.data['code']==200){
        goodsListModel=GoodsListModel.fromJson(val.data);
        notifyListeners();
      }
    });
    return  null;
  }
  void deleteMyGoods(String gId){
    var data = {
      'gId': gId,
    };
    UserService().deleteMyGoods(data).then((val){
      if(val.data['code']==200){
        loading();
      }
    });

  }

}