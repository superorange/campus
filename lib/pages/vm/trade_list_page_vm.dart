
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/goods_list_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:oktoast/oktoast.dart';

class TradeListPageVm extends BaseVm with ChangeNotifier{
  GoodsListModel goodsListModel;
  int _page = 1;
  int _count =20;
  int _sort = 0;
  String schoolLocation='';
  String _gName='';
  bool _showSearch = true;
  String category = '';
  bool get showSearch =>_showSearch;
  set showSearch(bool b){
    _showSearch=b;
    notifyListeners();
  }
  Map<String,dynamic> getData(){
    return {
      'page':_page,
      'count':_count,
      'schoolLocation':schoolLocation,
      'sort':_sort,
      'gName':_gName,
      'category':category
    };
  }



  @override
  Future<LoadState> loading({String gName,String schoolLocation}) {
    _gName=gName??'';
    schoolLocation=schoolLocation??'';
   return GoodsService().getGoodsList(data: getData()).then((val){
      netState=true;
      BaseModel baseModel=BaseModel.fromJson(val.data);
      if(baseModel.code==200){
        var model = GoodsListModel.fromJson(val.data);
        goodsListModel=model;
        notifyListeners();
        if(model.data.isEmpty){
          return LoadState.NullData;
        }
        return LoadState.LoadSuccess;
      }
      return LoadState.LoadFailed;
    },onError: (e){
      showToast('++++++:出错啦:++++++ \n${(e as DioError).message}',
          textStyle: TextStyle(color: Colors.red));
      netState=false;
      notifyListeners();
      throw e;
    });

  }

  @override
  Future<LoadState> loadMore({String location,int sort}) {
    _page++;
    return GoodsService().getGoodsList(data:getData() ).then((val){
      BaseModel baseModel=BaseModel.fromJson(val.data);
      if(baseModel.code==200){
        var model = GoodsListModel.fromJson(val.data);

        if(model.data.isEmpty){
          showToast('没有更多啦！');
          _page--;
          return LoadState.NullData;
        }
        goodsListModel.data.addAll(model.data);
        notifyListeners();
        return LoadState.LoadSuccess;
      }
      return LoadState.LoadFailed;
    },onError: (e){
      _page--;
      showToast('出错啦:$e');
      throw e;
    });
  }




}