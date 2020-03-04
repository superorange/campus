import 'package:sqflite/sqflite.dart' ;
import 'package:sqflite/sqlite_api.dart' ;
import 'package:flutter/material.dart';

class LoginDataBase{
  static Database database;
  LoginState(){
    setPath();
  }
  void setPath()async{
    var databasePath =await getDatabasesPath();
    String path = databasePath;

//    String path = join(databasePath,'token.db');
     database =await openDatabase(path,version: 1,onCreate: (Database db,int version)async{
      await db.execute('create table token ('
          'token varchar(100)');
    });
  }
    insertToken({@required String token})async {
    return await database.transaction((txn)async{
      return await txn.rawInsert('insert into token(token) values($token)').then((val){
        print('object$val');
      },onError: (e){
        return e;
      });
    });
  }
   updateToken({@required String token})async {
    return await database.transaction((txn)async{
      await txn.rawUpdate('update token set token =$token').then((val){

      });
    });
  }
  Future<String> getToken()async{
   return await database.transaction((txn)async{
     return  txn.rawQuery('select token from table').then((val){

        return val.first['token'];
      });
    });
  }

}