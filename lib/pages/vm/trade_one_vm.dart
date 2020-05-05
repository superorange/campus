import 'package:flutter/cupertino.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/comments.dart';
import 'package:flutter_app/model/one_goods_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/comment_service.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:flutter_app/service/user_service.dart';
import 'package:oktoast/oktoast.dart';

class TradeOneVM extends BaseVm with ChangeNotifier {
  OneGoodsModel oneGoodsModel;
  String gId;
  TradeOneVM(this.gId);
  List<Comment> comments;
  List<Comment> firstComments=[];
  List<Comment> secondComments = [];
  String _toUser;
  String toId='';
  String toCommentId='';
  String get toUser=>_toUser;
  set toUser(String s){
    if(_toUser!=s){
      _toUser=s;
      notifyListeners();
    }
  }
  bool _showKeyboard=false;
  bool get showKeyboard =>_showKeyboard;
  set showKeyboard(bool b){
    if(_showKeyboard!=b){
      _showKeyboard=b;
      notifyListeners();
    }
  }
  @override
  Future loading() async {
    GoodsService().getOneGood(gId).then((val) {
      BaseModel baseModel = BaseModel.fromJson(val.data);
      if (baseModel.code == 200) {
        oneGoodsModel = OneGoodsModel.fromJson(baseModel.data);

        CommentService().getGoodsComments(gId).then((val){
          if(val.data['code']==200){
            comments=CommentsModel.fromJson(val.data).comment;
            firstComments=comments.where((t)=>t.toCommentId.isEmpty).toList();
            secondComments=comments.where((t)=>t.toCommentId.isNotEmpty).toList();
            notifyListeners();
            return;
          }
        });
      }

    }, onError: (e) {
      print('e');
      showToast('加载失败，请重试');

    });
  }
  void addComment(String text){
    var data={
      'userId':Api.userId,
      'text':text,
      'toId':toId,
      'gId':oneGoodsModel.gId,
      'toCommentId':toCommentId
    };
    CommentService().addGoodsComments(data).then((val){
      if(val.data['code']==200){
        CommentService().getGoodsComments(gId).then((val){
          if(val.data['code']==200){
            comments=CommentsModel.fromJson(val.data).comment;
            firstComments=comments.where((t)=>t.toCommentId.isEmpty).toList();
            secondComments=comments.where((t)=>t.toCommentId.isNotEmpty).toList();
            notifyListeners();
            return;
          }
        });
      }
      else{
        showToast('留言失败');
      }
    });
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
