import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/goods_list_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:oktoast/oktoast.dart';

class TradeVm extends BaseVm with ChangeNotifier {
  GoodsListModel goodsListModel;
  int _descending = 0;
  String schoolLocation = '';
  String _gName = '';
  bool _showSearch = true;
  String category = '';
  bool get showSearch => _showSearch;

  set showSearch(bool b) {
    _showSearch = b;
    notifyListeners();
  }

  Map<String, dynamic> getData() {
    return {
      'page': pageIndex,
      'schoolLocation': schoolLocation,
      'descending': _descending,
      'gName': _gName,
      'category': category
    };
  }

  @override
  Future<LoadState> loading({String gName, String schoolLocation}) async {
    if (gName != null) {
      _gName = gName;
    }
    if (schoolLocation != null) {
      this.schoolLocation = schoolLocation;
    }
    return GoodsService().getGoods(data: getData()).then((val) {
      if (val.data['code'] == 200) {
        var model = GoodsListModel.fromJson(val.data);
        goodsListModel = model;
        notifyListeners();
        if (model.goodsModel.isEmpty) {
          return LoadState.NullData;
        }
        return LoadState.LoadSuccess;
      }
      return LoadState.LoadFailed;
    }, onError: (e) {
      netState = false;
      notifyListeners();
      throw e;
    });
  }

  @override
  Future<LoadState> loadMore({String location, int sort}) {
    pageIndex++;
    return GoodsService().getGoods(data: getData()).then((val) {
      if (val.data['code'] == 200) {
        var model = GoodsListModel.fromJson(val.data);
        if (model.goodsModel.isEmpty) {
          pageIndex--;
          return LoadState.NullData;
        }
        goodsListModel.goodsModel.addAll(model.goodsModel);
        notifyListeners();
        return LoadState.LoadSuccess;
      }
      return LoadState.LoadFailed;
    }, onError: (e) {
      pageIndex--;

      throw e;
    });
  }
}
