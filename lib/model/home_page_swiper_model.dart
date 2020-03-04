class HomePageSwiperModel {
  int code;
  String msg;
  List<Newslist> newslist;

  HomePageSwiperModel({this.code, this.msg, this.newslist});

  HomePageSwiperModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    if (json['newslist'] != null) {
      newslist = new List<Newslist>();
      json['newslist'].forEach((v) {
        newslist.add(new Newslist.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    if (this.newslist != null) {
      data['newslist'] = this.newslist.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Newslist {
  String ctime;
  String title;
  String description;
  String picUrl;
  String url;

  Newslist({this.ctime, this.title, this.description, this.picUrl, this.url});

  Newslist.fromJson(Map<String, dynamic> json) {
    ctime = json['ctime'];
    title = json['title'];
    description = json['description'];
    picUrl = json['picUrl'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ctime'] = this.ctime;
    data['title'] = this.title;
    data['description'] = this.description;
    data['picUrl'] = this.picUrl;
    data['url'] = this.url;
    return data;
  }
}
