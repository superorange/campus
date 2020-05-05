import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/database/user_dababase.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/model/login_model.dart';
import 'package:flutter_app/model/user_model.dart';
import 'package:flutter_app/pages/vm/pwd_login_vm.dart';
import 'package:flutter_app/pages/vm/sms_login_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/service/user_service.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:jverify/jverify.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  Shader shader;
  final Jverify jverify = Jverify();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage('assets/images/login_background.jpg'),
        fit: BoxFit.cover)
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: true,
          elevation: .0,
        ),
        body: Padding(padding: EdgeInsets.only(
            left: 25,right: 25
        ),child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(child: Align(child: Text('闲货直通车',style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 3
            ),),alignment: Alignment(0,-0.5),),flex: 1,fit: FlexFit.tight,),
            Flexible(child:  ChooseLoginPanel(),flex: 2,fit: FlexFit.tight,),
          ],
        ),),
      ),
    );
  }
}



class ChooseLoginPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void fastLogin(BuildContext loginCtx) async {
      Jverify jverify = new Jverify();
      try {
        jverify.setup(
            appKey: Api.JLoginKEy, channel: "devloper-default");
      } catch (e) {
        print('极光初始化失败：$e');
      } // 初始化sdk,  appKey 和 channel 只对ios设置有效
      var init = await jverify.isInitSuccess();
      var net = await jverify.checkVerifyEnable();
      var preLogin = await jverify.preLogin();
      if (init['result'] && net['result'] && preLogin['code'] == 7000) {
        Navigator.pop(loginCtx);
        jverify.loginAuth(false).then((code) {
          if (code['code'] == 6000) {
            //登录成功
            var token = code['message'];
            jverify.dismissLoginAuthView();
            showDialog(
                context: context,
                builder: (ctx) {
                  UserService()
                      .autoLogin(data: LoginModel(data: token).toJson())
                      .then((val) {
                    var model = BaseModel.fromJson(val.data);
                    if (model.code == 200) {
                      var user = UserModel.fromJson(model.data);
                      UserDataBase().insertUser(user, model.token);
                      Navigator.pushNamedAndRemoveUntil(context,
                          RouteName.index, ModalRoute.withName('/index'));
                    } else {
                      showToast('网络连接不通，请稍后再试');
                      Navigator.pop(context);
                    }
                  });
                  return LoadingWidget(
                    ctx,
                    canRemove: false,
                  );
                });
          } else if (code['code'] == 6002) {
            jverify.dismissLoginAuthView();
            showToast('登录取消', position: ToastPosition.bottom);
          } else {
            jverify.dismissLoginAuthView();
            showToast('登录失败', position: ToastPosition.bottom);
          }
        });
      } else {
        Navigator.pop(loginCtx);
        showToast('你的环境不支持一键登录', position: ToastPosition.bottom);
      }
    }

    return Container(
      height: 250,
      margin: EdgeInsets.only(top: 80),
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (ctx) {
                    fastLogin(ctx);
                    return LoadingWidget(ctx);
                  });
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '本机号码一键登录/注册',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            color: Colors.white70.withOpacity(0.2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteName.smsLogin);
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '短信验证码登录/注册',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            color: Colors.white70.withOpacity(0.2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(
            height: 30,
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, RouteName.pwdLogin);
            },
            child: Container(
              width: double.infinity,
              height: 50,
              alignment: Alignment.center,
              child: Text(
                '密码登录',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 17),
              ),
            ),
            color: Colors.white70.withOpacity(0.2),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class SmsLogin extends StatefulWidget {
  @override
  _SmsLoginState createState() => _SmsLoginState();
}

class _SmsLoginState extends State<SmsLogin> with TickerProviderStateMixin {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  FocusNode phoneFocusNode = FocusNode();
  FocusNode codeFocusNode = FocusNode();
  SmsLoginVm smsLoginVm = SmsLoginVm();
  AnimationController _animationController;
  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    smsLoginVm.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: ChangeNotifierProvider.value(
          value: smsLoginVm,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: true,
              elevation: .0,

            ),
            body: SafeArea(
                child: Container(
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 100,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.grey[300],
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(child:
                            Consumer<SmsLoginVm>(builder: (context, vm, _) {
                          return TextField(
                            keyboardType: TextInputType.phone,
                            focusNode: phoneFocusNode,
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11)
                            ],
                            controller: _phoneController,
                            onChanged: (s) {
                              if (s.length == 11) {
                                vm.changeCanClick(true);
                              } else {
                                vm.changeCanClick(false);
                              }
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                              hintText: '输入号码',
                              border: InputBorder.none,
                            ),
                          );
                        })),
                        Consumer<SmsLoginVm>(builder: (context, vm, _) {
                          return Container(
                            width: setWidth(250),
                            color: (!vm.sendSms && vm.canClick)
                                ? Colors.blueAccent
                                : Colors.grey[400],
                            child: FlatButton(
                                onPressed: (!vm.sendSms && vm.canClick)
                                    ? () {
                                        if (Regular.isChinaPhoneLegal(
                                            _phoneController.value.text)) {
                                          showDialog(
                                              context: context,
                                              builder: (ctx) {
                                                var data = {
                                                  "code": 200,
                                                  "phone": _phoneController.value.text,
                                                  "smsCode": "",
                                                };
                                                UserService()
                                                    .smsLogin(data: data)
                                                    .then((val) {
                                                  if (val.data['code'] == 200) {
                                                    showToast('短信发送成功');
                                                    Navigator.pop(ctx);
                                                    vm.changeSendSms(true);
                                                    if (mounted) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              codeFocusNode);
                                                    }
                                                  } else {
                                                    Navigator.pop(ctx);
                                                    showToast('短信发送失败');
                                                  }
                                                }, onError: (e) {
                                                  Navigator.pop(ctx);
                                                  showToast('短信发送失败');
                                                });

                                                return CupertinoActivityIndicator();
                                              });
                                        } else {
                                          showToast('号码格式不正确！');
                                        }
                                      }
                                    : null,
                                child: Text(
                                  vm.sendSms ? '${vm.time} S' : '获取验证码',
                                  style: TextStyle(
                                    color:
                                        vm.sendSms ? Colors.blue : Colors.white,
                                  ),
                                )),
                          );
                        }),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    padding: EdgeInsets.only(left: 10),
                    color: Colors.grey[300],
                    child: Consumer<SmsLoginVm>(
                      builder: (context, vm, _) {
                        return TextField(
                          keyboardType: TextInputType.number,
                          focusNode: codeFocusNode,
                          readOnly: vm.sendSms ? false : true,
                          onChanged: (s) {
                            if (s.length == 6) {
                              codeFocusNode.unfocus();
                              vm.changeCanLogin(true);
                            } else {
                              vm.changeCanLogin(false);
                            }
                          },
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6)
                          ],
                          controller: _codeController,
                          decoration: InputDecoration(
                            hintText: '请输入6位数字验证码',
                            border: InputBorder.none,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Consumer<SmsLoginVm>(builder: (context, vm, _) {
                    return InkWell(
                     onTap: (){
                       vm.changeStartLogin(true);
                       var data={
                         'code':201,
                         'phone':_phoneController.text,
                         'smsCode':_codeController.text
                       };
                       UserService().smsLogin(data: data).then((val) {
                         BaseModel model;
                         try {
                            model=
                                                    BaseModel.fromJson(val.data);
                         } catch (e) {
                           print('e:$e');
                         }
                         if (model.code == 200) {
                           var user = UserModel.fromJson(model.data);
                           UserDataBase()
                               .insertUser(user, model.token);
                           Navigator.pushNamedAndRemoveUntil(
                               context,
                               RouteName.index,
                               ModalRoute.withName('/'));
                         } else {
                           showToast('验证码错误');
                           vm.changeAnimationControl(false);
                           vm
                             ..changeWidth(60)
                             ..changeStartLogin(false);
                         }
                       }, onError: (e) {
                         showToast('网络不好，再试一次吧');
                         vm.changeStartLogin(false);
                       });
                     },
                      child: Container(
                        height: 50,

                        color:Colors.blue.withOpacity(0.8),

                        width: MediaQuery.of(context).size.width-40,
                        child: AnimatedSwitcher(
                          duration: Duration(seconds: 1),
                          child: vm.startLogin
                              ? CupertinoActivityIndicator(
                                  key: ValueKey('true'),
                                )
                              : Container(
                            key: ValueKey('false'),
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text('登录',style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.white
                            ),),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            )),
          ),
        ),
        onWillPop: () async {
          if (codeFocusNode.hasFocus) {
            codeFocusNode.unfocus();
          }
          if (phoneFocusNode.hasFocus) {
            phoneFocusNode.unfocus();
          }
          return true;
        });
  }
}

// ignore: must_be_immutable
class PwdLogin extends StatelessWidget {
  TextEditingController _idController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();
  FocusNode _idFocusNode = FocusNode();
  FocusNode _pwdFocusNode = FocusNode();
  PwdLoginVm pwdLoginVm = PwdLoginVm();
  Shader shader;
  @override
  Widget build(BuildContext context) {
    const Gradient gradient =
        LinearGradient(colors: [Colors.deepPurpleAccent, Colors.greenAccent]);
    shader = gradient
        .createShader(Rect.fromLTRB(0, 0, setHeight(200), setWidth(100)));
    return ChangeNotifierProvider.value(
      value: pwdLoginVm,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: .0,
        ),
        body: SingleChildScrollView(
          child: Consumer<PwdLoginVm>(builder: (context, vm, _) {
            return Padding(
                padding:
                    EdgeInsets.only(top: setHeight(300), left: 40, right: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          letterSpacing: 2,
                          foreground: Paint()..shader = shader,
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(30),
                    ),
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(left: 10),
                      color: Colors.grey[200],
                      child: TextField(
                        keyboardType: TextInputType.phone,
                        autofocus: false,
                        decoration: InputDecoration(
                          hintText: '手机号',
                          suffixIcon: Icon(
                            CupertinoIcons.person,
                            color: Colors.blue,
                          ),
                          border: InputBorder.none,
                        ),
                        inputFormatters: [
                          WhitelistingTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(11)
                        ],
                        controller: _idController,
                        focusNode: _idFocusNode,
                        onChanged: (value) {
                          vm.username = value;
                        },
                        onEditingComplete: () {
                          Focus.of(context).requestFocus(_pwdFocusNode);
                        },
                      ),
                    ),
                    Container(
                      height: 50,
                      color: Colors.grey[200],
                      padding: EdgeInsets.only(left: 10),
                      margin: EdgeInsets.only(top: setHeight(20)),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '输入密码',
                          suffixIcon: Icon(
                            CupertinoIcons.padlock,
                            color: Colors.blue,
                          ),
                          border: InputBorder.none,
                        ),
                        obscureText: true,
                        controller: _pwdController,
                        focusNode: _pwdFocusNode,
                        onChanged: (value) {
                          vm.password = value;
                        },
                        onEditingComplete: () {
                          _pwdFocusNode.unfocus();
                        },
                      ),
                    ),
                    SizedBox(
                      height: setHeight(20),
                    ),
                    Container(
                      height: 30,
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                              showDialog(context: context,builder: (context){
                                return AlertDialog(
                                  title: Text('忘记密码'),
                                   content: Text('请使用验证码登录后修改密码！'),
                                  actions: <Widget>[
                                    FlatButton(onPressed: (){
                                      Navigator.pop(context);

                                    }, child: Text('OK',style: Theme.of(context).textTheme.button,))
                                  ],
                                );
                              });
                          },
                          child: Text(
                            '忘记密码？',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: setHeight(20),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: InkWell(
                          onTap: vm.permitLogin
                              ? () {
                                  vm.loginProcess = true;
                                  _pwdFocusNode.unfocus();
                                  _idFocusNode.unfocus();
                                  UserService().pwdLogin(data: {
                                    'phone': _idController.text,
                                    'password': _pwdController.text
                                  }).then((val) {
                                    BaseModel model =
                                        BaseModel.fromJson(val.data);
                                    if (model.code == 200) {
                                      var user = UserModel.fromJson(model.data);
                                      UserDataBase()
                                          .insertUser(user, model.token);
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          RouteName.index, (route) => false);
                                    } else {
                                      showToast('手机号/密码错误');
                                      vm.loginProcess = false;
                                    }
                                  }, onError: (e) {
                                    showToast('手机号/密码错误');
                                    vm.loginProcess = false;
                                  });
                                }
                              : null,
                          child: Container(
                              width: double.infinity,
                              color: vm.permitLogin?Colors.blue:Colors.grey,
                              height: 50,
                              alignment: Alignment.center,
                              child: vm.loginProcess
                                  ? CupertinoActivityIndicator()
                                  : Text(
                                      '登录',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 17),
                                    ))),
                    ),
                  ],
                ));
          }),
        ),
      ),
    );
  }
}
