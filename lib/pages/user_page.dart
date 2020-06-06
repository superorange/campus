import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/user_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/circle_head_pic.dart';
import 'package:flutter_app/widget/image_error.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final String userId;
  UserPage(this.userId);
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>UserPageVm(),
    child: Scaffold(
      body: Consumer<UserPageVm>(
        builder: (context,vm,_){
          if(vm.userModel==null){
            vm.loading(userId: widget.userId);
          }
          return CustomScrollView(
            slivers: <Widget>[
                 SliverAppBar(
                pinned: true,
                floating: true,
               snap: true,
                stretch: true,
                backgroundColor: Colors.blue,
                automaticallyImplyLeading: true,
                expandedHeight: 250-MediaQueryData.fromWindow(window).padding.top,
                flexibleSpace:FlexibleSpaceBar(
                  title:  Text('${vm?.userModel?.userName??''}',),
                  centerTitle: false,
                  background:  Container(height: 250,
                    padding: EdgeInsets.only(
                        left: 10,right: 10,top: 50
                    ),
                    child:Align(
                        child: Text(vm.userModel?.sign??'',style: TextStyle(
                          color: Colors.white,
                        ),),
                        alignment: Alignment.center,
                      )),
                ),

              ),

                  SliverToBoxAdapter(
                    child: Text('他的商品：',style: TextStyle(
                        color: Colors.brown,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                  ),
                  vm.goodsListModel==null?SliverToBoxAdapter(
                    child: Builder(builder: (_){
                      vm.loadGoods(widget.userId);
                      return LoadingWidget(context,canRemove: false,);
                    }),
                  ):
                      SliverToBoxAdapter(
                        child:Padding(padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 10,
                            children: vm.goodsListModel.goodsModel.map((f){
                              return InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context,
                                      RouteName.tradeInformationPage,
                                      arguments:
                                      '${f.gId}');
                                },
                                child: Container(
                                  color: Colors.white,
                                  width: (MediaQuery.of(context).size.width-40-10)/2,
                                  height: setHeight(350),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            height: double.infinity,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(7),
                                                  topLeft: Radius.circular(7)),
                                              child: CachedNetworkImage(
                                                fit: BoxFit.cover,
                                                imageUrl:
                                                '${f.mainPic??''}',
                                                errorWidget: (context, s, _) =>
                                                    ImageErrorWidget(),
                                                fadeInCurve: Curves.easeIn,
                                                placeholder: (context, s) =>
                                                    CupertinoActivityIndicator(),
                                              ),
                                            ),
                                          )),
                                      Container(
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                              top: 2, bottom: 2),
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
                                                '${f.gPrice}',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                              Text(
                                                '${f.gName}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 17),
                                                maxLines: 2,
                                                overflow:
                                                TextOverflow.ellipsis,
                                              ),
                                            ],
                                          )),
                                      Container(
                                        height: setHeight(100),
                                        width: double.infinity,
                                        child: Row(
                                          children: <Widget>[
                                            Flexible(
                                              child: CircleHeadPic(vm.userModel.headPic??''),
                                              flex: 1,
                                            ),
                                            Flexible(
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    left: 5),
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .center,
                                                  children: <Widget>[
                                                    Text(
                                                      '${vm.userModel.userName}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow.clip,
                                                    ),
                                                    Align(
                                                      alignment:
                                                      Alignment(0.8, 0),
                                                      child: Text(
                                                        '${f.schoolLocation}',
                                                        style: TextStyle(
                                                          color:
                                                          Colors.grey,
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
                                                            .clip,
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
                              );
                            }).toList()
                        ),),
                      ),
            ],
          );
        },
      ),
    ),);
  }
}
