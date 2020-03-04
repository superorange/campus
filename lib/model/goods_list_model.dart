class GoodsListModel {
  int code;
  String msg;
  String token;
  List<Data> data;

  GoodsListModel({this.code, this.msg, this.token, this.data});

  GoodsListModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    token = json['token'];
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int mainId;
  String userId;
  double gPrice;
  String gId;
  String gName;
  String gDec;
  List<String> gImages;
  int gStar;
  String createTime;
  String commentsId;
  String schoolLocation;
  String category;

  Data(
      {this.mainId,
        this.userId,
        this.gPrice,
        this.gId,
        this.gName,
        this.gDec,
        this.gImages,
        this.gStar,
        this.createTime,
        this.commentsId,
        this.schoolLocation,
        this.category});

  Data.fromJson(Map<String, dynamic> json) {
    mainId = json['mainId'];
    userId = json['userId'];
    gPrice = double.parse(json['gPrice'].toString());
    gId = json['gId'];
    gName = json['gName'];
    gDec = json['gDec'];
    gImages = json['gImages'].cast<String>();
    gStar = json['gStar'];
    createTime = json['createTime'];
    commentsId = json['commentsId'];
    schoolLocation = json['schoolLocation'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mainId'] = this.mainId;
    data['userId'] = this.userId;
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
    return data;
  }
}
