import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/database/chatting_db.dart';
import 'package:flutter_app/model/chatters_model.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketUtils{
  WebSocketUtils._init();
  ChattersModel _chattersModel;
  ChattersDb chattersDb=ChattersDb();
  static WebSocketUtils _webSocketUtils;
  StreamController chattersController=StreamController.broadcast();
  StreamController chattingController = StreamController.broadcast();
  IOWebSocketChannel _channel;
  StreamSubscription _subscription;
  void startConnect()async{
    if(_channel==null){
      _channel=IOWebSocketChannel.connect(Api.socketUrl+Api.chat,headers: {
        'Authorization':Api.token
      },);
      _subscription = _channel.stream.listen(_handleData,onDone: _socketDone);
    }
    

  }
  void _socketDone(){

  }
  void _handleData(dynamic data){
    var jsonData = jsonDecode(data);
    _chattersModel=ChattersModel.fromJson(jsonData);
    print('收到消息:$jsonData');
    if(jsonData['type']=='chatting'){

      chattingController.add(data);
    }
    if(jsonData['type']=='chatters'){


      chattersDb.addChatters(_chattersModel);
      chattersController.add(data);
    }

  }
  void resetConnect(){
    _channel=IOWebSocketChannel.connect(Api.socketUrl+Api.chat,headers: {
      'Authorization':Api.token
    },);
    _subscription.cancel();
    _subscription = _channel.stream.listen(_handleData);

  }
  
  void getChatters(){
    _channel.sink.add(jsonEncode({
      'type':'getChatters',
      'toId':'',
      'msg':''
    }));
  }
  dispose(){
    _subscription.cancel();

  }
  
  void sendData(String msg,String toId){
    _channel.sink.add(jsonEncode({
      'type':'chatting',
      'toId':toId,
      'msg':msg
    }));
  }
  void getHistoryMessage(String toId){
    print('发送消息$toId');
    _channel.sink.add(jsonEncode({
      'type':'notRead',
      'toId':toId,
      'msg':''
    }));
  }
  
  factory WebSocketUtils(){
    return _webSocketUtils??=WebSocketUtils._init();
  }


}