import 'package:flutter/material.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/global_config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:oktoast/oktoast.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
  @override
  void initState() {
    GlobalConfig().initGlobalConfig().then((val){
      if(val){
        Future.delayed(Duration(milliseconds: 3500)).then((_) {
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.index, ModalRoute.withName('/'));
        });
      }
      else{
        showToast('Sorry,this app can\'t run in this device');
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
                alignment: Alignment.center),
            flex: 2,
            fit: FlexFit.tight,
          ),
          Text('闲货直通车',style: TextStyle(
              color: Colors.brown,
              fontSize: 35,
              fontWeight: FontWeight.bold,
              letterSpacing: 3
          ),),
          Flexible(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text('Copyright© 2020 FLUTTER',style: TextStyle(
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
