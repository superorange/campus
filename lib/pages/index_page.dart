import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/person_page.dart';
import 'package:flutter_app/pages/trade_page.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:flutter_app/utils/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          showToast('与服务器断开连接');
        },
        onError: (e, s) {
          showToast('与服务器断开连接');
        });
    Provider.of<PersonPageVm>(context, listen: false).loading().then((val) {
      if (val == LoginState.LoginFailed) {
        showToast('登录过期，请重新登录',
            duration: Duration(seconds: 5),
            backgroundColor: Colors.black,
            textStyle: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold));
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
      bottomNavigationBar: Consumer<PersonPageVm>(builder: (context, vm, _) {
        return BottomNavigationBar(
            onTap: (index) {
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
                  icon: Icon(Icons.search), title: Text('首页')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.message), title: Text('消息')),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), title: Text('个人')),
            ]);
      }),
    );
  }
}
