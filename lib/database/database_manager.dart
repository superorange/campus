import 'package:flutter_app/model/chat_model.dart';
import 'package:flutter_app/model/chatters_model.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';

class DataBaseManager {
  Database _dataBase;
  DataBaseManager._init();
  String dbName = 'campus.db';
  String dbPath;
  var lock = new Lock(reentrant: true);
  // ignore: non_constant_identifier_names
  String sql_createChatterTable =
      "CREATE TABLE IF NOT EXISTS chatter_table (id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT, toId TEXT,userName TEXT,headPic TEXT)";
  // ignore: non_constant_identifier_names
  String sql_createChatMsgTable =
      "CREATE TABLE IF NOT EXISTS chatmsg_table (id INTEGER PRIMARY KEY AUTOINCREMENT, userId TEXT,toId TEXT,msg TEXT,sign INTEGER)";
  static DataBaseManager _dataBaseManager;
  factory DataBaseManager() {
    return _dataBaseManager ??= DataBaseManager._init();
  }
  Future<Database> init() async {
    try {
      var a = DateTime.now().millisecondsSinceEpoch;
      return await lock.synchronized(() async {
        if (_dataBase == null) {
          var databasesPath = await getDatabasesPath();
          dbPath = join(databasesPath, dbName);
          _dataBase = await openDatabase(dbPath, version: 1,
              onCreate: (Database db, int version) async {
            await db.execute(sql_createChatMsgTable);
            await db.execute(sql_createChatterTable);
          });
          print('数据库初始化成功,耗时:${DateTime.now().millisecondsSinceEpoch - a}毫秒');
          return _dataBase;
        }
        return _dataBase;
      });
    } catch (e) {
      throw Exception(SqliteState.Failed);
    }
  }

  Future<int> insertChatter(
      String userId, String toId, String userName, String headPic) async {
    return await _dataBase.rawInsert(
        """INSERT INTO chatter_table(userId,toId,userName,headPic) VALUES("$userId", "$toId","$userName","$headPic")""");
  }

  Future<int> insertChatMsg(
      String userId, String toId, String msg, int sign) async {
    return await _dataBase.rawInsert(
        """INSERT INTO chatmsg_table(userId, toId,msg,sign) VALUES("$userId","$toId","$msg",$sign)""");
  }

  Future<List<ChatMsg>> getChatMsg() async {
    if (_dataBase.isOpen) {
      List<Map> list = await _dataBase.rawQuery('SELECT * FROM chatmsg_table');
      var chatData = list.map((f) => ChatMsg.fromJson(f)).toList();
      return chatData;
    }
    return null;
  }

  Future<List<Chatters>> getChatters() async {
    if (_dataBase.isOpen) {
      List<Map> list = await _dataBase.rawQuery('SELECT * FROM chatter_table');
      var chatData = list.map((f) => Chatters.fromJson(f)).toList();
      return chatData;
    }
    return null;
  }

  Future<int> clearChatterTable() async {
    if (_dataBase.isOpen) {
      var t = await _dataBase.delete('chatter_table');
      return t;
    }
    return null;
  }

  Future<int> clearChatMsgTable() async {
    if (_dataBase.isOpen) {
      var t = await _dataBase.delete('chatmsg_table');
      return t;
    }
    return null;
  }

  void dispose() async {
    await _dataBase.close();
  }
}
