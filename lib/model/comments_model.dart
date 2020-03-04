class FirstCommentsModel {
  String postId;
  List<Comments> comments;

  FirstCommentsModel({this.postId, this.comments});

  FirstCommentsModel.fromJson(Map<String, dynamic> json) {
    postId = json['postId'];
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['postId'] = this.postId;
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comments {
  String userId;
  int sex;
  String headPic;
  String userName;
  String msg;
  int replyCount;
  String toWho;
  int createTime;
  String commentId;
  String indexId;

  Comments(
      {this.userId,
        this.sex,
        this.headPic,
        this.userName,
        this.msg,
        this.replyCount,
        this.toWho,
        this.createTime,
        this.commentId,
        this.indexId});

  Comments.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    sex = json['sex'];
    headPic = json['headPic'];
    userName = json['userName'];
    msg = json['msg'];
    replyCount = json['replyCount'];
    toWho = json['toWho'];
    createTime = json['createTime'];
    commentId = json['commentId'];
    indexId = json['indexId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['sex'] = this.sex;
    data['headPic'] = this.headPic;
    data['userName'] = this.userName;
    data['msg'] = this.msg;
    data['replyCount'] = this.replyCount;
    data['toWho'] = this.toWho;
    data['createTime'] = this.createTime;
    data['commentId'] = this.commentId;
    data['indexId'] = this.indexId;
    return data;
  }
}

class MoreCommentsModel {
  String commentId;
  String indexId;
  int replyCount;
  List<ReplyLists> replyLists;

  MoreCommentsModel(
      {this.commentId, this.indexId, this.replyCount, this.replyLists});

  MoreCommentsModel.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    indexId = json['indexId'];
    replyCount = json['replyCount'];
    if (json['replyLists'] != null) {
      replyLists = new List<ReplyLists>();
      json['replyLists'].forEach((v) {
        replyLists.add(new ReplyLists.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['indexId'] = this.indexId;
    data['replyCount'] = this.replyCount;
    if (this.replyLists != null) {
      data['replyLists'] = this.replyLists.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReplyLists {
  String userId;
  int sex;
  String headPic;
  String userName;
  String msg;
  String toWho;
  int createTime;
  String commentId;

  ReplyLists(
      {this.userId,
        this.sex,
        this.headPic,
        this.userName,
        this.msg,
        this.toWho,
        this.createTime,
        this.commentId});

  ReplyLists.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    sex = json['sex'];
    headPic = json['headPic'];
    userName = json['userName'];
    msg = json['msg'];
    toWho = json['toWho'];
    createTime = json['createTime'];
    commentId = json['commentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['sex'] = this.sex;
    data['headPic'] = this.headPic;
    data['userName'] = this.userName;
    data['msg'] = this.msg;
    data['toWho'] = this.toWho;
    data['createTime'] = this.createTime;
    data['commentId'] = this.commentId;
    return data;
  }
}


