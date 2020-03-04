import 'package:flutter/widgets.dart';

extension Pt on Object{
  void pt() => debugPrint(this);
}
class Log{
  static void pt({var flag='',@required msg}){
    debugPrint('标志:$flag 信息:$msg');
  }
}