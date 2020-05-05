class CommentsModel {
  int code;
  String msg;
  String token;
  List<Comment> comment;

  CommentsModel({this.code, this.msg, this.token, this.comment});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    msg = json['msg'];
    token = json['token'];
    if (json['data'] != null) {
      comment = new List<Comment>();
      json['data'].forEach((v) {
        comment.add(new Comment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['msg'] = this.msg;
    data['token'] = this.token;
    if (this.comment != null) {
      data['data'] = this.comment.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Comment {
  String commentId;
  String toCommentId;
  String userName;
  String userId;
  String gId;
  String toId;
  String createTime;
  String headPic;
  String text;
  String toUserName;

  Comment(
      {this.commentId,
        this.toCommentId,
        this.userName,
        this.userId,
        this.gId,
        this.toId,
        this.createTime,
        this.headPic,
        this.text});

  Comment.fromJson(Map<String, dynamic> json) {
    commentId = json['commentId'];
    toCommentId = json['toCommentId'];
    userName = json['userName'];
    userId = json['userId'];
    gId = json['gId'];
    toId = json['toId'];
    createTime = json['createTime'];
    headPic = json['headPic'];
    text = json['text'];
    toUserName=json['toUserName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['commentId'] = this.commentId;
    data['toCommentId'] = this.toCommentId;
    data['userName'] = this.userName;
    data['userId'] = this.userId;
    data['gId'] = this.gId;
    data['toId'] = this.toId;
    data['createTime'] = this.createTime;
    data['headPic'] = this.headPic;
    data['text'] = this.text;
    data['toUserName']=this.toUserName;
    return data;
  }
}
