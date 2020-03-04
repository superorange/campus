import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/font/font_style.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/tab_widget.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(context: context, child: Scaffold(
      body:ListView(
        children: <Widget>[
          Container(height: setHeight(485),width:double.infinity,child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Flexible(child: Container(decoration: BoxDecoration(
                      gradient: LinearGradient(begin:Alignment.centerLeft,end: Alignment.centerRight,colors: [
                        Colors.blue[300],
                        Colors.blueAccent
                      ],)
                  ),),flex: 4,),
                  Flexible(child: Container(decoration: BoxDecoration(
                      gradient: LinearGradient(begin:Alignment.centerLeft,end: Alignment.centerRight,colors: [
                        Colors.white60,
                        Colors.white
                      ],)
                  ),),flex: 1,),
                ],
              ),
              Container(height: setHeight(485),width:double.infinity,child: Column(crossAxisAlignment: CrossAxisAlignment.center,children: <Widget>[
                SizedBox(height: setHeight(80),),
                Text('个人中心',style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20
                ),),
                SizedBox(height: setHeight(20),),
                CircleAvatar(),
                SizedBox(height: setHeight(20),),
                Text('牵着李白去吃肉'),
                SizedBox(height: setHeight(30),),
                Card(
                  child: Container(
                    height: setHeight(150),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text.rich(
                            TextSpan(
                                text: '你好 ',
                                children: [
                                  TextSpan(text: '田锦岗同学'),

                                ]),),
                          Text.rich(
                            TextSpan(
                                text: '学号 ',
                                children: [
                                  TextSpan(text: 't1670494917'),

                                ]),),
                        ],
                      ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text.rich(
                              TextSpan(
                                  text: '四川轻化工大学 ',
                                  children: [
                                    TextSpan(text: '宜宾校区'),

                                  ]),),
                            Text.rich(
                              TextSpan(
                                  text: '计算机学院 ',
                                  children: [
                                    TextSpan(text: '网络工程2班'),

                                  ]),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  color: Colors.white,
                  margin:
                  EdgeInsets.only(left: setWidth(25), right: setWidth(25)),
                ),



              ],),),
            ],
          ),),
          SizedBox(height: setHeight(20),),
          Divider(),
          Container(height: setHeight(80),child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TABWidget(t: Text('29'), b: Text('收藏',style: AppStyle.personPageStyle(),)),
              TABWidget(t: Text('29'), b: Text('粉丝',style: AppStyle.personPageStyle())),
              TABWidget(t: Text('29'), b: Text('帖子',style: AppStyle.personPageStyle())),
              TABWidget(t: Text('29'), b: Text('商品',style: AppStyle.personPageStyle())),

            ],
          ),),
          Divider(),
          Container(height: setHeight(60),padding: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),width:double.infinity,child:
          InformationWidget(a: Text('我的同学',style: AppStyle.personPageInformationStyle()), b: Text('97'), c: Icon(Icons.person))),
          Divider(),
          Container(height: setHeight(60),padding: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),width:double.infinity,child:
          InformationWidget(a: Text('密码修改',style: AppStyle.personPageInformationStyle()), b: Text('密码178天没有修改啦'), c: Icon(Icons.lock))),
          Divider(),
          Container(height: setHeight(60),padding: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),width:double.infinity,child:
          InformationWidget(a: Text('上课提醒',style: AppStyle.personPageInformationStyle()), b: Text('今天有5节课'), c: Icon(Icons.notifications_none))),
          Divider(),
          Container(height: setHeight(60),padding: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),width:double.infinity,child:
          InformationWidget(a: Text('帮助反馈',style: AppStyle.personPageInformationStyle()), b: Container(), c: Icon(Icons.help_outline))),
          Divider(),
          Container(height: setHeight(60),padding: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),width:double.infinity,child:
          InformationWidget(a: Text('系统设置',style: AppStyle.personPageInformationStyle()), b: Container(), c: Icon(Icons.settings))),
          Divider(),
          Container(height: setHeight(60),padding: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),width:double.infinity,child:
          InformationWidget(a: Text('退出登录',style: AppStyle.personPageInformationStyle()), b: Container(), c: Icon(Icons.shuffle))),
          Divider(),
        ],
      ),
    ),removeTop: true,);
  }
}
class InformationWidget extends StatelessWidget {
  Widget a,b,c;
  InformationWidget({@required this.a,@required this.b,@required this.c});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: setWidth(600),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                a,b
              ],
            ),
          ),
          c,
        ],
      ),
    );
  }
}

