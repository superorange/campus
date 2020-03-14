class ChatModel {
  int code;
  String type;
  String mean;
  List<ChatMsg> chatMsg = [];

  ChatModel({this.code, this.type, this.mean, this.chatMsg});

  ChatModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    type = json['type'];
    mean = json['mean'];
    if (json['chatMsg'] != null) {
      chatMsg = new List<ChatMsg>();
      json['chatMsg'].forEach((v) {
        chatMsg.add(new ChatMsg.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['type'] = this.type;
    data['mean'] = this.mean;
    if (this.chatMsg != null) {
      data['chatMsg'] = this.chatMsg.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ChatMsg {
  String userId;
  String toId;
  String createTime;
  String msg;
  int sign;

  ChatMsg({this.userId, this.toId, this.createTime, this.msg, this.sign});

  ChatMsg.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    toId = json['toId'];
    createTime = json['createTime'];
    msg = json['msg'];
    sign = json['sign'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['toId'] = this.toId;
    data['createTime'] = this.createTime;
    data['msg'] = this.msg;
    data['sign'] = this.sign;
    return data;
  }
}
