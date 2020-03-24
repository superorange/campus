import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  @override
  void initState() {
    _textEditingController.text = '';
    tradeOneVM = TradeOneVM(widget.gId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tradeOneVM,
      child: Consumer2<TradeOneVM, PersonPageVm>(
        builder: (context, vm, vm2, _) {
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
                                            child: Text(AppText.report,style: TextStyle(
                                              fontSize: 20,
                                              letterSpacing: 5
                                            ),),
                                          ),
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                builder: (ctx) {
                                                  return CupertinoAlertDialog(
                                                    title: Text(AppText.reportSure),
                                                    content: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Text(AppText.reportHint),
                                                        Material(
                                                          color: Colors
                                                              .transparent,
                                                          type: MaterialType
                                                              .transparency,
                                                          child: Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxHeight:
                                                                        100,
                                                                    minWidth:
                                                                        50),
                                                            child: TextField(
                                                              controller:
                                                                  _textEditingController,
                                                              maxLines: null,
                                                              decoration:
                                                                  InputDecoration(
                                                                      hintText:AppText.reportReason),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    actions: <Widget>[
                                                      CupertinoButton(
                                                          child: Text(AppText.cancle),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  ctx)),
                                                      CupertinoButton(
                                                          child: Text(AppText.sure),
                                                          onPressed: () {
                                                            if (_textEditingController
                                                                    .text
                                                                    .length <=
                                                                9) {
                                                              showToast(
                                                                  AppText.tooSmallReportReason);
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
              body: Builder(builder: (context) {
                if (vm.oneGoodsModel == null) {
                  vm.loading();
                  return LoadingWidget(
                    context,
                    canRemove: false,
                  );
                }
                return Stack(
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
                              Container(
                                height: setHeight(100),
                                width: double.infinity,
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.grey[300],
                                      ),
                                      child: CircleHeadPic(vm.oneGoodsModel.headPic),
                                    ),
                                    SizedBox(
                                      width: 20,
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
                                          style: TextStyle(color: Colors.grey),
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
                                            child: vm.oneGoodsModel.uCollection
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
                              delegate:
                                  SliverChildBuilderDelegate((context, index) {
                            return CachedNetworkImage(
                                imageUrl: vm.oneGoodsModel.gImages[index]);
                          }, childCount: vm.oneGoodsModel.gImages.length)),
                          SliverToBoxAdapter(
                            child: Container(
                              height: 100,
                            ),
                          ),
                        ],
                      ),
                    )),
                    Column(
                      children: <Widget>[
                        Expanded(child: Container()),
                        Container(
                          height: setHeight(100),
                          color: Colors.teal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              const SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: FlatButton.icon(
                                    color: Colors.white,
                                    onPressed: () {},
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
                                      duration: Duration(milliseconds: 500),
                                      child: vm.oneGoodsModel.gCollection
                                          ? Text(AppText.collection2,

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
                                          Navigator.pushNamed(
                                              context, RouteName.chatPage,
                                              arguments: {
                                                'toId': vm.oneGoodsModel.userId,
                                                'headPic':
                                                    vm.oneGoodsModel.headPic,
                                                'userName':
                                                    vm.oneGoodsModel.userName
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
                        ),
                      ],
                    )
                  ],
                );
              }));
        },
      ),
    );
  }
}
