import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

void main() async {
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

    return OKToast(
        child: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatChattersPageVm()),
        ChangeNotifierProvider(create: (context) => PersonPageVm(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            textTheme: TextTheme(
                subhead: TextStyle(textBaseline: TextBaseline.alphabetic)),
            primaryColor: Colors.white),
        title: 'Campus',
        onGenerateRoute: AppRoute.generateRoute,
        initialRoute: RouteName.splashPage,
      ),
    ));
  }
}
