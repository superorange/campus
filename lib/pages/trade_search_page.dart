import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_app/pages/vm/trade_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TradeListPage extends StatefulWidget {
  TradeListPage(this.searchValue);
  final Map searchValue;
  @override
  _TradeListPageState createState() => _TradeListPageState();
}

class _TradeListPageState extends State<TradeListPage> {
  TextEditingController _textEditingController = TextEditingController();
  FocusNode _focusNode = FocusNode();
  TradeVm tradeVm = TradeVm();
  ScrollController scrollController = ScrollController();
  EasyRefreshController _controller = EasyRefreshController();
  String searchValue;
  String category;
  @override
  void initState() {
    searchValue = widget.searchValue['gName'] ?? '';
    category = widget.searchValue['category'] ?? '';
    _textEditingController.text = searchValue;
    tradeVm.category = category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tradeVm,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
          child: Stack(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: double.infinity,
                child: Consumer<TradeVm>(builder: (context, vm, _) {
                  if (vm.goodsListModel == null && vm.netState == null) {
                    vm.loading(gName: searchValue).catchError((_) {});
                    return LoadingWidget(
                      context,
                      canRemove: false,
                    );
                  } else if (!vm.netState) {
                    return Center(
                      child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (ctx) {
                                vm.loading().then((_) {
                                  Navigator.pop(ctx);
                                }, onError: (e) {
                                  Navigator.pop(ctx);
                                });
                                return LoadingWidget(
                                  ctx,
                                  canRemove: false,
                                );
                              });
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                            ),
                            Image.asset(
                              'assets/images/net_error.png',
                              height: 60,
                              width: 60,
                              fit: BoxFit.fill,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('网络有问题，检测一下网络吧')
                          ],
                        ),
                      ),
                    );
                  } else if (vm.goodsListModel.goodsModel.isEmpty) {
                    return Center(
                      child: Text('哎呀，没有找到呢！别灰心，换个词试试呢'),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.only(
                        top: setHeight(100), left: 10, right: 10),
                    child: EasyRefresh(
                        controller: _controller,
                        header: ClassicalHeader(),
                        footer: ClassicalFooter(noMoreText: '没有更多啦'),
                        onLoad: () async {
                          await vm.loadMore().then((val) {
                            if (val == LoadState.LoadSuccess) {
                              _controller.finishLoad(
                                  success: true, noMore: false);
                            }
                            if (val == LoadState.NullData) {
                              _controller.finishLoad(
                                  success: true, noMore: true);
                              Future.delayed(Duration(minutes: 1)).then((_) {
                                _controller.resetLoadState();
                              });
                            }
                            if (val == LoadState.LoadFailed) {
                              _controller.finishLoad(success: false);
                            }
                          }, onError: (e) {
                            _controller.finishLoad(success: false);
                          });
                        },
                        onRefresh: () async {
                          _controller.resetLoadState();
                          await vm.loading().then((val) {
                            if (val == LoadState.LoadSuccess) {
                              _controller.finishRefresh(
                                  success: true, noMore: false);
                            }
                            if (val == LoadState.NullData) {
                              _controller.finishRefresh(
                                  success: true, noMore: true);
                              Future.delayed(Duration(minutes: 1)).then((_) {
                                _controller.resetRefreshState();
                              });
                            }
                            if (val == LoadState.LoadFailed) {
                              _controller.finishRefresh(success: false);
                            }
                          }, onError: (e) {
                            _controller.finishRefresh(success: false);
                          });
                        },
                        child: StaggeredGridView.countBuilder(
                          crossAxisCount: 4,
                          controller: scrollController,
                          itemCount: vm.goodsListModel.goodsModel.length,
                          itemBuilder: (BuildContext context, int index) =>
                              Container(
                                  child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, RouteName.tradeInformationPage,
                                  arguments:
                                      '${vm.goodsListModel.goodsModel[index].gId}');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Expanded(
                                      child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(7),
                                        topLeft: Radius.circular(7)),
                                    child: CachedNetworkImage(
                                      fit: BoxFit.cover,
                                      imageUrl:
                                          '${vm.goodsListModel.goodsModel[index].gImages.first}',
                                      errorWidget: (context, s, o) => Center(
                                        child: Text('s:$s,0:$o'),
                                      ),
                                      fadeInCurve: Curves.easeIn,
                                      placeholder: (context, s) => Center(
                                        child: Text('s:$s'),
                                      ),
                                    ),
                                  )),
                                  Container(
                                      width: double.infinity,
                                      margin:
                                          EdgeInsets.only(top: 2, bottom: 2),
                                      padding: EdgeInsets.only(left: 5),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey,
                                                  width: 1))),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            '${vm.goodsListModel.goodsModel[index].gPrice}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red),
                                          ),
                                          Text(
                                            '${vm.goodsListModel.goodsModel[index].gName}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 17),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      )),
                                  Container(
                                    height: setHeight(100),
                                    width: double.infinity,
                                    child: Row(
                                      children: <Widget>[
                                        Flexible(
                                          child: Container(
                                            child: CircleAvatar(),
                                          ),
                                          flex: 1,
                                        ),
                                        Flexible(
                                          child: Container(
                                            margin: EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  '${vm.goodsListModel.goodsModel[index].userId}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.clip,
                                                ),
                                                Align(
                                                  alignment: Alignment(0.8, 0),
                                                  child: Text(
                                                    '${vm.goodsListModel.goodsModel[index].schoolLocation}',
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.clip,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          flex: 3,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 3 : 4),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                        )),
                  );
                }),
              ),
              Consumer<TradeVm>(builder: (context, vm, _) {
                return Container(
                  height: setHeight(100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(Icons.keyboard_backspace),
                          onPressed: () => Navigator.pop(context)),
                      Container(
                        height: 40,
                        width: 250,
                        padding: EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TextField(
                            focusNode: _focusNode,
                            controller: _textEditingController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '搜点什么',
                            ),
                            onEditingComplete: () {
                              if (_focusNode.hasFocus) {
                                _focusNode.unfocus();
                              }
                            }),
                      ),
                      FlatButton(
                          onPressed: () {
                            if (scrollController.hasClients) {
                              scrollController.jumpTo(0);
                            }
                            if (_focusNode.hasFocus) {
                              _focusNode.unfocus();
                            }
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (ctx) {
                                  vm
                                      .loading(
                                    gName: _textEditingController.text,
                                  )
                                      .then((val) {
                                    Navigator.pop(ctx);
                                  }, onError: (e) {
                                    Navigator.pop(ctx);
                                  });
                                  return Center(
                                    child: LoadingWidget(
                                      ctx,
                                      canRemove: false,
                                    ),
                                  );
                                });
                          },
                          child: Icon(Icons.search))
                    ],
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
