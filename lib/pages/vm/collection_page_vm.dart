import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/goods_list_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/user_service.dart';

class CollectionPageVm extends BaseVm  with ChangeNotifier{
  GoodsListModel goodsListModel;
  @override
  Future loadMore() {

    return null;
  }

  @override
  Future loading({String userId}) {
    UserService().getGoodsCollection(userId: userId).then((val){
      if(val.data['code']==200){
        goodsListModel=GoodsListModel.fromJson(val.data);
        notifyListeners();
      }
    });
    return  null;
  }
  void deleteCollection(String gId,String userId){
    var data = {
      'type': 'cancle' ,
      'gId': gId,
    };
    UserService().goodsCollection(data: data).then((val){
      if(val.data['code']==200){
        loading(userId: userId);
      }
    });

  }





}




