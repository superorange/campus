class ChatDataModel {
  String toId;

  String headPic;
  String userName;

  ChatDataModel({this.toId, this.headPic, this.userName});

  ChatDataModel.fromJson(Map<String, dynamic> json) {
    toId = json['toId'];
    headPic = json['headPic'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.toId;
    data['headPic'] = this.headPic;
    data['userName'] = this.userName;
    return data;
  }
}
