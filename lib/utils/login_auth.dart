import 'package:shared_preferences/shared_preferences.dart';


class LoginAuth{
  static LoginAuth _loginAuth;
   SharedPreferences pre;
   LoginAuth._init();
   Future<String> getToken()async{
     var token;
     try {
       token= await pre.get('token');
     }catch(e){
       return '';
     }
    return token;
  }
   void saveToken(String value)async{
   await pre.setString('token', value);
  }

   void init()async{
    pre=await SharedPreferences.getInstance();
  }
  factory LoginAuth(){
     return _loginAuth??=LoginAuth._init();
  }



}