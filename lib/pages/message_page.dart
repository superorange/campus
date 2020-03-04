
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/pages/vm/message_page_vm.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  MessagePageVm messagePageVm=MessagePageVm();
  WebSocketChannel channel;
  TextEditingController textEditingController=TextEditingController();
  List<String> data=[];
  @override
  void initState() {
   channel=IOWebSocketChannel.connect('ws://127.0.0.1:8888/chat');
    super.initState();
  }
  void resetConnected(){
    channel=IOWebSocketChannel.connect('ws://127.0.0.1:8888/chat');
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: messagePageVm,child: Scaffold
      (
      appBar: AppBar(
        title: Text('消息'),
        elevation: .0,
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Consumer<MessagePageVm>(builder: (context,vm,_){

            return EasyRefresh(child: StreamBuilder(stream: channel.stream,
                builder: (context,snapshot){

                  print('snapshot.connectionState:${snapshot.connectionState}');
              if(snapshot.connectionState==ConnectionState.active){
                try {
                  if(snapshot.data is String){
                                    data.add(snapshot.data);
                                  }
                                 else{
                                    data.add(jsonDecode(snapshot.data.toString())['msg'].toString());
                                  }
                } catch (e) {
                  print('e:$e');
                }
                return ListView.builder(itemCount: data.length,shrinkWrap:true,itemBuilder: (context,index){
                  return Text('data:${data[index]}');
                });
              }

                  return LoadingWidget(context,canRemove: false,);
                }));
          }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Flexible(child: TextFormField(
                  controller: textEditingController,
                ),flex: 3,),
                Flexible(child: IconButton(icon: Icon(Icons.send), onPressed: ()async{
                  print('fasong:${textEditingController.text}');

                      channel.sink.add(textEditingController.text
                      );

                }),flex: 1,),
                Flexible(child: InkWell(onTap: (){
                  resetConnected();
                  data.clear();
                  setState(() {

                  });
                },child: Text('重连'),)),
              ],
            ),
          )
        ],
      ),
    ),);
  }
}
