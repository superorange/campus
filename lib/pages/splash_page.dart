import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/app_text/app_text.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>with TickerProviderStateMixin{
  static AnimationController _animationController;
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  @override
  void initState() {
    _animationController = AnimationController(vsync: this);
   _animationController.addListener((){
     if(_animationController.status==AnimationStatus.completed){
       GlobalConfig().initGlobalConfig().then((val){
         if(val){
           Navigator.pushNamedAndRemoveUntil(
               context, RouteName.index, ModalRoute.withName('/'));
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

    super.initState();
  }


  static Widget splashWidget=Material(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 60,),
          Flexible(
            child:  Lottie.asset('assets/animate/splash_lottie.json',
                repeat: false,
                fit: BoxFit.fitWidth,
                width: double.infinity,
                onLoaded: (composition){
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
  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334, allowFontScaling: true)..init(context);
    return splashWidget;
  }
}
