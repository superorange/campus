import 'package:flutter/material.dart';
import 'package:flutter_app/pages/ce_shi.dart';
import 'package:flutter_app/pages/chat_page.dart';
import 'package:flutter_app/pages/collection_page.dart';
import 'package:flutter_app/pages/index_page.dart';
import 'package:flutter_app/pages/login_page.dart';
import 'package:flutter_app/pages/my_goods_page.dart';
import 'package:flutter_app/pages/splash_page.dart';
import 'package:flutter_app/pages/trade_one_page.dart';
import 'package:flutter_app/pages/trade_page.dart';
import 'package:flutter_app/pages/trade_search_page.dart';
import 'package:flutter_app/pages/upload_page.dart';
import 'package:flutter_app/pages/upload_page_ok.dart';
import 'package:flutter_app/pages/user_collect_page.dart';
import 'package:flutter_app/pages/user_page.dart';
import 'package:flutter_app/routes/page_route.dart';

class RouteName {
  static const index = '/index';

  static const userPage = '/userPage';
  static const login = '/login';
  static const smsLogin = '/smsLogin';
  static const pwdLogin = '/pwdLogin';
  static const tradeSearchPage = '/tradeSearchPage';
  static const tradeListPage = '/TradeListPage';
  static const tradeInformationPage = '/tradeInformationPage';
  static const splashPage = '/';
  static const myGoodsPage = '/myGoodsPage';
  static const collectionPage = '/collectionPage';
  static const userCollectPage = '/userCollectPage';

  static const uploadPage = '/uploadPage';
  static const uploadPageOk = '/uploadPageOk';

  static const chatPage = '/chatPage';

  static const ceshi = '/ceshi';

  static const a = '/a';
  static const b = '/b';
  static const c = '/c';
}

class AppRoute {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.splashPage:
        return DefaultRoute(child: SplashPage());
      case RouteName.index:
        return PageRouteBuilder(
            pageBuilder: (context, animation, _) => IndexPage());
      case RouteName.login:
        return PageRouteBuilder(
            pageBuilder: (context, animation, _) => LoginPage());
      case RouteName.ceshi:
        return DefaultRoute(child: CeShiPage());
      case RouteName.tradeSearchPage:
        return DefaultRoute(child: TradePage());
      case RouteName.tradeListPage:
        return DefaultRoute(child: TradeSearchPage(settings.arguments));
      case RouteName.tradeInformationPage:
        return DefaultRoute(child: TradeOnePage(settings.arguments));
      case RouteName.userCollectPage:
        return DefaultRoute(child: UserCollectPage());
      case RouteName.smsLogin:
        return DefaultRoute(child: SmsLogin());
      case RouteName.chatPage:
        return DefaultRoute(child: ChatPage(settings.arguments));
      case RouteName.uploadPage:
        return DefaultRoute(child: UploadPage());
      case RouteName.collectionPage:
        return DefaultRoute(child: CollectionPage(settings.arguments));
      case RouteName.myGoodsPage:
        return DefaultRoute(child: MyGoodsPage());
      case RouteName.smsLogin:

        return DefaultRoute(child: SmsLogin());
      case RouteName.uploadPageOk:
        return DefaultRoute(child: UploadPageOk(settings.arguments));
      case RouteName.pwdLogin:
        return DefaultRoute(child: PwdLogin());
      case RouteName.a:
        return DefaultRoute(child: A());
      case RouteName.b:
        return DefaultRoute(child: B());
      case RouteName.c:
        return DefaultRoute(child: C());
      case RouteName.userPage:
        return DefaultRoute(child: UserPage(settings.arguments));
      default:
        return PageRouteBuilder(
            pageBuilder: (context, animation, _) => Container());
    }
  }
}
