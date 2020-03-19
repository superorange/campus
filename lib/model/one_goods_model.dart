class OneGoodsModel {
  int id;
  String userId;
  String userName;
  String headPic;
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
  String sign;
  bool gCollection;
  bool uCollection;

  OneGoodsModel(
      {this.id,
      this.userId,
      this.userName,
      this.headPic,
      this.gPrice,
      this.gId,
      this.gName,
      this.gDec,
      this.gImages,
      this.gStar,
      this.createTime,
      this.commentsId,
      this.schoolLocation,
      this.category,
      this.sign,
      this.gCollection,
      this.uCollection});

  OneGoodsModel.fromJson(Map<String, dynamic> json) {
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
    gCollection = json['gCollection'];
    uCollection = json['uCollection'];
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
    data['gCollection'] = this.gCollection;
    data['uCollection'] = this.uCollection;
    return data;
  }
}
