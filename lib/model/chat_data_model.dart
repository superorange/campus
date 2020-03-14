class ChatDataModel {
  String userId;

  String headPic;
  String userName;

  ChatDataModel({this.userId, this.headPic, this.userName});

  ChatDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    headPic = json['headPic'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['headPic'] = this.headPic;
    data['userName'] = this.userName;
    return data;
  }
}
