
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/trade_information_vm.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class TradeInformationPage extends StatefulWidget {
  String gId;

  TradeInformationPage(this.gId);

  @override
  _TradeInformationPageState createState() => _TradeInformationPageState();
}

class _TradeInformationPageState extends State<TradeInformationPage> {
  TradeInformationVm tradeInformationVm;
  @override
  void initState() {
    tradeInformationVm = TradeInformationVm(widget.gId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: tradeInformationVm,
      child:  Scaffold(
          appBar: AppBar(
            elevation: .0,
            automaticallyImplyLeading: true,
            title: Consumer<TradeInformationVm>(builder: (context,vm,_){
              return Text('${(vm.goodsListModel?.data?.first?.gPrice)??""}',style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 22,
                  fontWeight: FontWeight.bold
              ),);
            }),
            actions: <Widget>[
              Consumer<TradeInformationVm>(
               builder: (context,vm,child){
                 return Builder(builder: (context){
                   return IconButton(icon: Icon(Icons.more_horiz), onPressed: (){
                     if(vm.goodsListModel==null){
                       showToast('请等待加载完成',position: ToastPosition.bottom);
                       return;
                     }
                     showBottomSheet(shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(10),
                           topRight: Radius.circular(10),
                         )
                     ),context: context, builder: (context){
                       return Container(
                         height: setHeight(300),
                         child: CupertinoActionSheetAction(onPressed: (){
                           Navigator.pop(context);
                         }, child: CupertinoButton(color: Colors.blue,child: Container(

                           width: double.infinity,
                           height: setHeight(60),

                           alignment: Alignment.center,
                           child: Text('举报'),
                         ), onPressed: (){

                           showDialog(context: context,builder: (ctx){
                             return CupertinoAlertDialog(
                               title: Text('确认举报吗？'),
                               content: Text('温馨提示： 恶意举报将封禁账号'),
                               actions: <Widget>[
                                 CupertinoButton(child: Text('取消举报'), onPressed: ()=>Navigator.pop(ctx)),
                                 CupertinoButton(child: Text('确认举报'), onPressed: (){
                                   showToast('举报成功，感谢你出一份力，我们将尽快核实');
                                   Navigator.pop(ctx);
                                   Navigator.pop(context);
                                 }),
                               ],
                             );
                           });
                         })),
                       );
                     });
                   });
                 },);
               },

              ),
            ],
          ),
          body: Consumer<TradeInformationVm>(builder: (context,vm,_){
            if(vm.goodsListModel==null){
              vm.loading();
              return LoadingWidget(context,canRemove: false,);
            }
            return Stack(
              children: <Widget>[
                SafeArea(
                    child: Padding(padding: EdgeInsets.only(
                      left: 20,right: 20,
                    ),
                      child:  CustomScrollView(
                        slivers: <Widget>[
                          SliverList(delegate:SliverChildListDelegate([
                            Container(
                              height: setHeight(100),
                              width: double.infinity,
                              child: Row(
                                children: <Widget>[
                                  CircleAvatar(),
                                  SizedBox(width: 20,),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('带领死猪杀无路',style: TextStyle(
                                        color: Colors.black
                                        ,fontWeight:
                                      FontWeight.bold,
                                      ),),
                                      Text('宜宾校区',style: TextStyle(
                                          color: Colors.grey
                                      ),),
                                    ],
                                  ),
                                  Expanded(child:
                                  Align(alignment: Alignment.centerRight,
                                    child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(7)
                                        ),color: Colors.blueAccent,onPressed: (){}, child:
                                    Text('关注',style: TextStyle(
                                      color: Colors.white,

                                    ),)),))
                                ],
                              ),
                            ),
                            Container(child:RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '商品名称:     ',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  )
                                  ),
                                  TextSpan(
                                      text: '${vm.goodsListModel.data.first.gName}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                      )
                                  ),
                                ]
                            ),
                            ),),
                            Container(child:RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '商品位置： ',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  )
                                  ),
                                  TextSpan(
                                      text: '${vm.goodsListModel.data.first.schoolLocation}',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold

                                      )
                                  ),
                                ]
                            ),
                            ),),
                            Container(child:RichText(text: TextSpan(
                                children: [
                                  TextSpan(
                                      text: '商品详情：  ',style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  )
                                  ),
                                  TextSpan(
                                      text: '${vm.goodsListModel.data.first.gDec}',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500
                                      )
                                  ),
                                ]
                            ),
                            ),),
                            SizedBox(height: 20,),
                            Divider(),
                          ],)),
                          SliverList(delegate: SliverChildBuilderDelegate(
                                  (context,index){
                                return CachedNetworkImage(imageUrl: vm.goodsListModel.data.first.gImages[index]);
                              },childCount: vm.goodsListModel.data.first.gImages.length)),
                          SliverToBoxAdapter(
                            child: Container(height: 100,),
                          ),

                        ],
                      ),)
                ),
                Column(
                  children: <Widget>[
                    Expanded(child: Container()),
                    Container(height: setHeight(100),color: Colors.teal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(child: FlatButton.icon(color: Colors.white,onPressed: (){},
                              icon:Icon(Icons.message), label:Text('留言')),flex: 1,),
                          Flexible(child: FlatButton.icon(color: Colors.white,onPressed: (){},
                              icon:Icon(Icons.star_border), label:Text('收藏')),flex: 1,),
                          Flexible(child: FlatButton(color: Colors.white,onPressed: (){},
                              child:Text('在线沟通')),flex: 1,),
                        ],
                      ),),
                  ],
                )
              ],
            );
          })),
    );
  }
}
