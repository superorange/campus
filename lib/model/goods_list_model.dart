class GoodsListModel {
  int code;
  String msg;
  String token;
  List<GoodsModel> goodsModel;

  GoodsListModel({this.code, this.msg, this.token, this.goodsModel});

  GoodsListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    token = json['token'];
    if (json['data'] != null) {
      goodsModel = new List<GoodsModel>();
      json['data'].forEach((v) {
        goodsModel.add(new GoodsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['token'] = this.token;
    if (this.goodsModel != null) {
      data['data'] = this.goodsModel.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class GoodsModel {
  int id;
  String userId;
  String userName;
  String headPic;
  double gPrice;
  String gId;
  String gName;
  String gDec;
  String mainPic;
  List<String> gImages;
  int gStar;
  String createTime;
  String commentsId;
  String schoolLocation;
  String category;
  String sign;

  GoodsModel(
      {this.id,
      this.userId,
      this.userName,
      this.headPic,
      this.gPrice,
      this.gId,
      this.gName,
      this.gDec,
        this.mainPic,
      this.gImages,
      this.gStar,
      this.createTime,
      this.commentsId,
      this.schoolLocation,
      this.category,
      this.sign});

  GoodsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    headPic = json['headPic'];
    gPrice = json['gPrice'];
    gId = json['gId'];
    gName = json['gName'];
    gDec = json['gDec'];
    gImages = json['gImages'].cast<String>();
    gStar = json['gStar'];
    createTime = json['createTime'];
    commentsId = json['commentsId'];
    schoolLocation = json['schoolLocation'];
    category = json['category'];
    sign = json['sign'];
    mainPic=json['mainPic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['headPic'] = this.headPic;
    data['gPrice'] = this.gPrice;
    data['gId'] = this.gId;
    data['gName'] = this.gName;
    data['gDec'] = this.gDec;
    data['gImages'] = this.gImages;
    data['gStar'] = this.gStar;
    data['createTime'] = this.createTime;
    data['commentsId'] = this.commentsId;
    data['schoolLocation'] = this.schoolLocation;
    data['category'] = this.category;
    data['sign'] = this.sign;
    data['mainPic']=mainPic;
    return data;
  }
}
