class UserModel {
  int id;
  String userId;
  String userName;
  String phone;
  int grade;
  int uClass;
  String password;
  int sex;
  String name;
  String majorName;
  String location;
  String schoolLocation;
  String headPic;
  String xh;
  String sign;
  int goodsCount;
  int collection;
  int fans;
  int post;
  int isForbidden;
  String createTime;

  UserModel(
      {this.id,
      this.userId,
      this.userName,
      this.phone,
      this.grade,
      this.uClass,
      this.password,
      this.sex,
      this.name,
      this.majorName,
      this.location,
      this.schoolLocation,
      this.headPic,
      this.xh,
      this.sign,
      this.goodsCount,
      this.collection,
      this.fans,
      this.post,
      this.isForbidden,
      this.createTime});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    userName = json['userName'];
    phone = json['phone'];
    grade = json['grade'];
    uClass = json['uClass'];
    password = json['password'];
    sex = json['sex'];
    name = json['name'];
    majorName = json['majorName'];
    location = json['location'];
    schoolLocation = json['schoolLocation'];
    headPic = json['headPic'];
    xh = json['xh'];
    sign = json['sign'];
    goodsCount = json['goodsCount'];
    collection = json['collection'];
    fans = json['fans'];
    post = json['post'];
    isForbidden = json['isForbidden'];
    createTime = json['createTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['phone'] = this.phone;
    data['grade'] = this.grade;
    data['uClass'] = this.uClass;
    data['password'] = this.password;
    data['sex'] = this.sex;
    data['name'] = this.name;
    data['majorName'] = this.majorName;
    data['location'] = this.location;
    data['schoolLocation'] = this.schoolLocation;
    data['headPic'] = this.headPic;
    data['xh'] = this.xh;
    data['sign'] = this.sign;
    data['goodsCount'] = this.goodsCount;
    data['collection'] = this.collection;
    data['fans'] = this.fans;
    data['post'] = this.post;
    data['isForbidden'] = this.isForbidden;
    data['createTime'] = this.createTime;
    return data;
  }
}
