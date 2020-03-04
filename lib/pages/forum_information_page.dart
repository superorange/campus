import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/forum_page_information_vm.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:provider/provider.dart';

class ForumInformationPage extends StatefulWidget {
  String id;
  int index;

  ForumInformationPage({this.id, this.index});

  @override
  _ForumInformationPageState createState() => _ForumInformationPageState();
}

class _ForumInformationPageState extends State<ForumInformationPage> {
  ScrollController _scrollController = ScrollController();
  ForumPageInformationVm _forumPageInformationVm = ForumPageInformationVm();
  TextEditingController _textEditingController=TextEditingController();
  FocusNode _focusNode=FocusNode();
  @override
  void initState() {
//    _forumPageInformationVmInformationVm..firstLoading()..getComments();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _forumPageInformationVm,
        child: GestureDetector(
          onHorizontalDragEnd: (end) {
//            Navigator.pop(context);
          },
          child: Scaffold(
//              floatingActionButton: FloatingActionButton(
//                onPressed: () {
//                  _scrollController.animateTo(.0,
//                      duration: Duration(seconds: 2),
//                      curve: Curves.fastOutSlowIn);
//                },
//                child: Icon(Icons.vertical_align_top),
//              ),
              appBar: AppBar(
                automaticallyImplyLeading: true,
                title: Text('正文'),
                elevation: .0,
                actions: <Widget>[
                  IconButton(icon: Icon(Icons.more_horiz), onPressed: (){
                    showModalBottomSheet(context: context, builder: (context){
                      return CupertinoActionSheet(
                        message: Column(
                          children: <Widget>[
                            Container(
                              height: setHeight(60),
                              child: InkWell(
                                onTap: (){

                                },
                                child: Center(
                                  child: Text('举报'),
                                ),
                              ),
                            ),
                            Container(
                              height: setHeight(60),
                              child: InkWell(
                                onTap: (){

                                },
                                child: Center(
                                  child: Text('标记为不喜欢'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        cancelButton:
                        IconButton(icon: Icon(Icons.close,color: Colors.blueAccent,),
                            onPressed: ()=>Navigator.pop(context)),
                      );
                    },shape:RoundedRectangleBorder(
                     borderRadius:BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)
                    )
                    ) );
                  }),
                ],
              ),
              body:Stack(
                children: <Widget>[
                  Consumer<ForumPageInformationVm>(builder: (context, vm, _) {
                    if (vm.forumPagePostsModel == null||vm.firstCommentsModel==null) {
                      return Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }
                    return CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverToBoxAdapter(
                          child: Column(
                            children: <Widget>[
                              Container(
                                height: setHeight(100),
                                padding: EdgeInsets.only(
                                    left: setWidth(15), right: setWidth(15)),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: setWidth(70),
                                      child: CircleAvatar(),
                                    ),
                                    SizedBox(
                                      width: setWidth(20),
                                    ),
                                    Container(
                                      width: setWidth(430),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxWidth: setWidth(400)),
                                                child: Text(
                                                  vm.forumPagePostsModel
                                                      .data[widget.index].userId,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                ),
                                              ),
                                              SizedBox(
                                                width: setWidth(10),
                                              ),
                                              SvgPicture.asset(
                                                vm
                                                    .forumPagePostsModel
                                                    .data[widget.index]
                                                    .sex
                                                    .isEven
                                                    ? 'assets/svg/woman.svg'
                                                    : 'assets/svg/man.svg',
                                                width: setWidth(50),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            child: Text(
                                              '2分钟前，来自 [四川轻化工大学宜宾校区]',
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey[400],
                                                  fontWeight: FontWeight.w300,
                                                  fontStyle: FontStyle.italic),
                                              maxLines: 1,
                                              overflow: TextOverflow.clip,
                                            ),
                                            width: setWidth(430),
                                          )
                                        ],
                                      ),
                                    ),
                                    vm.forumPagePostsModel.data[widget.index]
                                        .isFocus.isEven
                                        ? Expanded(
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          width: setWidth(100),
                                          height: setHeight(40),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            border: Border.all(
                                                color: Colors.blue),
                                          ),
                                          child: Text(
                                            '关注',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.w300),
                                          ),
                                        ),
                                      ),
                                    )
                                        : Container(),
                                  ],
                                ),
                              ),
                              Container(
                                color: Colors.black,
                                child: ConstrainedBox(

                                  constraints:
                                  BoxConstraints(maxHeight: setHeight(900)),
                                  child: Swiper(
                                    itemCount: vm.forumPagePostsModel
                                        .data[widget.index].images.length,
                                    pagination: SwiperPagination(
                                        builder: SwiperPagination.fraction
                                    ),
                                    itemBuilder: (context, index) {
                                      return CachedNetworkImage(
                                        imageUrl: vm.forumPagePostsModel
                                            .data[widget.index].images[index],
                                        errorWidget: (context,a,_)=>Center(child: Icon(Icons.error_outline),),
                                        fit: BoxFit.contain,
                                        placeholder: (context,_)=>Center(child: CupertinoActivityIndicator(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: setWidth(25),
                                  right: setWidth(25),
                                  bottom: setHeight(10),
                                  top: setHeight(10),
                                ),
                                child: Text(
                                    vm.forumPagePostsModel.data[widget.index].text),
                              ),
                              Divider(),

                            ],
                          ),
                        ),
                        SliverPersistentHeader(
                            floating: true,pinned: true,delegate:ForumInformationHeader(vm.firstCommentsModel.comments.length, vm.firstCommentsModel.comments.length*10)),
                        Consumer<ForumPageInformationVm>(builder: (context, vm, _) {
                          if (vm.firstCommentsModel == null) {
//                            vm.getComments();
                            return SliverToBoxAdapter(
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            );
                          }
                          return SliverList(
                              delegate:
                              SliverChildBuilderDelegate((context, index) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      left: setWidth(25), right: setWidth(25)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: <Widget>[
                                            CircleAvatar(),
                                            SizedBox(
                                              width: setWidth(20),
                                            ),
                                            Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      vm.firstCommentsModel.comments[index]
                                                          .userName,
                                                      style: TextStyle(color: Colors.grey),
                                                    ),
                                                    Text(vm.firstCommentsModel
                                                        .comments[index].msg)
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                      vm.firstCommentsModel.comments[index]
                                          .replyCount ==
                                          0
                                          ? Container()
                                          : Container(
                                          alignment: Alignment.center,
                                          child: vm.mapExpansion
                                              .containsKey(index) &&
                                              vm.mapExpansion[index]&&vm.mapMoreCommentsModel[index]!=null
                                              ? ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: vm
                                                  .mapMoreCommentsModel[index]
                                                  .replyLists
                                                  .length,
                                              physics:
                                              NeverScrollableScrollPhysics(),
                                              itemBuilder:
                                                  (context, commentsIndex) {
                                                return Container(
                                                  padding: EdgeInsets.only(
                                                    left: setWidth(100),
                                                  ),
                                                  child: Row(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: <Widget>[
                                                      CircleAvatar(),
                                                      SizedBox(
                                                        width: setWidth(20),
                                                      ),
                                                      Expanded(
                                                          child: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: <Widget>[
                                                              Text(
                                                                vm
                                                                    .mapMoreCommentsModel[
                                                                index]
                                                                    .replyLists[
                                                                commentsIndex]
                                                                    .userName,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                              Text(
                                                                  '${getAnswer(vm.mapMoreCommentsModel[index].replyLists[commentsIndex].toWho)}${vm.mapMoreCommentsModel[index].replyLists[commentsIndex].msg}')
                                                            ],
                                                          )),
                                                    ],
                                                  ),
                                                );
                                              })
                                              : InkWell(
                                            onTap: () {
//                                              vm.getMoreComments(index);
                                            },
                                            child: AnimatedSwitcher(duration: Duration(
                                                milliseconds: 500
                                            ),
                                              child: vm.mapExpansion[index]!=null&&vm.mapExpansion[index]?CupertinoActivityIndicator(
                                                key: ValueKey('$index${vm.mapExpansion[index]??'true'}'),
                                              ):
                                              Text(
                                                '展开 ${vm.firstCommentsModel.comments[index].replyCount} 条评论',
                                                style: TextStyle(
                                                  color: Colors.blueAccent,
                                                ),
                                              ),key: ValueKey('$index${vm.mapExpansion[index]??'false'}'),),
                                          )),
                                    ],
                                  ),
                                );
                              }, childCount: vm.firstCommentsModel.comments.length));
                        }),
                      ],
                    );
                  }),
                  Column(
                    children: <Widget>[
                      Expanded(child: Container(),),
                      Container(height: 65,color: Colors.white,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                         Flexible(child: Container(
                           margin: EdgeInsets.only(left: 20),
                           height: 40,
                           decoration: BoxDecoration(
                             color: Colors.grey[200],
                             borderRadius: BorderRadius.circular(10)
                           ),
                           child: TextField(
                              controller: _textEditingController,
                              focusNode: _focusNode,
                              onSubmitted: (_){
                                _focusNode.unfocus();
                              },
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: '骚年,说点啥?',
                                contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 10),
                              ),
                           ),
                         ),flex: 3,),
                          Flexible(child:Container(
                            width: double.infinity,
                            child: Icon(Icons.star),
                          ),flex: 1,),
                          Flexible(child:Container(
                            width: double.infinity,
                            child: Icon(Icons.star),
                          ),flex: 1,),
                          Flexible(child:Container(
                            width: double.infinity,
                            child: Icon(Icons.send,color: Colors.blueAccent,),
                          ),flex: 1,),
                        ],
                      ),)
                    ],
                  ),
                ],
              )
          ),
        ));
  }

  String getAnswer(String id1) {
    if (id1.isEmpty) {
      return '';
    } else
      return '回复 @$id1: ';
  }
}
class ForumInformationHeader extends SliverPersistentHeaderDelegate{
  ForumInformationHeader(this.commentsCount, this.startsCount);
  int commentsCount,startsCount;
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          left: 30,
          right: 30,
          bottom: 5),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('$commentsCount条评论'),
          Text('$startsCount个点赞 👍')
        ],
      ),
    );
  }

  @override
  double get maxExtent => setHeight(60);

  @override
  double get minExtent => setHeight(60);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }

}
