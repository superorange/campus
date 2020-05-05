import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/config/app_text/app_text.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/pages/vm/trade_one_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/circle_head_pic.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TradeOnePage extends StatefulWidget {
  String gId;

  TradeOnePage(this.gId);

  @override
  _TradeOnePageState createState() => _TradeOnePageState();
}

class _TradeOnePageState extends State<TradeOnePage> {
  TradeOneVM tradeOneVM;
  TextEditingController _textEditingController = TextEditingController();
  TextEditingController _liuYanController = TextEditingController();

  @override
  void initState() {
    _textEditingController.text = '';
    super.initState();
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TradeOneVM(widget.gId),
      child: Consumer2<TradeOneVM, PersonPageVm>(
        builder: (context, vm, vm2, _) {
          int floor = 0;
          return Scaffold(
            appBar: AppBar(
              elevation: .0,
              automaticallyImplyLeading: true,
              centerTitle: true,
              title: Text(
                '${(vm.oneGoodsModel?.gPrice) ?? ""}',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              actions: <Widget>[
                Builder(builder: (context) {
                  return IconButton(
                      icon: Icon(Icons.more_horiz),
                      onPressed: () {
                        if (vm.oneGoodsModel == null) {
                          showToast(AppText.waitLoading,
                              position: ToastPosition.bottom);
                          return;
                        }
                        showBottomSheet(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            )),
                            context: context,
                            builder: (context) {
                              return Container(
                                height: setHeight(200),
                                child: CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: CupertinoButton(
                                        color: Colors.blue,
                                        child: Container(
                                          width: double.infinity,
                                          height: setHeight(60),
                                          alignment: Alignment.center,
                                          child: Text(
                                            AppText.report,
                                            style: TextStyle(
                                                fontSize: 20, letterSpacing: 5),
                                          ),
                                        ),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                return CupertinoAlertDialog(
                                                  title:
                                                      Text(AppText.reportSure),
                                                  content: Column(
                                                    children: <Widget>[
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Text(AppText.reportHint),
                                                      Material(
                                                        color:
                                                            Colors.transparent,
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Container(
                                                          constraints:
                                                              BoxConstraints(
                                                                  maxHeight:
                                                                      100,
                                                                  minWidth: 50),
                                                          child: TextField(
                                                            controller:
                                                                _textEditingController,
                                                            maxLines: null,
                                                            decoration:
                                                                InputDecoration(
                                                                    hintText:
                                                                        AppText
                                                                            .reportReason),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    CupertinoButton(
                                                        child: Text(
                                                            AppText.cancle),
                                                        onPressed: () =>
                                                            Navigator.pop(ctx)),
                                                    CupertinoButton(
                                                        child:
                                                            Text(AppText.sure),
                                                        onPressed: () {
                                                          if (_textEditingController
                                                                  .text
                                                                  .length <=
                                                              9) {
                                                            showToast(AppText
                                                                .tooSmallReportReason);
                                                            return;
                                                          }
                                                          vm.goodsReport(
                                                              _textEditingController
                                                                  .text);
                                                          _textEditingController
                                                              .clear();
                                                          Navigator.pop(ctx);
                                                          Navigator.pop(
                                                              context);
                                                        }),
                                                  ],
                                                );
                                              });
                                        })),
                              );
                            });
                      });
                }),
              ],
            ),
            body: (vm.oneGoodsModel == null || vm.comments == null)
                ? Builder(builder: (context) {
                      vm.loading();
                    return LoadingWidget(context);
                  })
                : Stack(
                    children: <Widget>[
                      SafeArea(
                          child: Padding(
                        padding: EdgeInsets.only(
                          left: 20,
                          right: 20,
                        ),
                        child: CustomScrollView(
                          slivers: <Widget>[
                            SliverList(
                                delegate: SliverChildListDelegate(
                              [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pushNamed(context, RouteName.userPage,arguments: vm.oneGoodsModel.userId);
                                  },
                                  child: Container(
                                    height: setHeight(100),
                                    width: double.infinity,
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.grey[300],
                                          ),
                                          child: CircleHeadPic(
                                              vm.oneGoodsModel.headPic),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              child: Text(
                                                '${vm.oneGoodsModel.userName}',
                                                overflow: TextOverflow.clip,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              constraints: BoxConstraints(
                                                  minWidth: setWidth(400)),
                                            ),
                                            Text(
                                              '${vm.oneGoodsModel.schoolLocation}',
                                              style:
                                              TextStyle(color: Colors.grey),
                                            ),
                                          ],
                                        ),
                                        Expanded(
                                            child: Align(
                                              alignment: Alignment.centerRight,
                                              child: FlatButton(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                      BorderRadius.circular(3)),
                                                  color: vm.oneGoodsModel.uCollection
                                                      ? Colors.brown
                                                      : Colors.blue,
                                                  onPressed: () {
                                                    vm.userCollection();
                                                  },
                                                  child: AnimatedSwitcher(
                                                    duration:
                                                    Duration(milliseconds: 500),
                                                    child: vm
                                                        .oneGoodsModel.uCollection
                                                        ? Text(
                                                      AppText.note2,
                                                      key: ValueKey('true'),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                        : Text(
                                                      AppText.note1,
                                                      key: ValueKey('false'),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  )),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: AppText.goodsName,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                      TextSpan(
                                          text: '${vm.oneGoodsModel.gName}',
                                          style: TextStyle(
                                            color: Colors.blueAccent,
                                            fontSize: 18,
                                          )),
                                    ]),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: AppText.goodsDec,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                      TextSpan(
                                          text: '${vm.oneGoodsModel.gDec}',
                                          style: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 20,
                                          )),
                                    ]),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: AppText.goodsLocation,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500)),
                                      TextSpan(
                                          text:
                                              '${vm.oneGoodsModel.schoolLocation}',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontSize: 18,
                                          )),
                                    ]),
                                  ),
                                ),
                                Divider(),
                              ],
                            )),
                            SliverList(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                              return CachedNetworkImage(
                                  imageUrl: vm.oneGoodsModel.gImages[index]);
                            }, childCount: vm.oneGoodsModel.gImages.length)),
                            SliverToBoxAdapter(
                              child: Container(
                                margin: EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  '${vm.comments.length}${AppText.totalComments}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.purple),
                                ),
                              ),
                            ),
                            SliverList(
                              delegate: SliverChildListDelegate(
                                  vm.firstComments.map((f) {
                                floor++;
                                var secondData = vm.secondComments
                                    .where((t) => t.toCommentId == f.commentId)
                                    .toList();
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: Container(
                                        color: Colors.transparent,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              width: 30,
                                              margin: EdgeInsets.only(
                                                  top: 10, right: 3),
                                              alignment: Alignment(0, -1),
                                              child: Text(
                                                '$floor楼',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pushNamed(context, RouteName.userPage,arguments: f.userId);
                                              },
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                        f.headPic),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text.rich(TextSpan(
                                                    text: f.userName,
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.w500),
                                                    children: [
                                                      TextSpan(
                                                          text: vm.oneGoodsModel
                                                              .userId ==
                                                              f.userId
                                                              ? ' 发布者'
                                                              : '',
                                                          style: TextStyle(
                                                              color:
                                                              Colors.purple)),
                                                      TextSpan(
                                                        text: '  ${                                                          DateTime.fromMillisecondsSinceEpoch(int.parse(f.createTime)).toString().substring(5,16)}'
                                                        ,style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight: FontWeight.w300,
                                                      ),
                                                      ),
                                                    ])),
                                                Container(
                                                  constraints: BoxConstraints(
                                                      maxHeight: 1000),
                                                  child: Text(
                                                    f.text,
                                                    maxLines: null,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      onTap: () {
                                        vm
                                          ..toUser = f.userName
                                          ..toCommentId = f.commentId ?? ''
                                          ..toId = f.userId
                                          ..showKeyboard = true;
                                        FocusScope.of(context)
                                            .requestFocus(focusNode);
                                      },

                                    ),
                                    ListView.separated(
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 50),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                   GestureDetector(
                                                     child:  CircleAvatar(
                                                       backgroundImage:
                                                       CachedNetworkImageProvider(
                                                           f.headPic),
                                                     ),
                                                     onTap: (){
                                                       Navigator.pushNamed(context, RouteName.userPage,arguments: secondData[index].userId);
                                                     },
                                                   ),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    Expanded(
                                                        child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text.rich(TextSpan(
                                                            text: secondData[
                                                                    index]
                                                                .userName,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                            children: [
                                                              TextSpan(
                                                                  text: vm.oneGoodsModel
                                                                              .userId ==
                                                                          secondData[index]
                                                                              .userId
                                                                      ? ' 发布者'
                                                                      : '',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .purple)),
                                                              TextSpan(
                                                                text: '  ${                                                          DateTime.fromMillisecondsSinceEpoch(int.parse(f.createTime)).toString().substring(5,16)}'
                                                                ,style: TextStyle(
                                                                color: Colors.grey,
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w300,
                                                              ),
                                                              ),
                                                            ])),
                                                        Text.rich(TextSpan(
                                                            text: '回复@',
                                                            children: [
                                                              TextSpan(
                                                                  text: secondData[
                                                                          index]
                                                                      .toUserName,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blue)),
                                                              TextSpan(
                                                                text:
                                                                    ": ${secondData[index].text}",
                                                              ),
                                                            ])),
                                                      ],
                                                    )),
                                                  ],
                                                )),
                                            onTap: () {
                                              vm
                                                ..toUser =
                                                    secondData[index].userName
                                                ..toId =
                                                    secondData[index].userId
                                                ..toCommentId =
                                                    f.commentId ?? ''
                                                ..showKeyboard = true;
                                            },
                                          );
                                        },
                                        physics: NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemCount: secondData.length),
                                    Divider(),
                                  ],
                                );
                              }).toList()),

                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                height: 200,
                              ),
                            ),
                          ],
                        ),
                      )),
                      vm.showKeyboard
                          ? SafeArea(
                              child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        margin: EdgeInsets.only(
                                            top: 10, bottom: 10),
                                        constraints: BoxConstraints(
                                            maxWidth: setWidth(600),
                                            maxHeight: 250),
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            shape: BoxShape.rectangle,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: TextField(
                                          onSubmitted: (s) {
                                            if (s.isNotEmpty) {
                                              vm.addComment(s);
                                            }
                                            if (focusNode.hasFocus) {
                                              focusNode.unfocus();
                                            }
                                            vm.showKeyboard = false;
                                            _liuYanController.clear();
                                          },
                                          textInputAction: TextInputAction.send,
                                          maxLines: null,
                                          focusNode: focusNode,
                                          controller: _liuYanController,
                                          decoration: InputDecoration(
                                              labelText: '@${vm.toUser}:',
                                              labelStyle: TextStyle(
                                                color: Colors.black54
                                              ),
                                              border: InputBorder.none),
                                        ),
                                      ),
                                      IconButton(
                                          icon: Icon(
                                            Icons.send,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {
                                            if (_liuYanController
                                                .text.isEmpty) {
                                              return;
                                            }
                                            vm.addComment(
                                                _liuYanController.text);
                                            if (focusNode.hasFocus) {
                                              focusNode.unfocus();
                                            }
                                            vm.showKeyboard = false;
                                            _liuYanController.clear();
                                          }),
                                    ],
                                  )),
                            ))
                          : Column(
                              children: <Widget>[
                                Expanded(child: Container()),
                                Container(

                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).padding.bottom
                                  ),
                                  height: setHeight(100)+MediaQuery.of(context).padding.bottom,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: <Widget>[
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: FlatButton.icon(
                                            color: Colors.white,
                                            onPressed: () {
                                              vm
                                                ..toUser =
                                                    vm.oneGoodsModel.userName
                                                ..toId = vm.oneGoodsModel.userId
                                                ..toCommentId = ''
                                                ..showKeyboard = true;

                                              FocusScope.of(context)
                                                  .requestFocus(focusNode);
                                            },
                                            icon: Icon(Icons.message),
                                            label: Text(AppText.ly)),
                                        flex: 1,
                                        fit: FlexFit.tight,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Flexible(
                                        child: FlatButton.icon(
                                            color: vm.oneGoodsModel.gCollection
                                                ? Colors.brown
                                                : Colors.white,
                                            onPressed: () {
                                              vm.goodsCollection();
                                            },
                                            icon: Icon(
                                              Icons.star_border,

                                            ),
                                            label: AnimatedSwitcher(
                                              duration:
                                              Duration(milliseconds: 500),
                                              child: vm
                                                  .oneGoodsModel.gCollection
                                                  ? Text(
                                                AppText.collection2,
                                                key: ValueKey('true'),
                                              )
                                                  : Text(
                                                AppText.collection1,
                                                key: ValueKey('false'),
                                              ),
                                            )),
                                        flex: 1,
                                        fit: FlexFit.tight,
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      vm2.user.userId == vm.oneGoodsModel.userId
                                          ? Container(
                                        width: .0,
                                        height: .0,
                                      )
                                          : Flexible(
                                        fit: FlexFit.tight,
                                        child: FlatButton.icon(
                                          icon: Icon(Icons.send),
                                          color: Colors.white,
                                          onPressed: () {
                                            print('headPic:');
                                            Navigator.pushNamed(context,
                                                RouteName.chatPage,
                                                arguments: {
                                                  'toId': vm.oneGoodsModel
                                                      .userId,
                                                  'headPic': vm
                                                      .oneGoodsModel
                                                      .headPic,
                                                  'userName': vm
                                                      .oneGoodsModel
                                                      .userName
                                                });
                                          },
                                          label: Text(AppText.chat),
                                        ),
                                        flex: 1,
                                      ),
                                      vm2.user.userId == vm.oneGoodsModel.userId
                                          ? Container(
                                        width: .0,
                                        height: .0,
                                      )
                                          : const SizedBox(
                                        width: 15,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                    ],
                  ),
          );
        },
      ),
    );
  }
}

