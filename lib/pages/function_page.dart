import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/tab_widget.dart';

class FunctionPage extends StatefulWidget {
  @override
  _FunctionPageState createState() => _FunctionPageState();
}

class _FunctionPageState extends State<FunctionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          SizedBox(height: setHeight(10),),
          Container(
            height: setHeight(60),
            width: double.maxFinite,
            padding: EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: setWidth(250),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '功能中心',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  child: TextField(
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: -5, horizontal: 10),
                        suffixIcon: Icon(
                          CupertinoIcons.search,
                          color: Colors.grey,
                        ),
                        hintText: '兰凯搜索一触即达',
                        border: InputBorder.none),
                  ),
                  width: setWidth(450),
                  height: setHeight(50),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[300]),
                ),
              ],
            ),
          ), //60
          Expanded(
              child: ListView(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(
                    left: setWidth(25),
                    right: setWidth(25),
                    top: setHeight(20)),
                height: setHeight(200),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.yellowAccent,
                    borderRadius: BorderRadius.circular(7)),
              ), //200
              Container(
                height: setHeight(40),
                alignment: Alignment.centerLeft,
                child: Text(
                  '热门应用 >',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                margin: EdgeInsets.only(left: setWidth(25), top: setHeight(20)),
              ),
              SizedBox(
                height: setHeight(20),
              ),
              Container(
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
                height: setHeight(450),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 3,
                      )
                    ]),
                child: Wrap(
                  spacing: setWidth(90),
                  runSpacing: setHeight(20),
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: <Widget>[
                    TABWidget(t: CircleAvatar(), b: Text('课表')),
                    TABWidget(t: CircleAvatar(), b: Text('图书')),
                    TABWidget(t: CircleAvatar(), b: Text('快递')),
                    TABWidget(t: CircleAvatar(), b: Text('宽带')),
                    TABWidget(t: CircleAvatar(), b: Text('绩点')),
                    TABWidget(t: CircleAvatar(), b: Text('车票')),
                    TABWidget(t: CircleAvatar(), b: Text('一卡通')),
                    TABWidget(t: CircleAvatar(), b: Text('看妹子')),
                    TABWidget(t: CircleAvatar(), b: Text('发帖子')),
                    TABWidget(t: CircleAvatar(), b: Text('发宝贝')),
                    TABWidget(t: CircleAvatar(), b: Text('查电话')),
                    TABWidget(t: CircleAvatar(), b: Text('h')),
                  ],
                ),
              ),
              SizedBox(
                height: setHeight(20),
              ),
              Container(
                height: setHeight(40),
                alignment: Alignment.centerLeft,
                child: Text(
                  '应用分类 >',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                ),
                margin: EdgeInsets.only(
                  left: setWidth(25),
                ),
              ),
              SizedBox(
                height: setHeight(20),
              ),
              Card(
                child: Container(
                  height: setHeight(100),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: setWidth(25),
                      ),
                      CircleAvatar(),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '教学科研',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teaching and scientific research',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.yellow,
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
              ),
              SizedBox(
                height: setHeight(25),
              ),
              Card(
                child: Container(
                  height: setHeight(100),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: setWidth(25),
                      ),
                      CircleAvatar(),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '教学科研',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teaching and scientific research',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.yellow,
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
              ),
              SizedBox(
                height: setHeight(25),
              ),
              Card(
                child: Container(
                  height: setHeight(100),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: setWidth(25),
                      ),
                      CircleAvatar(),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '教学科研',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teaching and scientific research',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.yellow,
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
              ),
              SizedBox(
                height: setHeight(20),
              ),
              Card(
                child: Container(
                  height: setHeight(100),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: setWidth(25),
                      ),
                      CircleAvatar(),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '教学科研',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teaching and scientific research',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.yellow,
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
              ),
              SizedBox(
                height: setHeight(25),
              ),
              Card(
                child: Container(
                  height: setHeight(100),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: setWidth(25),
                      ),
                      CircleAvatar(),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '教学科研',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teaching and scientific research',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.yellow,
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
              ),
              SizedBox(
                height: setHeight(25),
              ),
              Card(
                child: Container(
                  height: setHeight(100),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: setWidth(25),
                      ),
                      CircleAvatar(),
                      SizedBox(
                        width: setWidth(25),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            '教学科研',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Teaching and scientific research',
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                color: Colors.yellow,
                margin:
                    EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
              ),
            ],
          ))
        ],
      )),
    );
  }
}
