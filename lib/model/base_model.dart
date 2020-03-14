class BaseModel {
  int code;
  String msg;
  String token;
  dynamic data;

  BaseModel({this.code, this.msg, this.token, this.data});

  BaseModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    token = json['token'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['token'] = this.token;
    data['data'] = this.data;
    return data;
  }
}
