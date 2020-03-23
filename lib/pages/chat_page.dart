import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/chat_data_model.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ChatPage extends StatefulWidget {
  ChatPage(this.argus);
  Map argus;

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController textEditingController = TextEditingController();
  ScrollController scrollController = ScrollController();
  ChatDataModel chatDataModel;
  Widget imageHead;
  Connectivity _connectivity = Connectivity();

  int msgLength = 0;
  @override
  void initState() {
    _connectivity.onConnectivityChanged.listen((res) {
      if (res == ConnectivityResult.wifi || res == ConnectivityResult.mobile) {
        Provider.of<ChatChattersPageVm>(context, listen: false).startConnect();
      }
    });
    chatDataModel = ChatDataModel.fromJson(widget.argus);
    imageHead = CachedNetworkImage(
      errorWidget: (context, s, _) => Container(
        color: Colors.yellow,
      ),
      imageUrl: chatDataModel.headPic,
      fit: BoxFit.cover,
    );
    print('toId:${chatDataModel.toId}');
    Provider.of<ChatChattersPageVm>(context, listen: false)
      ..setInitData(chatDataModel.toId)
      ..addChatter(chatDataModel.toId);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Widget chatPosition(bool b, String msg) {
    if (b) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 40,
            width: 50,
            padding: EdgeInsets.only(right: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: imageHead,
            ),
          ),
          Expanded(
              child: Container(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        '$msg',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      )))),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
            child: Container(
                alignment: Alignment.centerRight,
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.blue[300],
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Text(
                      '$msg',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    )))),
        Container(
          height: 40,
          width: 50,
          padding: EdgeInsets.only(left: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: imageHead,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          title: Text('${chatDataModel.userName}'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Consumer<ChatChattersPageVm>(builder: (context, vm, _) {
//          if (scrollController.hasClients) {
//            print(scrollController.position.pixels);
////            scrollController.jumpTo();
//          }
          return Column(
            children: <Widget>[
              Expanded(
                  child: EasyRefresh(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          controller: scrollController,
                          itemCount:
                              vm.chatMapMsg[chatDataModel.toId]?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              alignment: vm
                                      .chatMapMsg[chatDataModel.toId][index]
                                      .sign
                                      .isEven
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              child: chatPosition(
                                  vm.chatMapMsg[chatDataModel.toId][index].sign
                                      .isEven,
                                  vm.chatMapMsg[chatDataModel.toId][index].msg),
                            );
                          }))),
              Container(
                padding:
                    EdgeInsets.only(left: 20, right: 20, bottom: 5, top: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20)),
                      constraints: BoxConstraints(
                          minHeight: 40,
                          maxHeight: 150,
                          maxWidth: 250,
                          minWidth: 200),
                      child: TextField(
                        maxLines: null,
                        controller: textEditingController,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    IconButton(
                        icon: Icon(Icons.blur_circular),
                        onPressed: () {
                          showToast('功能开发中');
                        }),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            if (textEditingController.text.isNotEmpty) {
                              vm.sendMsg(textEditingController.text,
                                  chatDataModel.toId);
                              textEditingController.clear();
                            }
                          }),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      )),
    );
  }
}
