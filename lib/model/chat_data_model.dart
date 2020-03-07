class ChatDataModel {
  String userId;
  String toId;
  String headPic;
  String userName;

  ChatDataModel({this.userId, this.toId, this.headPic, this.userName});

  ChatDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    toId = json['toId'];
    headPic = json['headPic'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['toId'] = this.toId;
    data['headPic'] = this.headPic;
    data['userName'] = this.userName;
    return data;
  }
}
