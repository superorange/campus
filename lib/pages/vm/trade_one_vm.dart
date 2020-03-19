import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/one_goods_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:flutter_app/service/user_service.dart';
import 'package:oktoast/oktoast.dart';

class TradeOneVM extends BaseVm with ChangeNotifier {
  OneGoodsModel oneGoodsModel;
  String gId;
  TradeOneVM(this.gId);
  @override
  Future loading() async {
    GoodsService().getOneGood(gId).then((val) {
      BaseModel baseModel = BaseModel.fromJson(val.data);
      if (baseModel.code == 200) {
        oneGoodsModel = OneGoodsModel.fromJson(baseModel.data);
        notifyListeners();
      }
    }, onError: (e) {});
  }

  @override
  Future loadMore() {
    return null;
  }

  void userCollection() {
    var data = {
      'type': oneGoodsModel.uCollection ? 'cancle' : 'insert',
      'userId': oneGoodsModel.userId,
    };
    UserService().userCollection(data: data).then((val) {
      if (val.data['code'] == 200) {
        oneGoodsModel.uCollection = !oneGoodsModel.uCollection;
        notifyListeners();
      } else {
        showToast('更新失败');
      }
    });
  }

  void goodsCollection() {
    var data = {
      'type': oneGoodsModel.gCollection ? 'cancle' : 'insert',
      'gId': oneGoodsModel.gId,
    };
    UserService().goodsCollection(data: data).then((val) {
      if (val.data['code'] == 200) {
        oneGoodsModel.gCollection = !oneGoodsModel.gCollection;
        notifyListeners();
      } else {
        showToast('更新失败');
      }
    });
  }

  void goodsReport(String reason) {
    var data = {
      'reason': reason,
      'gId': oneGoodsModel.gId,
    };
    UserService().goodsReport(data: data).then((val) {
      if (val.data['code'] == 200) {
        showToast('举报成功，感谢你出一份力，我们将尽快核实');
        return;
      } else if (val.data['code'] == 202) {
        showToast('你已经举报过了，请不要重复举报');
        return;
      } else {
        showToast('未知错误');
      }
    });
  }
}
