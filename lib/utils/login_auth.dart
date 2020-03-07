import 'package:hive/hive.dart';

class LoginAuth{
  static LoginAuth _loginAuth;
   Box box=Hive.box('login');

   LoginAuth._init();
   Future<String> getToken()async{
    return box.get('token',defaultValue: '');
  }
   void saveToken(String value)async{
      box.put('token', value);
  }
  factory LoginAuth(){
     return _loginAuth??=LoginAuth._init();
  }

}