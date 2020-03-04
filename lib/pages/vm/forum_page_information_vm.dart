import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/comments_model.dart';
import 'package:flutter_app/model/forum_page_posts_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/service/forum_page_service.dart';

class ForumPageInformationVm extends BaseVm with ChangeNotifier{
  ForumPagePostsModel forumPagePostsModel;
  FirstCommentsModel firstCommentsModel;
  Map<int,MoreCommentsModel> _moreCommentsModel={};
  Map<int,MoreCommentsModel> get mapMoreCommentsModel=>_moreCommentsModel;
  Map<int,bool> mapExpansion={};




  @override
  Future loading() {
    // TODO: implement loading
    return null;
  }

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return null;
  }



}


