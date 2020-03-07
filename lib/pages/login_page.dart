import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/pages/vm/pwd_login_vm.dart';
import 'package:flutter_app/pages/vm/sms_login_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/service/login_service.dart';
import 'package:flutter_app/utils/reg.dart';
import 'package:flutter_app/utils/login_auth.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/loading_widget.dart';
import 'package:jverify/jverify.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin{
  AnimationController _animationController;
  //logo动画
  Animation<double> _animation1;
  CurvedAnimation _curvedAnimation1;
  Jverify jverify = Jverify();
  void fastLogin(BuildContext loginCtx)async{
    Jverify jverify = new Jverify();
    try {
      jverify.setup(
          appKey: "477d2dad7d19abe2ae0b42f6",
          channel: "devloper-default"
      );
    } catch (e) {
      print('极光初始化失败：$e');
    } // 初始化sdk,  appKey 和 channel 只对ios设置有效
    LoginAuth().init();
    jverify.setDebugMode(true);
    var init=await jverify.isInitSuccess();
    var net=await jverify.checkVerifyEnable();
    var preLogin=await jverify.preLogin();
    print('${preLogin}');
    if(init['result']&&net['result']&&preLogin['code']==7000){
      Navigator.pop(loginCtx);
      jverify.loginAuth(false).then((code){
        if(code['code']==6000){
          //登录成功
          var token=code['message'];
          print('toekn:$token');
          jverify.dismissLoginAuthView();
//          showDialog(context: context,builder: (ctx){
//            return AlertDialog(
//              content: Container(
//                width: 100,
//                alignment: Alignment.center,
//                height: 100,
//                child: CircularProgressIndicator(),
//              ),
//            );
//          });
        Navigator.pushNamedAndRemoveUntil(context, RouteName.index, ModalRoute.withName('/index'));
        }
        else if(code['code']==6002){
          jverify.dismissLoginAuthView();
          showToast('登录取消',position: ToastPosition.bottom);
        }
        else{
          jverify.dismissLoginAuthView();
          showToast('登录失败',position: ToastPosition.bottom);
        }

      });
    }
    else{
      Navigator.pop(loginCtx);
      showToast('你的环境不支持一键登录',position: ToastPosition.bottom);
    }
  }
  @override
  initState() {
    _animationController=AnimationController(vsync: this,duration: Duration(seconds: 3));
    _curvedAnimation1=CurvedAnimation(parent: _animationController, curve:  Curves.fastOutSlowIn);
    _animation1=Tween<double>(begin:-350,end:0.0).animate(_curvedAnimation1);
    _animationController.forward();
    super.initState();

  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }
  Shader shader;
  @override

  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      body:MediaQuery.removePadding(context: context,
          removeTop: true,
          removeBottom: true,
          child: SafeArea(child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: setHeight(150),),
              AnimatedBuilder(animation:_animation1, builder: (context,_)=>Transform.translate(offset:Offset(0, _animation1.value) ,child: Container(
                height: setHeight(250),
                width: setHeight(250),
                child: CircleAvatar(
                  foregroundColor: Colors.blueAccent,
                  backgroundImage: AssetImage('assets/images/logo.png'),
                ),
              ),),),
              SizedBox(height: setHeight(30),),
              Container(
                padding: EdgeInsets.only(left: 40,right: 40),
                alignment: Alignment.center,
                child: chooseLoginPanel(),
              ),
              SizedBox(height: setHeight(70),),
              CupertinoButton(child: Text('跳过登录',style: TextStyle(
                  color: Colors.black
              ),), onPressed: (){
                Navigator.pushNamed(context, RouteName.index);
              })
            ],
          )
          )
      ),
    ), onWillPop: ()async{
      return false;
    });
  }


  Widget chooseLoginPanel(){
    return Container(
      height: setHeight(500),
      margin: EdgeInsets.only(top: setHeight(200)),
      child: Column(
        children: <Widget>[
          FlatButton(onPressed: ()async{
            showDialog(context: context,barrierDismissible: false,builder: (ctx){
              fastLogin(ctx);
              return LoadingWidget(ctx);
            });
          }, child: Container(
            width: double.infinity,
            height: setHeight(70),
            padding: EdgeInsets.only(left: 10,right: 10),
            alignment: Alignment.center,
            child: Text('本机号码一键登录',style: TextStyle(
              color: Colors.white
            ),),
          ),color: Colors.blue,materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
          SizedBox(height: setHeight(40),),
          FlatButton(onPressed: (){
            Navigator.pushNamed(context, RouteName.smsLogin);
          }, child: Container(
            width: double.infinity,
            height: setHeight(70),
            padding: EdgeInsets.only(left: 10,right: 10),
            alignment: Alignment.center,
            child: Text('短信验证码登录',style: TextStyle(
                color: Colors.white
            ),),
          ),color: Colors.blue,materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
          SizedBox(height: setHeight(40),),
          FlatButton(onPressed: (){
            Navigator.pushNamed(context, RouteName.pwdLogin);
          }, child: Container(
            width: double.infinity,
            height: setHeight(70),
            padding: EdgeInsets.only(left: 10,right: 10),
            alignment: Alignment.center,
            child: Text('账号密码登录',style: TextStyle(
                color: Colors.white
            ),),
          ),color: Colors.blue,materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,),
        ],
      ),
    );
  }
}



class SmsLogin extends StatefulWidget {
  @override
  _SmsLoginState createState() => _SmsLoginState();
}

class _SmsLoginState extends State<SmsLogin> with TickerProviderStateMixin{
  TextEditingController _phoneController=TextEditingController();
  TextEditingController _codeController=TextEditingController();
  FocusNode phoneFocusNode=FocusNode();
  FocusNode codeFocusNode=FocusNode();
  SmsLoginVm smsLoginVm=SmsLoginVm();
  AnimationController _animationController;
  @override
  void initState() {
    _animationController=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
  }
  @override
  void dispose() {
    _phoneController.dispose();
    _codeController.dispose();
    phoneFocusNode.dispose();
    codeFocusNode.dispose();
    smsLoginVm.dispose();
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(value: smsLoginVm,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          elevation: .0,
        ),
        body: SafeArea(child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: <Widget>[
              SizedBox(height: setHeight(200),),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                height: setHeight(70),
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    Expanded(child: Consumer<SmsLoginVm>(builder: (context,vm,_){
                      return Container(
                        padding: EdgeInsets.only(left: 20),
                        child: TextField(
                          focusNode: phoneFocusNode,
                          inputFormatters: [
                            WhitelistingTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(11)
                          ],
                          controller: _phoneController,
                          onChanged: (s){
                            if(s.length==11){
                              vm.changeCanClick(true);
                            }
                            else{
                              vm.changeCanClick(false);
                            }
                          },
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: '输入号码',
                            border: InputBorder.none,

                          ),
                        ),
                      );
                    })),
                    Consumer<SmsLoginVm>(builder: (context,vm,_){
                      return Container(width: setWidth(200),
                        color: (!vm.sendSms&&vm.canClick)?Colors.blueAccent:Colors.grey[400],
                        child: FlatButton(
                            onPressed:(!vm.sendSms&&vm.canClick)? (){
                              if(Reg.isChinaPhoneLegal(_phoneController.value.text)){
                                showDialog(context: context,builder: (ctx){
                                  var data={
                                    "type": "sms",
                                    "phone": _phoneController.value.text,
                                    "smsCode": "123456",
                                    "lastLogin": false
                                  };
                                  LoginService().startLogin(data: data).then((val){
                                    if(val.data['code']==200){
                                      showToast('短信发送成功');
                                      Navigator.pop(ctx);
                                      vm.changeSendSms(true);
                                      if(mounted){
                                        FocusScope.of(context).requestFocus(codeFocusNode);
                                      }
                                    }
                                    else{
                                      Navigator.pop(ctx);
                                      showToast('短信发送失败');
                                    }
                                  },onError: (e){
                                    Navigator.pop(ctx);
                                    showToast('短信发送失败');
                                  });

                                  return AlertDialog(
                                    title: CupertinoActivityIndicator(),
                                  );
                                });
                              }
                              else{
                                showToast('号码格式不正确！');
                              }

                        }:null, child: Text(vm.sendSms?'${vm.time} S':'获取验证码',style: TextStyle(
                          color: vm.sendSms?Colors.blue:Colors.white,
                        ),)),);
                    }),
                  ],
                ),
              ),
              SizedBox(height: setHeight(30),),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                height: setHeight(70),
                color: Colors.grey[300],
                child: Consumer<SmsLoginVm>(builder: (context,vm,_){
                  return Container(
                    padding: EdgeInsets.only(left: 20),
                    child: TextField(
                      focusNode: codeFocusNode,
                      readOnly: vm.sendSms?false:true,
                      onChanged: (s){
                        if(s.length==6){
                          codeFocusNode.unfocus();
                          vm.changeCanLogin(true);
                        }
                        else{
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
                    ),
                  );
                },),
              ),
              SizedBox(height: setHeight(30),),
              Consumer<SmsLoginVm>(builder: (context,vm,_){
                return GestureDetector(
                  onPanUpdate: vm.canLogin? (d){
                    vm.changeAnimationControl(false);
                    if(d.localPosition.dx>=60){
                      vm.changeWidth(d.localPosition.dx);
                    }
                  }:null,
                  onPanEnd:  vm.canLogin?(d){
                    if(vm.width>=300){
                      vm..changeWidth(395,listen: false)..changeStartLogin(true);
                      var data={
                        "type": "sms",
                        "phone": _phoneController.value.text,
                        "smsCode": _codeController.value.text,
                        "lastLogin": true
                      };
                      LoginService().startLogin(data: data).then((val){

                        BaseModel model=BaseModel.fromJson(val.data);
                        if(model.code==200){
//                          LoginAuth().saveToken(model.token);
                          Api.token=model.token;
                          Api.userId=val.data['data']['userId'];
                          Navigator.pushNamedAndRemoveUntil(context, RouteName.index, ModalRoute.withName('/'));
                        }
                        else{
                          showToast('登录失败');
                          vm.changeAnimationControl(false);
                          vm..changeWidth(60)..changeStartLogin(false);
                        }
                      },onError: (e){
                        showToast('登录失败');
                        vm.changeAnimationControl(false);
                        vm..changeWidth(60)..changeStartLogin(false);
                      });



                    }
                    else if(vm.width>60&&vm.width<300){
                      vm
                    ..setWidth(vm.width)
                    ..changeAnimationControl(true);
                      _animationController.reverse(from: 1);
                    }

                  }:null,

                  child: Container(
                    height: setHeight(70),
                    margin: EdgeInsets.only(left: 20,right: 20),
                    color: vm.startLogin?Colors.blueAccent:Colors.grey[400],
                    width: double.infinity,
                    child:AnimatedSwitcher(
                      duration: Duration(seconds: 1),
                      child: vm.startLogin?CupertinoActivityIndicator(key: ValueKey(vm.startLogin),):Stack(
                        key: ValueKey(vm.startLogin),
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            child: Text('按压拖动登录'),
                          ),
                          AnimatedBuilder(animation: _animationController, builder: (context,_){
                            return Container(
                              color: Colors.blueAccent,
                              width:vm.animationControl?60+_animationController.value*(vm.lastWidth-60):vm.width,
                              alignment: Alignment.centerRight,
                              child: Text('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>',maxLines: 1,overflow: TextOverflow.clip,),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        )),
      ),);
  }
}

// ignore: must_be_immutable
class PwdLogin extends StatelessWidget {
  TextEditingController _idController=TextEditingController();
  TextEditingController _pwdController=TextEditingController();
  FocusNode _idFocusNode=FocusNode();
  FocusNode _pwdFocusNode=FocusNode();
  PwdLoginVm pwdLoginVm=PwdLoginVm();
  Shader shader;
  @override
  Widget build(BuildContext context) {
    Gradient gradient=LinearGradient(colors: [Colors.deepPurpleAccent,Colors.greenAccent]);
    shader=gradient.createShader(Rect.fromLTRB(0, 0, setHeight(200), setWidth(100)));
    return ChangeNotifierProvider.value(value: pwdLoginVm,
    child:Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        elevation: .0,
      ),
      body:  Consumer<PwdLoginVm>(builder: (context,vm,_){
        return Padding(padding: EdgeInsets.only(
          top: setHeight(300),
          left: 40,
          right: 40
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(height: setHeight(100),width:setWidth(200),child: Text('Login',style: TextStyle(
              foreground: Paint()..shader=shader,
              fontSize: 38,
              fontWeight: FontWeight.bold,
            ),
            ),),
            Container(height: setHeight(80),child: TextField(
              decoration: InputDecoration(
                hintText: '手机号',
                suffixIcon: Icon(CupertinoIcons.person),
              ),
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11)
              ],
              controller: _idController,
              focusNode: _idFocusNode,
              onChanged: (value){
                vm.username=value;
              },
              onEditingComplete: (){
                Focus.of(context).requestFocus(_pwdFocusNode);
              },
            ),),
            Container(height: setHeight(80),margin: EdgeInsets.only(top: setHeight(20)),child: TextField(
              decoration: InputDecoration(
                hintText: '输入密码',
                suffixIcon: Icon(CupertinoIcons.padlock),
              ),
              obscureText: true,
              controller: _pwdController,
              focusNode: _pwdFocusNode,
              onChanged: (value){
                vm.password=value;
              },
              onEditingComplete: (){
                _pwdFocusNode.unfocus();
              },
            ),),
            Container(height: setHeight(40),margin:EdgeInsets.only(top: 10),child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: (){

                },
                child: Text('Forgot Password?'),
              ),
            ),),
            SizedBox(height: setHeight(40),),
            Align(
              alignment: Alignment.center,
              child: InkWell(
                onTap: vm.permitLogin?(){
                  vm.loginProcess=true;
                  _pwdFocusNode.unfocus();
                  _idFocusNode.unfocus();
                  LoginService().startLogin(data: vm.getData()).then((val){
                    print('data:${vm.getData()}');
                    BaseModel model=BaseModel.fromJson(val.data);
                    if(model.code==200){
                      LoginAuth().saveToken(model.token);
                      Navigator.pushNamedAndRemoveUntil(context, RouteName.index, ModalRoute.withName('/'));
                    }
                    else{
                      showToast('手机号/密码错误');
                      vm.loginProcess=false;
                    }
                  },onError: (e){
                    showToast('手机号/密码错误');
                    vm.loginProcess=false;
                  });

                }:null,
                child: Container(
                    height: setHeight(70),
                    width: setWidth(400),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: vm.permitLogin?Colors.blueAccent:Colors.grey[300],
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: vm.loginProcess?CupertinoActivityIndicator():Text('Login/Registe',style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 17
                    ),
                    )),
              ),
            ),
          ],
        ));
      }),
    ),);
  }
}














