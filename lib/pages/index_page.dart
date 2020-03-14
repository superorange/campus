import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/person_page.dart';
import 'package:flutter_app/pages/trade_page.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:flutter_app/utils/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'chatters_page.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  PageController _pageController = PageController(initialPage: 0);
  GlobalConfig globalConfig = GlobalConfig();
  final List<Widget> _body = [
    TradePage(),
    ChattersPage(),
    PersonPage(),
  ];
  int _currentIndex = 0;
  @override
  void initState() {
    globalConfig.streamController.stream.listen((data) {
      if (data is GlobalState) {
        if (data == GlobalState.Ok) {}
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: true)
          ..init(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: PageView(
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
