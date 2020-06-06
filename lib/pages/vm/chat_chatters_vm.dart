import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/model/chat_model.dart';
import 'package:flutter_app/model/chatters_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/utils/websocket_utils.dart';
import 'package:oktoast/oktoast.dart';

class ChatChattersPageVm extends BaseVm with ChangeNotifier {
  DataBaseManager dataBaseManager = DataBaseManager();
  List<Chatters> _chatters = [];
  List<Chatters> get chatters => _chatters;
  WebSocketUtils webSocketUtils = WebSocketUtils();
  Map<String, List<ChatMsg>> chatMapMsg = {};
  ScrollController scrollController = ScrollController();
  double oldPosition=0;
  Map<String,String> lastMsg={};
  Map<String,int> lastMsgLength={};

  @override
  void dispose() {
    webSocketUtils.dispose();

    super.dispose();
  }

  void clearUser() {
    _chatters = [];
    chatMapMsg = {};
    webSocketUtils.dispose();
    notifyListeners();
  }

  void setInitData(String toId) {
    if (!chatMapMsg.containsKey(toId)) {
      chatMapMsg[toId] = [];
    }
  }

  void sendMsg(String msg, String toId) {
    webSocketUtils.sendData(msg, toId);
  }

  void addChatter(String toId) {
    webSocketUtils.createNewChatter(toId);
  }

  void init() {
    if (Api.token.isNotEmpty) {
      print('数据库获取');
      dataBaseManager.getChatters().then((val) {
        print('得到数据库内容chatter:${val.map((f) => f.toJson()).toList().asMap()}');
        chatters.addAll(val);
        notifyListeners();
      });
      dataBaseManager.getChatMsg().then((val) {
        print('得到数据库内容chattMsg:${val.map((f) => f.toJson()).toList().asMap()}');
        val.forEach((f) {
          if (f.sign == 1) {
            if (!chatMapMsg.containsKey(f.toId)) {
              chatMapMsg[f.toId] = [];
            }

            chatMapMsg[f.toId].add(f);
          } else {
            if (!chatMapMsg.containsKey(f.userId)) {
              chatMapMsg[f.userId] = [];
            }
            chatMapMsg[f.userId].add(f);

            lastMsg[f.userId]=f.msg;

          }
        });
        if(scrollController.hasClients){

          scrollController.animateTo(scrollController.position.maxScrollExtent, curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),);
          oldPosition=scrollController.position.maxScrollExtent;
        }
      });
      startConnect();
    }
  }

  void startConnect() {
    if (Api.token.isNotEmpty) {
      webSocketUtils.startConnect();
      listenChatter();
      listenChatting();
      webSocketUtils.getChatters();
      webSocketUtils.getHistoryMessage();
    }
  }

  void listenChatter() {
    if (!webSocketUtils.chattersController.hasListener) {
      webSocketUtils.chattersController.stream.listen((data) {
        print('收到数据123$data');
        var model = ChattersModel.fromJson(data);
        if (model.chatters.isNotEmpty) {
          if (model.code == 302) {
            //新的聊天者
            _chatters.add(model.chatters.first);
            dataBaseManager.insertChatter(
                model.chatters.first.userId,
                model.chatters.first.toId,
                model.chatters.first.userName,
                model.chatters.first.headPic);
          }
          if (model.code == 301) {
            //存在的聊天者
            dataBaseManager.clearChatterTable();
            _chatters.clear();
            if (model.chatters.isNotEmpty) {
              model.chatters.forEach((f) {
                _chatters.add(f);
                dataBaseManager.insertChatter(
                    f.userId, f.toId, f.userName, f.headPic);
              });
            }
          }

          notifyListeners();
        }
      });
    }
  }

  void listenChatting() {
    if (!webSocketUtils.chattingController.hasListener) {
      webSocketUtils.chattingController.stream.listen((data) {
        print('chatting页面:$data');
        var model = ChatModel.fromJson(data);
        print('code:${model.code}');
        if (model.code == 210) {
          //自己发的
          if (!chatMapMsg.containsKey(model.chatMsg.first.toId)) {
            chatMapMsg[model.chatMsg.first.toId] = [];
          }
          chatMapMsg[model.chatMsg.first.toId].add(model.chatMsg.first);
          dataBaseManager.insertChatMsg(
              model.chatMsg.first.userId,
              model.chatMsg.first.toId,
              model.chatMsg.first.msg,
              model.chatMsg.first.sign);
        }

        else if (model.code == 220) {
          //收到的
          print('收到消息');
          if (!chatMapMsg.containsKey(model.chatMsg.first.userId)) {
            chatMapMsg[model.chatMsg.first.userId] = [];
          }
          chatMapMsg[model.chatMsg.first.userId].add(model.chatMsg.first);
          dataBaseManager.insertChatMsg(
              model.chatMsg.first.userId,
              model.chatMsg.first.toId,
              model.chatMsg.first.msg,
              model.chatMsg.first.sign);
          lastMsg[model.chatMsg.first.userId]=model.chatMsg.first.msg;
          try {
            if(!lastMsgLength.containsKey(model.chatMsg.first.userId)){
              lastMsgLength[model.chatMsg.first.userId]=0;
            }
            print('id:${model.chatMsg.first.userId}');
            lastMsgLength[model.chatMsg.first.userId]=lastMsgLength[model.chatMsg.first.userId]+1;
          } catch (e) {
            debugPrint('lenth:${lastMsgLength[model.chatMsg.first.userId]}');
            debugPrint('e:$e');
          }

        }
        //历史消息
        else if (model.code == 215) {
          model.chatMsg.forEach((f) {
            f.sign = 2;
            print('sign:${f.sign}');
            if (!chatMapMsg.containsKey(f.userId)) {
              chatMapMsg[f.userId] = [];
            }
            chatMapMsg[f.userId].add(f);
            dataBaseManager.insertChatMsg(f.userId, f.toId, f.msg, f.sign);
          });
        }

        notifyListeners();
        if(scrollController.hasClients){
          Future.delayed(Duration(milliseconds: 50)).then((_){
            scrollController.animateTo(scrollController.position.maxScrollExtent, curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),);
            oldPosition=scrollController.position.maxScrollExtent;
          }
            );


        }
      });
    }
  }

  @override
  Future loadMore() {
    return null;
  }

  void deleteChatter(String toId) {
    webSocketUtils.deleteChatter(toId);
  }

  @override
  Future loading() {
    if (Api.token.isEmpty) {
      showToast('你还没登录呢');
      return null;
    }
    webSocketUtils.startConnect();
    webSocketUtils.getChatters();
    webSocketUtils.getHistoryMessage();
    return null;
  }
  @override
  void notifyListeners() {

    super.notifyListeners();
  }
}
