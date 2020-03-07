import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/function_page.dart';
import 'package:flutter_app/pages/person_page.dart';
import 'package:flutter_app/pages/trade_search_page.dart';
import 'package:flutter_app/pages/upload_page.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/login_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'forum_page.dart';
import 'chatters_page.dart';
class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with AutomaticKeepAliveClientMixin{
  int pageIndex=0;
  List<Widget> _body=[
    FunctionPage(),
//    ForumPage(),
    TradeSearchPage(),
//  UploadPage(),
    ChattersPage(),
    PersonPage(),
  ];
  @override
  void initState() {
//    Future.delayed(Duration(seconds: 3)).then((_)=>checkLogin(context));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: _body,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.pushNamed(context, RouteName.uploadPage);
      },child: Icon(Icons.add),),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index){
          pageIndex=index;
          setState(() {
          });
        },
          currentIndex: pageIndex,
          elevation: .0,
          fixedColor: Colors.lightBlueAccent,
          selectedFontSize: 20,
          type: BottomNavigationBarType.fixed,items: [
        BottomNavigationBarItem(icon: Icon(Icons.functions), title: Text('功能卡片')),

        BottomNavigationBarItem(icon: Icon(Icons.search), title: Text('搜索')),
        BottomNavigationBarItem(icon: Icon(Icons.message), title: Text('消息')),
        BottomNavigationBarItem(icon: Icon(Icons.person), title: Text('个人')),
      ]),

    );
  }
  @override
  bool get wantKeepAlive => true;

}

void checkLogin(BuildContext context)async{
  var t=await LoginAuth().getToken();
  if(t.isEmpty){
    Navigator.pushNamed(context, RouteName.login);
  }
}


