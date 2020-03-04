class ForumPagePostsModel {
  int code;
  String msg;
  List<Data> data;

  ForumPagePostsModel({this.code, this.msg, this.data});

  ForumPagePostsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
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
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String userId;
  int sex;
  int createTime;
  String location;
  int isFocus;
  String text;
  List<String> images;
  int forwardCount;
  int commentCount;
  int goodCount;

  Data(
      {this.userId,
        this.sex,
        this.createTime,
        this.location,
        this.isFocus,
        this.text,
        this.images,
        this.forwardCount,
        this.commentCount,
        this.goodCount});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    sex = json['sex'];
    createTime = json['createTime'];
    location = json['location'];
    isFocus = json['isFocus'];
    text = json['text'];
    images = json['images']?.cast<String>();
    forwardCount = json['forwardCount'];
    commentCount = json['commentCount'];
    goodCount = json['goodCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['sex'] = this.sex;
    data['createTime'] = this.createTime;
    data['location'] = this.location;
    data['isFocus'] = this.isFocus;
    data['text'] = this.text;
    data['images'] = this.images;
    data['forwardCount'] = this.forwardCount;
    data['commentCount'] = this.commentCount;
    data['goodCount'] = this.goodCount;
    return data;
  }
}
