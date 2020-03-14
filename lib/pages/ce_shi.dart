import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/database/user_dababase.dart';
import 'package:flutter_app/utils/screen_config.dart';

class CeShiPage extends StatefulWidget {
  @override
  _CeShiPageState createState() => _CeShiPageState();
}

class _CeShiPageState extends State<CeShiPage> with WidgetsBindingObserver {
  int _count = 0;
  @override
  void initState() {
//    Future.delayed(Duration(seconds: 5)).then((_){
//        print('event bus send CeshiPage');
//        EventBus()..sendMsg(200)..dispose();
//        Future.delayed(Duration(seconds: 3)).then((_){
//          EventBus().sendMsg(100);
//        });
//    });
//    EventBus().listen((data){
//      if(data==100){
//        showDialog(context: context
//        ,builder: (context){
//          return CupertinoAlertDialog(
//            title: Text('Event Bus$data'),
//          );
//            });
//      }
//    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                //执行缩放动画
                return ScaleTransition(child: child, scale: animation);
              },
              child: Container(
                height: 100,
                width: 100,
                color: _count % 2 == 0 ? Colors.yellowAccent : Colors.blue,
                key: ValueKey(_count),
              ),
            ),
            RaisedButton(
              child: const Text(
                '+1',
              ),
              onPressed: () async {
                await UserDataBase().init();

                Navigator.pushNamed(context, '/c');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class A extends StatefulWidget {
  @override
  _AState createState() => _AState();
}

class _AState extends State<A> {
  var msg = '';
  List<int> list = List.generate(9, (i) => i);
  @override
  Widget build(BuildContext context) {
    print(list);
    return Scaffold(
      body: Container(
          width: setWidth(750),
          height: setHeight(1334),
          child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Container(
                  color: index.isOdd ? Colors.blue : Colors.yellowAccent,
                  height: setHeight(600),
                  child: Wrap(
                      direction: Axis.horizontal,
                      spacing: setWidth(10),
                      runSpacing: setHeight(10),
                      children: list.sublist(0, index).map((f) {
                        return Container(
                          color: f.isOdd ? Colors.grey : Colors.purple,
                          child: CachedNetworkImage(
                            imageUrl:
                                'http://image.hnol.net/c/2020-01/28/18/202001281805145781-1559530.jpg',
                            width: setWidth(
                                getCount(list.sublist(0, index).length)),
                            fit: BoxFit.fitWidth,
                          ),
                        );
                      }).toList()),
                );
              })),
    );
  }
}

class B extends StatefulWidget {
  @override
  _BState createState() => _BState();
}

double getCount(int length) {
  if (length >= 2) {
    return 700 / 3;
  } else if (length == 1) {
    return 700;
  } else if (length == 2) {
    return 700 / 2;
  } else if (length == 0) {
    return 700;
  }
  return 700;
}

class _BState extends State<B> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class C extends StatefulWidget {
  @override
  _CState createState() => _CState();
}

class _CState extends State<C> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListWheelScrollView.useDelegate(
      itemExtent: 1000,
      magnification: 10,
      squeeze: 19,
      childDelegate: ListWheelChildBuilderDelegate(
          builder: (BuildContext context, int index) {
        return Container(
          height: 100,
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(index.toString()),
          padding: EdgeInsets.only(bottom: 10),
          color: index.isEven ? Colors.yellowAccent : Colors.blueAccent,
        );
      }),
    ));
  }
}
