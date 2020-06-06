import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/chat_data_model.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
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

  ChatDataModel chatDataModel;
  Widget imageHead1;
  Widget imageHead2;
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
    imageHead1 = CachedNetworkImage(
      errorWidget: (context, s, _) =>
          Container(
            color: Colors.yellow,
          ),
      imageUrl: chatDataModel.headPic,
      fit: BoxFit.cover,
    );
    imageHead2 =CachedNetworkImage(
      errorWidget: (context, s, _) =>
          Container(
            color: Colors.yellow,
          ),
      imageUrl: Provider.of<PersonPageVm>(context,listen: false).user.headPic,
      fit: BoxFit.cover,
    );
    print('toId:${chatDataModel.toId}');
    Provider.of<ChatChattersPageVm>(context, listen: false)
      ..setInitData(chatDataModel.toId)
      ..addChatter(chatDataModel.toId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider
          .of<ChatChattersPageVm>(context, listen: false)
          .scrollController
          .jumpTo(Provider
          .of<ChatChattersPageVm>(context, listen: false)
          .scrollController
          .position
          .maxScrollExtent);
      Provider.of<ChatChattersPageVm>(context, listen: false)
        ..oldPosition = Provider
            .of<ChatChattersPageVm>(context, listen: false)
            .scrollController
            .position
            .maxScrollExtent;
    });
    super.initState();
  }


  Widget chatPosition(bool b, String msg) {
    if (b) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, RouteName.userPage,arguments: chatDataModel.toId);
            },
            child: Container(
              height: 40,
              width: 50,
              padding: EdgeInsets.only(right: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: imageHead1,
              ),
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
            child: imageHead2,
          ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ChatChattersPageVm>(builder: (context, vm, _) {
      return WillPopScope(child: Scaffold(
        appBar: AppBar(
          title: Text('${chatDataModel.userName}'),
          centerTitle: true,
          elevation: 0.5,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    controller: vm.scrollController,
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
                    })),
            SafeArea(child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20,
                  right: 20,
                  bottom: 5,
                  top: 5),
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
                      onTap: () {
                        Future.delayed(Duration(milliseconds: 100)).then((_) {
                          vm.scrollController.jumpTo(
                            vm.scrollController.position.maxScrollExtent,);
                        });
                      },
                      onChanged: (_) {
                        if (vm.oldPosition !=
                            vm.scrollController.position.maxScrollExtent) {
                          vm.oldPosition =
                              vm.scrollController.position.maxScrollExtent;
                          vm.scrollController.position.jumpTo(
                              vm.scrollController.position.maxScrollExtent);
                        }
                      },
                      maxLines: null,
                      controller: textEditingController,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: IconButton(
                        icon: Icon(Icons.send, color: Colors.blue,),
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
            ),),
          ],
        ),
      ), onWillPop: () async {
        if(vm.lastMsgLength.containsKey(chatDataModel.toId)){
          vm
            ..lastMsgLength.remove(chatDataModel.toId)
            ..notifyListeners();
          print('chatDataModel.toId:${chatDataModel.toId}');
        }

        return true;
      });
    });
  }
}
