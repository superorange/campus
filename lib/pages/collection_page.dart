import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/collection_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class CollectionPage extends StatefulWidget {
  final String userId;
  CollectionPage(this.userId);
  @override
  _CollectionPageState createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>CollectionPageVm()
    ,child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Consumer<CollectionPageVm>(builder: (context,vm,_){
            return Text('${vm.goodsListModel?.goodsModel?.length??''} 条记录');
          }),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.more), onPressed: (){
              showToast('右滑删除');
            })
          ],
        ),
          body:Consumer<CollectionPageVm>(builder: (context,vm,_){
            if(vm.goodsListModel==null){
              vm.loading(userId: widget.userId);
              return Material(
                child: Center(child: LoadingWidget(context,canRemove: false,),),
              );
            }
            return EasyRefresh(
                onRefresh: ()async{
                  vm.loading(userId: widget.userId);
                },

                child: ListView.separated(
                separatorBuilder: (context,index)=>Divider(),
                itemCount: vm.goodsListModel.goodsModel.length,
                itemBuilder: (context,index){
                  return Slidable(
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          closeOnTap: false,
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return CupertinoAlertDialog(
                                    title: Text('确定删除吗'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: Text('取消')),
                                      FlatButton(
                                          onPressed: () {
                                            vm.deleteCollection(vm.goodsListModel.goodsModel[index].gId, widget.userId);
                                            Navigator.pop(ctx);
                                          },
                                          child: Text('确认')),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                      child: InkWell(
                        onTap: (){
                          Navigator.pushNamed(context, RouteName.tradeInformationPage,arguments: vm.goodsListModel.goodsModel[index].gId);
                        },
                        child: Container(
                          height: 90,
                          margin: EdgeInsets.only(
                              left: 10,right: 10
                          ),
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    vm.goodsListModel.goodsModel[index].gImages.first
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(vm.goodsListModel.goodsModel[index].gName,overflow: TextOverflow.ellipsis,),
                                  Text(vm.goodsListModel.goodsModel[index].gPrice.toString(),style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold
                                  ),),
                                ],
                              )),
                              CachedNetworkImage(imageUrl: vm.goodsListModel.goodsModel[index].mainPic),
                            ],
                          ),
                        ),
                      ),
                      actionPane: SlidableScrollActionPane());

                }));
          })

        ),
    );
  }
}
