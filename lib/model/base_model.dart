class BaseModel {
  int code;
  String msg;
  String token;
//  Data data;

  BaseModel({this.code, this.msg, this.token, });

  BaseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    token = json['token'];
//    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['token'] = this.token;
//    if (this.data != null) {
//      data['data'] = this.data.toJson();
//    }
    return data;
  }
}

//class Data {
//  String userId;
//  Null username;
//  Null name;
//  Null majorName;
//  String phone;
//  Null grade;
//  Null uClass;
//  String password;
//  Null sex;
//  Null location;
//  Null schoolLocation;
//  Null headPic;
//  Null xh;
//  Null goodsCount;
//  Null sign;
//  int isForbidden;
//  String createTime;
//
//  Data(
//      {this.userId,
//        this.username,
//        this.name,
//        this.majorName,
//        this.phone,
//        this.grade,
//        this.uClass,
//        this.password,
//        this.sex,
//        this.location,
//        this.schoolLocation,
//        this.headPic,
//        this.xh,
//        this.goodsCount,
//        this.sign,
//        this.isForbidden,
//        this.createTime});
//
//  Data.fromJson(Map<String, dynamic> json) {
//    userId = json['userId'];
//    username = json['username'];
//    name = json['name'];
//    majorName = json['majorName'];
//    phone = json['phone'];
//    grade = json['grade'];
//    uClass = json['uClass'];
//    password = json['password'];
//    sex = json['sex'];
//    location = json['location'];
//    schoolLocation = json['schoolLocation'];
//    headPic = json['headPic'];
//    xh = json['xh'];
//    goodsCount = json['goodsCount'];
//    sign = json['sign'];
//    isForbidden = json['isForbidden'];
//    createTime = json['createTime'];
//  }
//
//  Map<String, dynamic> toJson() {
//    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['userId'] = this.userId;
//    data['username'] = this.username;
//    data['name'] = this.name;
//    data['majorName'] = this.majorName;
//    data['phone'] = this.phone;
//    data['grade'] = this.grade;
//    data['uClass'] = this.uClass;
//    data['password'] = this.password;
//    data['sex'] = this.sex;
//    data['location'] = this.location;
//    data['schoolLocation'] = this.schoolLocation;
//    data['headPic'] = this.headPic;
//    data['xh'] = this.xh;
//    data['goodsCount'] = this.goodsCount;
//    data['sign'] = this.sign;
//    data['isForbidden'] = this.isForbidden;
//    data['createTime'] = this.createTime;
//    return data;
//  }
//}
