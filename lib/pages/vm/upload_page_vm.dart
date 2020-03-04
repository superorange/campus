import 'package:flutter/cupertino.dart';

class UploadPageVm with ChangeNotifier{

  int _count = 0;
  set count(int c){
    _count=c;
    notifyListeners();
  }
  int get count =>_count;

}