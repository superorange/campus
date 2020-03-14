import 'dart:async';

import 'package:flutter/cupertino.dart';

class SmsLoginVm with ChangeNotifier{
  bool _canLogin=false;
  bool get canLogin =>_canLogin;
  bool _startLogin=false;
  bool get startLogin =>_startLogin;
  bool _animationControl=false;
  bool get animationControl =>_animationControl;
  double _lastWidth=1.0;
  Timer _timer;
  double get width =>_width;
  int _time=60;
  int get time =>_time;
  bool _sendSms=false;
  bool _canCLick=false;
  bool get canClick =>_canCLick;
  void changeCanLogin(bool c){
    if(c!=_canLogin){
      _canLogin=c;
      notifyListeners();
    }
  }
  void changeCanClick(bool c){
    if(c!=_canCLick){
      _canCLick=c;
      notifyListeners();
    }

  }
  bool get sendSms =>_sendSms;
  void setWidth(double w){
    _lastWidth=w;
  }
  void changeAnimationControl(bool c){
    _animationControl=c;
  }
  void changeStartLogin(bool c){
    _startLogin=c;
    notifyListeners();
  }
  double _width=60;
  void changeWidth(double w,{bool listen=true}){
    _width=w;
    if(listen){
      notifyListeners();
    }

  }
  double get lastWidth => _lastWidth;
  void changeSendSms(bool c){
    if(c){
      _timer=Timer.periodic(Duration(seconds: 1), (timer){
        _time=60-timer.tick;

        notifyListeners();
        if(timer.tick==60){
          _time=60;
          timer.cancel();
          _sendSms=false;
          notifyListeners();
        }
      });

    }
    _sendSms=c;
    notifyListeners();
  }
  @override
  void dispose() {
    if(_timer?.isActive??false){
      _timer.cancel();
    }

    super.dispose();
  }

}