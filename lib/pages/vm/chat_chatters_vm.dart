import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/database/database_manager.dart';
import 'package:flutter_app/model/chat_model.dart';
import 'package:flutter_app/model/chatters_model.dart';
import 'package:flutter_app/pages/vm/base_vm.dart';
import 'package:flutter_app/utils/websocket_utils.dart';

class ChatChattersPageVm extends BaseVm with ChangeNotifier {
  DataBaseManager dataBaseManager = DataBaseManager();
  List<Chatters> _chatters = [];
  List<Chatters> get chatters => _chatters;
  WebSocketUtils webSocketUtils = WebSocketUtils();
  Map<String, List<ChatMsg>> chatMapMsg = {};

  @override
  void dispose() {
    webSocketUtils.dispose();
    super.dispose();
  }

  void clearUser() {
    _chatters = [];
    chatMapMsg = {};
    notifyListeners();
    webSocketUtils.dispose();
  }

  void setInitData(String userId) {
    if (!chatMapMsg.containsKey(userId)) {
      chatMapMsg[userId] = [];
    }
  }

  void sendMsg(String msg, String id) {
    webSocketUtils.sendData(msg, id);
  }

  void init() async {
    await DataBaseManager().init();
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
          }
        });
      });
      webSocketUtils.startConnect();
      webSocketUtils.getChatters();
      webSocketUtils.getHistoryMessage();
      listenChatter();
      listenChatting();
    }
  }

  void listenChatter() {
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
          model.chatters.forEach((f) {
            _chatters.add(f);
            dataBaseManager.insertChatter(
                f.userId, f.toId, f.userName, f.headPic);
          });
        }
        notifyListeners();
      }
    });
  }

  void listenChatting() {
    webSocketUtils.chattingController.stream.listen((data) {
      print('chatting页面:$data');
      var model = ChatModel.fromJson(data);
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
      if (model.code == 220) {
        //收到的
        if (!chatMapMsg.containsKey(model.chatMsg.first.userId)) {
          chatMapMsg[model.chatMsg.first.userId] = [];
        }
        chatMapMsg[model.chatMsg.first.userId].add(model.chatMsg.first);
        dataBaseManager.insertChatMsg(
            model.chatMsg.first.userId,
            model.chatMsg.first.toId,
            model.chatMsg.first.msg,
            model.chatMsg.first.sign);
      }
      //历史消息
      if (model.code == 215) {
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
    });
  }

  @override
  Future loadMore() {
    return null;
  }

  @override
  Future loading() {
    print(webSocketUtils.isOk);
    if (webSocketUtils.isOk) {
      webSocketUtils.getChatters();
      webSocketUtils.getHistoryMessage();
    } else {
      webSocketUtils.resetConnect();
      webSocketUtils.getChatters();
      webSocketUtils.getHistoryMessage();
    }

    return null;
  }
}
