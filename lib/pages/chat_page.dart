
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/model/chat_data_model.dart';
import 'package:flutter_app/model/chat_model.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/utils/websocket_utils.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class ChatPage extends StatefulWidget {
  Map argus;
  ChatPage(this.argus);
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage>{


  TextEditingController textEditingController=TextEditingController();
  TextEditingController fromIdController=TextEditingController();
  TextEditingController toIdController=TextEditingController();
  ScrollController scrollController=ScrollController();
  WebSocketUtils webSocketUtils;
  ChatModel chatModel;
  ChatDataModel chatDataModel;
  Widget chatPosition(bool b,String msg){
    if(b){
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget> [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(errorWidget: (context,s,_)=>Container(
              color: Colors.yellow,
              width: 20,
              height: 20,
            ),imageUrl: chatDataModel.headPic),
          ),
          Expanded(child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius:BorderRadius.circular(7),
            ),
            child: Text('$msg',style: TextStyle(
              color: Colors.black,
            )),
          ))
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Expanded(child: Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.blue[400],
            borderRadius:BorderRadius.circular(7),
          ),
          child: Text('$msg',style: TextStyle(
            color: Colors.white,
          ),),
        )),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(errorWidget: (context,s,_)=>Container(
            color: Colors.yellow,
            width: 20,
            height: 20,
          ),imageUrl: chatDataModel.headPic),
        ),

      ],
    );

  }
  @override
  void initState() {
    chatDataModel=ChatDataModel.fromJson(widget.argus);
    webSocketUtils=WebSocketUtils();
    webSocketUtils.startConnect();
    webSocketUtils.getHistoryMessage(Api.userId==chatDataModel.userId?chatDataModel.toId:chatDataModel.userId);
    super.initState();
  }
  void resetConnected(){
    webSocketUtils.resetConnect();
    webSocketUtils.getChatters();
  }
  void sendData(String msg){
    webSocketUtils.sendData(msg, Api.userId==chatDataModel.userId?chatDataModel.toId:chatDataModel.userId);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('${chatDataModel.toId}'),
        elevation: .0,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(stream: webSocketUtils.chattingController.stream,
              builder: (context,snapshot){
                if(snapshot.hasData){
                  var model=ChatModel.fromJson(jsonDecode(snapshot.data));
                  if(model.code==201){
                    chatModel=model;
                  }
                  else{
                    chatModel.chatMsg.addAll(model.chatMsg);
                    if(scrollController.hasClients){
                      scrollController.jumpTo(scrollController.position.maxScrollExtent);
                    }
                  }

                }
                if(snapshot.connectionState==ConnectionState.active){
                  return Column(
                    children: <Widget>[
                      Expanded(child: EasyRefresh(child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          controller: scrollController,
                          itemCount: chatModel?.chatMsg?.length??0,shrinkWrap:true,itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.only(
                            left: 10,right: 10
                          ),
                          alignment: chatModel.chatMsg[index].userId!=Api.userId?Alignment.centerLeft:Alignment.centerRight,
                          child: chatPosition(chatModel.chatMsg[index].userId!=Api.userId,chatModel.chatMsg[index].msg ),
                        );

                      }))),
                      Container(
                        height: setHeight(100),
                        padding: EdgeInsets.only(
                          left: 20,right: 20
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Flexible(child: Icon(Icons.audiotrack)),
                            Flexible(child: Container(
                              padding: EdgeInsets.only(
                                top: 5,bottom: 5,left: 10,right: 10
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Padding(padding: EdgeInsets.all(10),child: TextField(
                                  onSubmitted: (s){
                                    sendData(s);
                                  },

                                  decoration: InputDecoration(
                                    border: InputBorder.none
                                  ),
                                ),),
                              ),
                            ),flex: 7,),
                            Flexible(child: Icon(Icons.adjust),flex: 1,),
                            Flexible(child: Icon(Icons.add),flex: 1,),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: LoadingWidget(context,canRemove: false,),
                );
              }),
        ],
      ),
    );
  }


}


