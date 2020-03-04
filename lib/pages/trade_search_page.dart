import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/trade_list_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/utils/utils.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class TradeSearchPage extends StatefulWidget {
  @override
  _TradeSearchPageState createState() => _TradeSearchPageState();
}

class _TradeSearchPageState extends State<TradeSearchPage> {
  TextEditingController _textEditingController = TextEditingController();
  EasyRefreshController _controller=EasyRefreshController();
  TradeListPageVm tradeListPageVm=TradeListPageVm();
  FocusNode _focusNode = FocusNode();
  bool first = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tradeListPageVm,
      child: Scaffold(
        backgroundColor: Colors.grey[300],
        body: SafeArea(
            child: Consumer<TradeListPageVm>(builder: (context,vm,_){
              if(vm.goodsListModel==null&&first){
                print('刷新——++');
                first=false;
                vm.loading();
              }
              return EasyRefresh.builder(
                controller: _controller,
                enableControlFinishLoad: true,
                  enableControlFinishRefresh: true,
                  onLoad: ()async{
                  await vm.loadMore().then((val){
                    if(val==LoadState.LoadSuccess){
                      _controller.finishLoad(success: true,noMore: false);
                    }
                    if(val==LoadState.NullData){
                      _controller.finishLoad(success: true,noMore: true);
                      Future.delayed(Duration(minutes: 1)).then((_){
                        _controller.resetLoadState();
                      });
                    }
                    if(val==LoadState.LoadFailed){
                      _controller.finishLoad(success: false);
                    }
                  },onError: (e){
                    _controller.finishLoad(success: false);
                  });
                  },
                  onRefresh: ()async{
                    _controller.resetLoadState();
                    await vm.loading().then((val){
                      if(val==LoadState.LoadSuccess){
                        _controller.finishRefresh(success: true,noMore: false);
                      }
                      if(val==LoadState.NullData){
                        _controller.finishRefresh(success: true,noMore: true);
                        Future.delayed(Duration(minutes: 1)).then((_){
                          _controller.resetRefreshState();
                        });
                      }
                      if(val==LoadState.LoadFailed){
                        _controller.finishRefresh(success: false);
                      }
                    },onError: (e){
                      _controller.finishRefresh(success: false);
                    });
                  },

                  header: ClassicalHeader(

                  ),
                  footer:ClassicalFooter(noMoreText: '没有更多啦！'),builder: (context,physics,header,footer){
                return CustomScrollView(
                  physics: physics,
                  slivers: <Widget>[
                    header,
                    SliverToBoxAdapter(
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: setHeight(30),
                          ),
                          Text(
                            'Hi,Antonio',
                            style: TextStyle(
                                fontSize: 27,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: setHeight(10),
                          ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'What would you like to see?',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text(
                              'Search below now!',
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          SizedBox(
                            height: setHeight(100),
                          ),
                        ],
                      ),
                    ),
                    SliverPersistentHeader(pinned: true,floating: true,delegate: MyHeader(_focusNode, _textEditingController)),
                    SliverToBoxAdapter(
                      child: Container(
                        alignment: Alignment.center,
                        height: setHeight(150),
                        margin: EdgeInsets.only(
                            top: 5,bottom: 5
                        ),
                        child: Wrap(
                          spacing: 5,
                          runSpacing: 5,
                          children: <Widget>[
                            Container(
                              height: setHeight(120),
                              width: setWidth(150),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteName.tradeListPage,arguments: {
                                    'category':'考研资料'
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/kaoyan.png',
                                      height: setHeight(70),),
                                    Text('考研资料')
                                  ],
                                ),
                              ),
                            ),Container(
                              height: setHeight(120),
                              width: setWidth(150),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteName.tradeListPage,arguments: {
                                    'category':'数码产品'
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/shuma.png',
                                      height: setHeight(70),),
                                    Text('数码产品')
                                  ],
                                ),
                              ),
                            ),Container(
                              height: setHeight(120),
                              width: setWidth(150),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteName.tradeListPage,arguments: {
                                    'category':'二手书籍'
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/book.png',
                                      height: setHeight(70),),
                                    Text('二手书籍')
                                  ],
                                ),
                              ),
                            ),Container(
                              height: setHeight(120),
                              width: setWidth(150),
                              child: InkWell(
                                onTap: (){
                                  Navigator.pushNamed(context, RouteName.tradeListPage,arguments: {
                                    'category':'其它'
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Image.asset('assets/images/qita.png',
                                      height: setHeight(70),),
                                    Text('其它类别')
                                  ],
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    vm.goodsListModel == null
                        ? SliverToBoxAdapter(
                      child: Container(
                        height: setHeight(400),
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: LoadingWidget(context,canRemove: false,),
                      ),
                    )
                        :SliverPadding(padding: EdgeInsets.only(
                        left: 10,right: 10
                    ),sliver: SliverStaggeredGrid.countBuilder(crossAxisCount: 4,
                      itemBuilder: (context,index)=>Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7),

                          ),
                          child: InkWell(
                            onTap: (){
                              Navigator.pushNamed(context,
                                  RouteName.tradeInformationPage,arguments: '${vm.goodsListModel.data[index].gId}');
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                    child:
                                    Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(7),
                                            topLeft: Radius.circular(7)
                                        ),
                                        child: CachedNetworkImage(

                                          fit: BoxFit.cover,
                                          imageUrl: '${vm.goodsListModel.data[index].gImages.first}',
                                          errorWidget: (context,s,o)
                                          =>Center(child: Text('s:$s,0:$o'),),
                                          fadeInCurve: Curves.easeIn,
                                          placeholder: (context,s)
                                          =>Center(child: Text('s:$s'),),
                                        ),
                                      ),
                                    )),


                                Container(
                                    width: double.infinity,
                                    margin: EdgeInsets.only(top: 2,bottom: 2),
                                    padding: EdgeInsets.only(
                                        left: 5
                                    ),
                                    decoration: BoxDecoration(
                                        border: Border(
                                            top: BorderSide(color: Colors.grey,width: 1)
                                        )
                                    ),
                                    child:Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('${vm.goodsListModel.data[index].gPrice}',style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red
                                        ),),
                                        Text('${vm.goodsListModel.data[index].gName}',style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 17
                                        ),maxLines: 2,overflow: TextOverflow.ellipsis,),

                                      ],
                                    )
                                ),
                                Container(
                                  height: setHeight(100),
                                  width: double.infinity,
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(child: Container(
                                        child: CircleAvatar(),
                                      ),flex: 1,),
                                      Flexible(child: Container(
                                        margin: EdgeInsets.only(
                                            left: 5
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text('${vm.goodsListModel.data[index].userId}',style: TextStyle(
                                              color: Colors.black,
                                            ),maxLines: 1,overflow: TextOverflow.clip,),
                                            Align(
                                              alignment: Alignment(0.8, 0),
                                              child: Text('${vm.goodsListModel.data[index].schoolLocation}',style: TextStyle(
                                                color: Colors.grey,

                                              ),maxLines: 1,overflow: TextOverflow.clip,),
                                            ),
                                          ],
                                        ),
                                      ),flex: 3,),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      staggeredTileBuilder: (int index) =>
                          StaggeredTile.count(2, index.isEven ? 3 : 4),
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 8, itemCount: vm.goodsListModel.data.length,
                    )),
                      vm.goodsListModel==null?SliverToBoxAdapter(child: Container(),):footer,


                  ],
                );
              });
            },)),
      ),
    );
  }
}

class MyHeader extends SliverPersistentHeaderDelegate{
  FocusNode focusNode;
  TextEditingController textEditingController;
  MyHeader(this.focusNode,this.textEditingController);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {

    return  Container(
      width: double.infinity,
      height: setHeight(100),
      padding: EdgeInsets.only(
        left: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          Flexible(
            flex: 4,
            child:TextField(
                focusNode: focusNode,
                controller: textEditingController,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(2),
                    hintText: '搜点什么？',
                  border: InputBorder.none
                ),
                onEditingComplete: () {
                  if (focusNode.hasFocus) {
                    focusNode.unfocus();
                  }
                }),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Consumer<TradeListPageVm>(
                  builder: (context, vm, _) {
                    return InkWell(
                        onTap: () {
                          if (focusNode.hasFocus) {
                            focusNode.unfocus();
                          }
                          Navigator.pushNamed(
                              context, RouteName.tradeListPage,
                              arguments:
                              {'gName':textEditingController.text ?? ""});
                        },
                        child: Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        );
                  }),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent =>setHeight(100);

  @override
  // TODO: implement minExtent
  double get minExtent => setHeight(100);

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {

    return false;
  }

}
