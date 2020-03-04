import 'package:flutter/material.dart';
import 'package:flutter_app/pages/ce_shi.dart';
import 'package:flutter_app/pages/forum_information_page.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/index_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/trade_information_page.dart';
import 'package:flutter_app/pages/trade_list_page.dart';
import 'package:flutter_app/pages/trade_search_page.dart';
import 'package:flutter_app/pages/upload_page.dart';
import 'package:flutter_app/pages/upload_page_ok.dart';
import 'package:flutter_app/routes/page_route.dart';

class RouteName{
  static const index ='/';
  static const home ='/home';
  static const login='/login';
  static const smsLogin='/smsLogin';
  static const pwdLogin='/pwdLogin';
  static const tradeSearchPage='/tradeSearchPage';
  static const tradeListPage='/TradeListPage';
  static const tradeInformationPage='/tradeInformationPage';

  static const uploadPage='/uploadPage';
  static const uploadPageOk='/uploadPageOk';


  static const ceshi='/ceshi';

  static const a='/a';
  static const b='/b';
  static const c='/c';
  static const forumInformationPage='/forumInformationPage';





}

class AppRoute{
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case RouteName.index:
        return PageRouteBuilder(pageBuilder: (context,animation,_) =>IndexPage());
      case RouteName.home:
        return PageRouteBuilder(pageBuilder: (context,animation,_) =>HomePage());
      case RouteName.login:
        return PageRouteBuilder(pageBuilder: (context,animation,_) =>LoginPage());
      case RouteName.ceshi:

        return DefaultRoute(child: CeShiPage());
      case RouteName.tradeSearchPage:
        return DefaultRoute(child: TradeSearchPage());
      case RouteName.tradeListPage:
        return DefaultRoute(child: TradeListPage(settings.arguments));
      case RouteName.tradeInformationPage:
        return DefaultRoute(child: TradeInformationPage(settings.arguments));
      case RouteName.smsLogin:
        return DefaultRoute(child: SmsLogin());
      case RouteName.uploadPage:
        return DefaultRoute(child: UploadPage());
      case RouteName.smsLogin:
      return DefaultRoute(child: SmsLogin());
      case RouteName.uploadPageOk:
        return DefaultRoute(child: UploadPageOk());
      case RouteName.pwdLogin:
        return DefaultRoute(child: PwdLogin());
      case RouteName.a:
        return DefaultRoute(child: A());
      case RouteName.b:
        return DefaultRoute(child: B());
      case RouteName.c:
        return DefaultRoute(child: C());
      case RouteName.forumInformationPage:
        print('index:${settings.arguments}');
        return DefaultRoute(child: ForumInformationPage(index: settings.arguments,));
      default:
        return PageRouteBuilder(pageBuilder: (context,animation,_) =>Container());
    }

  }
}