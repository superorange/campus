class UpdateInformationModel {
  UpdateInformationModel(
      {this.type,
      this.username,
      this.headPic,
      this.name,
      this.majorName,
      this.grade,
      this.phone,
      this.uClass,
      this.password,
      this.sex,
      this.location,
      this.schoolLocation,
      this.xh,
      this.goodsCount,
      this.userId,
      this.sign});
  String type;
  String username;
  String headPic;
  String name;
  String majorName;
  int grade;
  String phone;
  int uClass;
  String password;
  int sex;
  String location;
  String schoolLocation;
  String xh;
  int goodsCount;
  String sign;
  String userId;

  UpdateInformationModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    username = json['username'];
    headPic = json['headPic'];
    name = json['name'];
    majorName = json['majorName'];
    grade = json['grade'];
    phone = json['phone'];
    uClass = json['uClass'];
    password = json['password'];
    sex = json['sex'];
    location = json['location'];
    schoolLocation = json['schoolLocation'];
    xh = json['xh'];
    goodsCount = json['goodsCount'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['type'] = type;
    data['username'] = username;
    data['headPic'] = headPic;
    data['name'] = name;
    data['majorName'] = majorName;
    data['grade'] = grade;
    data['phone'] = phone;
    data['uClass'] = uClass;
    data['password'] = password;
    data['sex'] = sex;
    data['location'] = location;
    data['schoolLocation'] = schoolLocation;
    data['xh'] = xh;
    data['goodsCount'] = goodsCount;
    data['sign'] = sign;
    return data;
  }
}
