
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/goods_list_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:oktoast/oktoast.dart';

class TradeInformationVm extends BaseVm with ChangeNotifier{
  GoodsListModel goodsListModel;
  String gID;
  TradeInformationVm(this.gID);
  @override
  Future loading()async{
    var data={
      'gId':gID
    };
    GoodsService().getGoodsList(data: data).then((val){
      BaseModel baseModel=BaseModel.fromJson(val.data);
      if(baseModel.code==200){
        goodsListModel=GoodsListModel.fromJson(val.data);
        notifyListeners();
      }
    },onError: (e){
      showToast('出错啦:$e');
    });
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return null;
  }







}