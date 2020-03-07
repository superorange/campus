import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/chatters_model.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/utils/websocket_utils.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
class ChattersPage extends StatefulWidget {
  @override
  _ChattersPageState createState() => _ChattersPageState();
}

class _ChattersPageState extends State<ChattersPage>{
    WebSocketUtils webSocketUtils=WebSocketUtils();
  ScrollController scrollController=ScrollController();
  ChattersModel chattersModel;
  @override
  void initState() {
    webSocketUtils.startConnect();
    webSocketUtils.getChatters();
    super.initState();
  }
  void resetConnected(){
    webSocketUtils.resetConnect();
    webSocketUtils.getChatters();
  }
  void getChatters(){
    webSocketUtils.getChatters();
  }

  @override
  void dispose() {
    webSocketUtils.dispose();
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: Text('聊天'),
        elevation: .0,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(stream: webSocketUtils.chattersController.stream,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  var model=ChattersModel.fromJson(jsonDecode(snapshot?.data));
                  if(model.code==209){
                    chattersModel=model;
                  }
                  if(model.code==208){
                    chattersModel.chatters.addAll(model.chatters);
                    scrollController?.jumpTo(0);
                  }
                }
                if(snapshot.connectionState==ConnectionState.active){
                  return EasyRefresh(
                    onRefresh: ()async{
                      getChatters();
                    },
                      child: ListView.builder(

                      addAutomaticKeepAlives: true,
                      controller: scrollController,
                      itemCount: chattersModel?.chatters?.length??0,shrinkWrap:true,itemBuilder: (context,index){
                       return InkWell(
                      onTap: (){
                        Navigator.pushNamed(context, RouteName.chatPage,arguments: {
                          'userId':chattersModel.chatters[index].userId,
                          'toId':chattersModel.chatters[index].toId,
                          'headPic':chattersModel.chatters[index].headPic,
                          'userName':chattersModel.chatters[index].userName
                        });
                      },
                      child: Container(
                        color: Colors.white,
                        height: setHeight(100),
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            bottom: 10,
                            left: 10,right: 10
                        ),
                        child: Row(
                          children: <Widget>[
                            Flexible(child: Stack(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: CachedNetworkImage(imageUrl: chattersModel.chatters[index].headPic),
                                ),
                              ],
                            ),flex: 1,),
                            Expanded(child: Container(
                              alignment: Alignment.center,
                              child: Column(
                                children: <Widget>[
                                  Text('${chattersModel.chatters[index].userName}')
                                ],
                              ),
                            )),
                          ],
                        ),
                      ),
                    );

                  }));
                }
                return Center(
                  child: InkWell(
                    onTap: (){
                      resetConnected();
                    },
                    child: LoadingWidget(context,canRemove: false,),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
