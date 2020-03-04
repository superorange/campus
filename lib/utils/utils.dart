
import 'dart:async';

import 'package:connectivity/connectivity.dart';

class Utils{


}
enum LoadState{

  LoadSuccess,
  LoadFailed,
  NullData,
  NetError,


}

class NetUtils {
  NetUtils._init(){
    netController=StreamController.broadcast();
    _connectivity.onConnectivityChanged.listen((data){
      if(data!=_connectivityResult){
        _connectivityResult=data;
        netController.sink.add(_connectivityResult);
      }
    });

  }
  static NetUtils _netUtils;
  ConnectivityResult _connectivityResult;
  Connectivity _connectivity=Connectivity();
  StreamController<ConnectivityResult> netController;
  factory NetUtils(){
    return _netUtils??=NetUtils._init();
  }
  void dispose(){
    netController.close();
  }

}



