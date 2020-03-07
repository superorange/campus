import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/vm/trade_list_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/login_auth.dart';
import 'package:jverify/jverify.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 // 打开调试模式
  runApp(MyApp());


}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      SystemUiOverlayStyle systemUiOverlayStyle =
      SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    }

    return OKToast(child: MaterialApp(
//      showPerformanceOverlay: true,
//      checkerboardOffscreenLayers: true, //使用了saveLayer的图像会显示为棋盘格式并随着页面刷新而闪烁
//      checkerboardRasterCacheImages: true, //
      theme: ThemeData(
          textTheme: TextTheme(subhead: TextStyle(textBaseline: TextBaseline.alphabetic)),
          primaryColor: Colors.white
      ),

      themeMode: ThemeMode.dark,
      title: 'Campus',
      onGenerateRoute: AppRoute.generateRoute,
      initialRoute: RouteName.login,
    ));
  }
}





