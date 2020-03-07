class ChattersModel {
  int code;
  String type;
  String mean;
  List<Chatters> chatters;

  ChattersModel({this.code, this.type, this.mean, this.chatters});

  ChattersModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    type = json['type'];
    mean = json['mean'];
    if (json['chatters'] != null) {
      chatters = new List<Chatters>();
      json['chatters'].forEach((v) {
        chatters.add(new Chatters.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    data['mean'] = this.mean;
    if (this.chatters != null) {
      data['chatters'] = this.chatters.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chatters {
  int id;
  String userId;
  String toId;
  int createTime;
  String userName;
  String headPic;

  Chatters(
      {this.id,
        this.userId,
        this.toId,
        this.createTime,
        this.userName,
        this.headPic});

  Chatters.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    toId = json['toId'];
    createTime = json['createTime'];
    userName = json['userName'];
    headPic = json['headPic'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['toId'] = this.toId;
    data['createTime'] = this.createTime;
    data['userName'] = this.userName;
    data['headPic'] = this.headPic;
    return data;
  }
}
