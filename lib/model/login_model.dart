class LoginModel {
  int code;
  String data;
  String phone;
  String password;
  String smsCode;
  LoginModel({this.code, this.data, this.password, this.phone, this.smsCode});
  LoginModel.fromJson(Map json) {
    code = json['code'];
    data = json['data'];
    phone = json['phone'];
    password = json['password'];
    smsCode = json['smsCode'];
  }
  Map toJson() => {
        'code': code,
        'data': data,
        'phone': phone,
        'password': password,
        'smsCode': smsCode
      };
}
