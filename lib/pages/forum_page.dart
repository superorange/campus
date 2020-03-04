import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/forum_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForumPage extends StatefulWidget {
  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ForumPageVm _forumPageVm;
  TabController _tabController;
  ScrollController _scrollController = ScrollController();
  double _lastY = .0;
  bool _showTabs = true;
  AnimationController _animationController;
  Animation _animation;
  CurvedAnimation _curvedAnimation;
  List<Tab> _tabs = <Tab>[
    Tab(
      text: '广场',
    ),
    Tab(
      text: '关注',
    )
  ];

  @override
  void initState() {
    _forumPageVm = ForumPageVm();
    _forumPageVm.loading();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    _tabController = TabController(length: _tabs.length, vsync: this);
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
    _curvedAnimation =
        CurvedAnimation(parent: _animation, curve: Curves.fastOutSlowIn);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels - _lastY >= 50) {
        if (_showTabs) {
          print('隐藏');
          _showTabs = false;
          _animationController.reverse();
        }
      } else if (_scrollController.position.pixels - _lastY <= -50) {
        if (!_showTabs) {
          print('显示');
          _showTabs = true;
          _animationController.forward();
        }
      }
      _lastY = _scrollController.position.pixels;
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _forumPageVm,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(.0,
                duration: Duration(
                    seconds:
                        (_scrollController.position.pixels / 5000).ceil() + 1),
                curve: Curves.fastOutSlowIn);
          },
          child: AnimatedBuilder(
              animation: _curvedAnimation,
              builder: (context, _) {
                return AnimatedSwitcher(
                    duration: Duration(seconds: 2),
                    child: _showTabs
                        ? Icon(
                            Icons.vertical_align_top,
                            key: ValueKey('1'),
                          )
                        : Icon(
                            Icons.add,
                            key: ValueKey('2'),
                          ));
              }),
        ),
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            TabBarView(controller: _tabController, children: [
              ForumPageSquare(_scrollController),
              Container(),
            ]),
            AnimatedBuilder(
                animation: _curvedAnimation,
                builder: (context, _) {
                  return Offstage(
                    offstage: _curvedAnimation.value == .0 ? true : false,
                    child: Opacity(
                      opacity: _curvedAnimation.value,
                      child: Container(
                        color: Colors.white,
                        height: setHeight(100),
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Container(
                                width: setWidth(300),
                                child: TabBar(
                                  tabs: _tabs,
                                  controller: _tabController,
                                )),
                            IconButton(
                                icon: Icon(CupertinoIcons.photo_camera_solid),
                                onPressed: null),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        )),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

double getWrapWidth(int length) {
  switch (length) {
    case 1:
      return 660;
    case 2:
      return 330;
    case 4:
      return 300;
    default:
      return 210;
  }
}

double getWrapHeight(int length) {
  switch (length) {
    case 1:
      return 220;
    case 2:
      return 180;
    default:
      return 150;
  }
}

class ForumPageSquare extends StatefulWidget {
  ScrollController _scrollController;

  ForumPageSquare(this._scrollController);

  @override
  _ForumPageSquareState createState() => _ForumPageSquareState();
}

class _ForumPageSquareState extends State<ForumPageSquare>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Consumer<ForumPageVm>(builder: (context, vm, _) {
      if (vm.forumPagePostsModel == null) {
        return Center(
          child: CupertinoActivityIndicator(),
        );
      }
      return ListView.builder(
          controller: widget._scrollController,
          itemCount: vm.forumPagePostsModel.data.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(
                  top: index == 0 ? setHeight(100) : .0,
                  bottom: setHeight(15),
                  left: setWidth(25),
                  right: setWidth(25)),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                border: Border.all(color: Colors.grey[300]),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.forumInformationPage,
                      arguments: index);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                          maxWidth: setWidth(300)),
                                      child: Text(
                                        vm.forumPagePostsModel.data[index]
                                                .userId +
                                            '$index',
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
                                      vm.forumPagePostsModel.data[index].sex
                                              .isEven
                                          ? 'assets/svg/man.svg'
                                          : 'assets/svg/woman.svg',
                                      width: setWidth(50),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    '${10}分钟前，来自 [${vm.forumPagePostsModel.data[index].location}]',
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
                          vm.forumPagePostsModel.data[index].isFocus.isEven
                              ? Container(
                                  width: setWidth(110),
                                  height: setHeight(45),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(color: Colors.blue),
                                  ),
                                  child: Text(
                                    '关注',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.w300),
                                  ),
                                )
                              : Container(),
                          Expanded(
                              child: Align(
                                  alignment: Alignment(1, -0.7),
                                  child: GestureDetector(
                                    child: Icon(Icons.clear,
                                        size: setWidth(30),
                                        color: Colors.grey[300]),
                                    onTap: () {
//                                      vm.removeList(index);
                                    },
                                  ))),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: setWidth(15), right: setWidth(15)),
                      child: Text(
                        vm.forumPagePostsModel.data[index].text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: setHeight(10),
                    ),
                    Wrap(
                        spacing: setWidth(6),
                        runSpacing: setHeight(8),
                        children:
                            vm.forumPagePostsModel.data[index].images.map((f) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  useRootNavigator: false,
                                  builder: (context) {
                                    return MediaQuery.removePadding(
                                        removeTop: true,
                                        removeBottom: true,
                                        context: context,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            color: Colors.black,
                                            child: CachedNetworkImage(
                                              imageUrl: f,
                                              placeholder: (context, _) =>
                                                  Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ));
                                  });
                            },
                            child: CachedNetworkImage(
                              imageUrl: f ?? '',
                              width: setWidth(getWrapWidth(vm
                                  .forumPagePostsModel
                                  .data[index]
                                  .images
                                  .length)),
                              fit: BoxFit.contain,
                            ),
                          );
                        }).toList()),
                    Container(
                      height: setHeight(50),
                      margin: EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(color: Colors.grey[300], width: 1)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child:Container(
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Icon(Icons.collections,color: Colors.blueAccent,),
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      right:
                                          BorderSide(color: Colors.grey[300]))),
                            ),
                            flex: 1,
                          ),
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              child:Container(
                                height: double.infinity,
                                width: double.infinity,
                                alignment: Alignment.center,
                                child: Icon(Icons.star,color: Colors.blueAccent,),
                              ),
                              decoration: BoxDecoration(
                                  border: Border(
                                      left:
                                      BorderSide(color: Colors.grey[300]))),
                            ),
                            flex: 1,
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
    });
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
