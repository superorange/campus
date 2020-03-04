import 'package:flutter/material.dart';
import 'package:flutter_app/model/forum_page_posts_model.dart';

import 'base_vm.dart';

class ForumPageVm extends BaseVm with ChangeNotifier{
  ForumPagePostsModel forumPagePostsModel;
  double _opacity=1.0;
  double get opacity=>_opacity;

  @override
  Future loadMore() {
    // TODO: implement loadMore
    return null;
  }

  @override
  Future loading() {
    // TODO: implement loading
    return null;
  }





}