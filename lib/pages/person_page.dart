import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/app_text/app_text.dart';
import 'package:flutter_app/config/font/font_style.dart';
import 'package:flutter_app/pages/vm/person_page_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:flutter_easyrefresh/bezier_circle_header.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class PersonPage extends StatefulWidget {
  @override
  _PersonPageState createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage>
    with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Scaffold(
          body: Consumer<PersonPageVm>(builder: (context, vm, _) {
            if (vm.user == null) {

              return InkWell(
              onTap: () {
              Navigator.pushNamed(context, RouteName.login);
              },
              child:Center(
                  child:  Text(AppText.login,style: TextStyle(
                    color: Colors.brown,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 8
                  ),)
              ),
              );
            }
            return EasyRefresh(
                header: BezierCircleHeader(),
                onRefresh: () async {
                  vm.loading();
                },
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 340,
                      width: double.infinity,
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 340,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [Colors.blue[300], Colors.blueAccent],
                                )),
                            child: CachedNetworkImage(imageUrl: vm.user.headPic,fit: BoxFit.fill,errorWidget: (s,_,t)=>Container(),),
                          ),
                          Container(
                            height: 350,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                ),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(padding: EdgeInsets.only(
                                    left: 20
                                  ),child: Text(
                                    AppText.personCenter,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),),
                                ),
                                const SizedBox(
                                  height: 70,
                                ),
                                InkWell(
                                  onTap: vm.user.userName.isEmpty
                                      ? () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return ModifyInformationWidget(
                                                    '修改用户名', '请输入新用户名',
                                                    onCancel: () {
                                                  Navigator.pop(context);
                                                }, onClick: (val) {
                                                  vm.updateUser({
                                                    'type': 'userName',
                                                    'userName': val
                                                  });
                                                  Navigator.pop(context);
                                                });
                                              });
                                        }
                                      : null,
                                  child: Text(
                                    vm.user.userName.isEmpty
                                        ? '未设置用户名，点击更改'
                                        : '${vm.user.userName}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 20,fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                InkWell(
                                  onTap: vm.user.sign.isEmpty
                                      ? () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return ModifyInformationWidget(
                                              '修改个性签名', '请输入新个性签名',
                                              onCancel: () {
                                                Navigator.pop(context);
                                              }, onClick: (val) {
                                            vm.updateUser({
                                              'type': 'sign',
                                              'sign': val
                                            });
                                            Navigator.pop(context);
                                          });
                                        });
                                  }
                                      : null,
                                  child: Text(
                                    vm.user.sign .isEmpty
                                        ? '未设置个性签名，点击更改'
                                        : '${vm.user.sign}',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 17,fontWeight: FontWeight.w500),
                                  ),
                                ),
//                                Card(
//                                  child: vm.user.xh.isEmpty
//                                      ? Center(
//                                          child: FlatButton(
//                                              color: Colors.brown,
//                                              onPressed: () {},
//                                              child: Container(
//                                                margin: EdgeInsets.only(
//                                                    top: 35, bottom: 35),
//                                                alignment: Alignment.center,
//                                                child: Text(
//                                                  '绑定学号',
//                                                  style: TextStyle(
//                                                      color: Colors.white,
//                                                      fontSize: 20),
//                                                ),
//                                              )),
//                                        )
//                                      : Container(
//                                          height: 100,
//                                          width: double.infinity,
//                                          child: Theme(
//                                              data: ThemeData(
//                                                  textTheme: TextTheme(
//                                                      display2: TextStyle(
//                                                          fontSize: 39))),
//                                              child: Column(
//                                                crossAxisAlignment:
//                                                    CrossAxisAlignment.start,
//                                                mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceEvenly,
//                                                children: <Widget>[
//                                                  Row(
//                                                    mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .spaceEvenly,
//                                                    children: <Widget>[
//                                                      Text.rich(
//                                                        TextSpan(
//                                                            text: '你好 ',
//                                                            children: [
//                                                              TextSpan(
//                                                                text:
//                                                                    '${vm.user.name}',
//                                                              ),
//                                                              TextSpan(
//                                                                  text: '同学'),
//                                                            ]),
//                                                      ),
//                                                      Text.rich(
//                                                        TextSpan(
//                                                            text: '学号 ',
//                                                            children: [
//                                                              TextSpan(
//                                                                  text:
//                                                                      't1670494917'),
//                                                            ]),
//                                                      ),
//                                                    ],
//                                                  ),
//                                                  Row(
//                                                    mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .spaceEvenly,
//                                                    children: <Widget>[
//                                                      Text.rich(
//                                                        TextSpan(
//                                                            text: '四川轻化工大学 ',
//                                                            children: [
//                                                              TextSpan(
//                                                                  text: '宜宾校区'),
//                                                            ]),
//                                                      ),
//                                                      Text.rich(
//                                                        TextSpan(
//                                                            text: '计算机学院 ',
//                                                            children: [
//                                                              TextSpan(
//                                                                  text:
//                                                                      '网络工程2班'),
//                                                            ]),
//                                                      ),
//                                                    ],
//                                                  ),
//                                                ],
//                                              )),
//                                        ),
//                                  color: Colors.white,
//                                  margin: EdgeInsets.only(
//                                      left: setWidth(25), right: setWidth(25)),
//                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(),
                    Container(
                      height: setHeight(80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          TABWidget(
                              t: Text('${vm.user.collection}'),
                              b: Text(
                                '收藏',
                                style: AppStyle.personPageStyle(),
                              )),
                          TABWidget(
                              t: Text('${vm.user.fans}'),
                              b: Text('粉丝', style: AppStyle.personPageStyle())),
                          TABWidget(
                              t: Text('${vm.user.post}'),
                              b: Text('帖子', style: AppStyle.personPageStyle())),
                          TABWidget(
                              t: Text('${vm.user.goodsCount}'),
                              b: Text('商品', style: AppStyle.personPageStyle())),
                        ],
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ModifyDoubleWidget(
                                  '修改密码', '请输入旧密码', '请输入新密码', (val) {
                                vm.updateUser({
                                  'type': 'password',
                                  'password': val[1],
                                  'oldPassword': val[0]
                                });
                                Navigator.pop(context);
                              });
                            });
                      },
                      child: Container(
                          height: setHeight(60),
                          padding: EdgeInsets.only(
                              left: setWidth(25), right: setWidth(25)),
                          width: double.infinity,
                          child: InformationWidget(
                              a: Text('密码修改',
                                  style: AppStyle.personPageInformationStyle()),
                              b: Text(''),
                              c: Icon(Icons.lock))),
                    ),
                    Divider(),
//                    Container(
//                        height: setHeight(60),
//                        padding: EdgeInsets.only(
//                            left: setWidth(25), right: setWidth(25)),
//                        width: double.infinity,
//                        child: InformationWidget(
//                            a: Text('上课提醒',
//                                style: AppStyle.personPageInformationStyle()),
//                            b: Text('今天有5节课'),
//                            c: Icon(Icons.notifications_none))),
//                    Divider(),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ModifyInformationWidget('修改用户名', '请输入新用户名',
                                  onCancel: () {
                                Navigator.pop(context);
                              }, onClick: (val) {
                                vm.updateUser(
                                    {'type': 'userName', 'userName': val});
                                Navigator.pop(context);
                              });
                            });
                      },
                      child: Container(
                          height: setHeight(60),
                          padding: EdgeInsets.only(
                              left: setWidth(25), right: setWidth(25)),
                          width: double.infinity,
                          child: InformationWidget(
                              a: Text('修改用户名',
                                  style: AppStyle.personPageInformationStyle()),
                              b: Container(),
                              c: Icon(Icons.sort))),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ModifyInformationWidget('修改手机号', '请输入新手机号',
                                  onCancel: () {
                                Navigator.pop(context);
                              }, onClick: (val) {
                                vm.updateUser({'type': 'phone', 'phone': val});
                                Navigator.pop(context);
                              });
                            });
                      },
                      child: Container(
                          height: setHeight(60),
                          padding: EdgeInsets.only(
                              left: setWidth(25), right: setWidth(25)),
                          width: double.infinity,
                          child: InformationWidget(
                              a: Text('修改手机号',
                                  style: AppStyle.personPageInformationStyle()),
                              b: Container(),
                              c: Icon(Icons.phone))),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () async {

                        List<Asset> headPic;
                        try {
                          headPic =
                          await MultiImagePicker.pickImages(
                              maxImages: 1, enableCamera: true);
                        } catch (e) {
                          return;
                        }
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (ctx) {
                              vm
                                  .updateImage(headPic.first)
                                  .then((val) {
                                if (!val) {
                                  showToast('上传失败，请重试');
                                }
                                Navigator.pop(context);
                              });
                              return LoadingWidget(
                                ctx,
                                canRemove: false,
                              );
                            });
                      },
                      child: Container(
                          height: setHeight(60),
                          padding: EdgeInsets.only(
                              left: setWidth(25), right: setWidth(25)),
                          width: double.infinity,
                          child: InformationWidget(
                              a: Text('头像/背景图更换',
                                  style: AppStyle.personPageInformationStyle()),
                              b: Container(),
                              c: Icon(Icons.picture_in_picture))),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return ModifyInformationWidget(
                                  '修改个性签名', '请输入新个性签名', onCancel: () {
                                Navigator.pop(context);
                              }, onClick: (val) {
                                vm.updateUser({'type': 'sign', 'sign': val});
                                Navigator.pop(context);
                              });
                            });
                      },
                      child: Container(
                          height: setHeight(60),
                          padding: EdgeInsets.only(
                              left: setWidth(25), right: setWidth(25)),
                          width: double.infinity,
                          child: InformationWidget(
                              a: Text('修改个性签名',
                                  style: AppStyle.personPageInformationStyle()),
                              b: Container(),
                              c: Icon(Icons.border_color))),
                    ),
                    Divider(),
                    Container(
                        height: setHeight(60),
                        padding: EdgeInsets.only(
                            left: setWidth(25), right: setWidth(25)),
                        width: double.infinity,
                        child: InformationWidget(
                            a: Text('帮助反馈',
                                style: AppStyle.personPageInformationStyle()),
                            b: Container(),
                            c: Icon(Icons.help_outline))),
                    Divider(),
                    Container(
                        height: setHeight(60),
                        padding: EdgeInsets.only(
                            left: setWidth(25), right: setWidth(25)),
                        width: double.infinity,
                        child: InformationWidget(
                            a: Text('系统设置',
                                style: AppStyle.personPageInformationStyle()),
                            b: Container(),
                            c: Icon(Icons.settings))),
                    Divider(),
                    InkWell(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('确定退出登录吗'),
                                content: Text('温馨提示：退出登录后将无法找回现有聊天等数据！'),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('取消')),
                                  FlatButton(
                                      onPressed: () async {
                                        await vm.clearUser(context);

                                        Navigator.pop(context);
                                      },
                                      child: Text('退出'))
                                ],
                              );
                            });
                      },
                      child: Container(
                          height: setHeight(60),
                          padding: EdgeInsets.only(
                              left: setWidth(25), right: setWidth(25)),
                          width: double.infinity,
                          child: InformationWidget(
                              a: Text('退出登录',
                                  style: AppStyle.personPageInformationStyle()),
                              b: Container(),
                              c: Icon(Icons.shuffle))),
                    ),
                    Divider(),
                  ],
                ));
          }),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}

// ignore: must_be_immutable
class InformationWidget extends StatelessWidget {
  Widget a, b, c;
  InformationWidget({@required this.a, @required this.b, @required this.c});
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
              children: <Widget>[a, b],
            ),
          ),
          c,
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ModifyInformationWidget extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();
  String title;
  String hintText;
  Function onClick;
  Function onCancel;
  ModifyInformationWidget(this.title, this.hintText,
      {this.onCancel, this.onClick});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$title'),
      content: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(hintText: '$hintText'),
      ),
      actions: <Widget>[
        FlatButton(onPressed: () => onCancel(), child: Text('取消')),
        FlatButton(
            onPressed: () {
              if (_textEditingController.text.length >= 4 &&
                  _textEditingController.text.length <= 12) {
                onClick(_textEditingController.text);
                return;
              }
              showToast('参数不合法');
            },
            child: Text('确定')),
      ],
    );
  }
}

// ignore: must_be_immutable
class ModifyDoubleWidget extends StatelessWidget {
  TextEditingController _textEditingController1 = TextEditingController();
  TextEditingController _textEditingController2 = TextEditingController();
  String title;
  String hintText1;
  String hintText2;
  Function onClick;
  ModifyDoubleWidget(this.title, this.hintText1, this.hintText2, this.onClick);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('$title'),
      content: Container(
        height: 100,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _textEditingController1,
              decoration: InputDecoration(hintText: '$hintText1'),
            ),
            TextField(
              controller: _textEditingController2,
              decoration: InputDecoration(hintText: '$hintText2'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('取消')),
        FlatButton(
            onPressed: () {
              if (_textEditingController1.text.length >= 4 &&
                  _textEditingController1.text.length <= 12 &&
                  _textEditingController2.text.length >= 4 &&
                  _textEditingController2.text.length <= 12) {
                onClick([
                  _textEditingController1.text,
                  _textEditingController2.text
                ]);
                return;
              }
              showToast('参数不合法');
            },
            child: Text('确定')),
      ],
    );
  }
}
