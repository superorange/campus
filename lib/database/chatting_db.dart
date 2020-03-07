import 'package:flutter_app/model/chatters_model.dart';
import 'package:hive/hive.dart';
import 'package:sqflite/sqflite.dart';

class ChattersDb{
  static ChattersDb _chattersDb;
 

  ChattersDb.init();
  factory ChattersDb(){
    return _chattersDb??=ChattersDb.init();
  }
  Box box = Hive.box('chatters');

  Future<List<ChattersModel>> getChatters(){
    var t=box.get('chatter');
    return t;


  }

  void addChatters(ChattersModel chattersModel)async{
    var b2=await Hive.openBox('name');
      box.add(chattersModel);
      box.addAll(values)
      box.get('key');
      b2.values.toList();


  }




}




