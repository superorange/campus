import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/config/app_text/app_text.dart';
import 'package:flutter_app/pages/person_page.dart';
import 'package:flutter_app/pages/trade_page.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:flutter_app/utils/global_config.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'chatters_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  PageController _pageController = PageController(initialPage: 0);
  GlobalConfig globalConfig = GlobalConfig();
  Connectivity _connectivity = Connectivity();
  final List<Widget> _body = [
    TradePage(),
    ChattersPage(),
    PersonPage(),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    Provider.of<ChatChattersPageVm>(context, listen: false).init();
    _connectivity.onConnectivityChanged.listen(
        (data) {
          print(data);
          if (data == ConnectivityResult.mobile ||
              data == ConnectivityResult.wifi) {
            Provider.of<ChatChattersPageVm>(context, listen: false)
                .startConnect();
          }
        },
        cancelOnError: false,
        onDone: () {
          showToast(AppText.loseConnect);
        },
        onError: (e, s) {
          showToast(AppText.loseConnect);
        });
    Provider.of<PersonPageVm>(context, listen: false).loading().then((val) {
      if (val == LoginState.LoginFailed) {
        showToast(AppText.loginExpire,
            duration: Duration(seconds: 5),
            backgroundColor: Colors.black,
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold));
      Provider.of<PersonPageVm>(context,listen: false).clearUser();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _body,
      ),
      bottomNavigationBar: Consumer2<PersonPageVm, ChatChattersPageVm>(
          builder: (context, vm, chatVm, _) {
        return BottomNavigationBar(
            onTap: (index) {
              if ((index == 1 || index == 2) && Api.token.isEmpty) {
                Navigator.pushNamed(context, RouteName.login);
                return;
              }
              _pageController.jumpToPage(index);
              _currentIndex = index;
              setState(() {});
            },
            currentIndex: _currentIndex,
            elevation: .0,
            fixedColor: Colors.lightBlueAccent,
            selectedFontSize: 20,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.search), title: Text(AppText.appHome)),
              BottomNavigationBarItem(
                  icon: Stack(
                    fit: StackFit.loose,
                    children: <Widget>[
                      Align(
                        alignment: Alignment(0, 0),
                        child: Icon(Icons.message),
                      ),
                      Align(
                        alignment: Alignment(0.2, -0.9),
                        child: (chatVm.lastMsgLength?.keys?.length == null ||
                                chatVm.lastMsgLength.keys.length <= 0)
                            ? SizedBox()
                            : CircleAvatar(
                                radius: 8,
                                child: Text(
                                  chatVm.lastMsgLength.values
                                      .reduce((v, k) => v + k)
                                      .toString(),
                                  style: TextStyle(fontSize: 10),
                                ),
                                backgroundColor: Colors.red,
                              ),
                      )
                    ],
                  ),
                  title: Text(AppText.appMessage)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text(AppText.appPerson)),
            ]);
      }),
    );
  }
}
