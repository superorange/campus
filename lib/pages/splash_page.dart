import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/config/app_text/app_text.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>with TickerProviderStateMixin{
    AnimationController _animationController;
    Uint8List data;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {

   try {
     start();
   } catch (e) {
     print(e);
   }

    super.initState();
  }
start()async{
  var byteData =await rootBundle.load('assets/animate/splash_lottie.json');
  data=byteData.buffer.asUint8List();
  _animationController = AnimationController(vsync: this);
  _animationController.addListener((){
    if(_animationController.status==AnimationStatus.completed){
      GlobalConfig().initGlobalConfig().then((val){
        if(val){
          print('Api.token:${Api.token}');

          if(Api.token.isEmpty){
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.login, ModalRoute.withName('/'));

          }
          else{
            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.index, ModalRoute.withName('/'));
          }
        }
        else{
          showToast(AppText.appError,duration: Duration(seconds: 5));
          Future.delayed(const Duration( seconds: 5)).then((_){
              exit(0);
           });
        }

      });
    }
  });
  if(mounted){
    setState(() {

    });
    return;
  }
  Future.microtask((){
    setState(() {
    });
  });
}


  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return Material(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60,),
            Flexible(
              child:  data==null?CupertinoActivityIndicator(key: ValueKey('1'),):LottieBuilder.memory(
                  data,
                  repeat: false,
                  key: ValueKey('2'),
                  fit: BoxFit.fitWidth,
                  width: double.infinity,
                  onLoaded: (composition)async{
                    _animationController
                      ..duration = composition.duration
                      ..forward();
                  },
                  alignment: Alignment.center),
              flex: 2,
              fit: FlexFit.tight,

            ),
            Text(AppText.appName,style: TextStyle(
                color: Colors.brown,
                fontSize: 35,
                fontWeight: FontWeight.bold,
                letterSpacing: 3
            ),),
            Flexible(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text(AppText.appCopyright,style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.w400
                ),),
              ),
              flex: 1,
              fit: FlexFit.tight,
            ),
            SizedBox(height: 50,),
          ],
        ));
  }
}
