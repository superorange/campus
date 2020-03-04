
import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class DrapPage extends StatefulWidget {
  @override
  _DrapPageState createState() => _DrapPageState();
}

class _DrapPageState extends State<DrapPage> {
  ui.Image image;
  Future<ui.Image> _loadImge() async {
    ImageStream imageStream = AssetImage('assets/images/clipt.jpg').resolve(ImageConfiguration());
    Completer<ui.Image> completer = Completer<ui.Image>();
    void imageListener(ImageInfo info, bool synchronousCall) {
      ui.Image image = info.image;
      completer.complete(image);
      imageStream.removeListener(ImageStreamListener(imageListener));
    }
    imageStream.addListener(ImageStreamListener(imageListener));
    return completer.future;
  }
  double x=0.0;
  double y=0.0;
  @override
  void initState() {
    _loadImge().then((val){
      image=val;
      setState(() {
      });
    });
    super.initState();
  }
  int i=1;
  @override
  Widget build(BuildContext context) {
    var h=MediaQuery.of(context).size.height;
    var w=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: Image.asset('assets/images/clipt.jpg',fit: BoxFit.fill,),
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
              filter: ui.ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(color: Colors.black.withOpacity(0.2))),
         Container(
           width: double.infinity,
           height: double.infinity,
           child:  GestureDetector(
             child: CustomPaint(
               painter: MyPainter(w,h,x,y,image),
             ),
             onPanUpdate: (d){
               print('d.globalPosition.dy${d.globalPosition.dy}');
               if (d.globalPosition.dx >= 200 * 0.5 &&
                   d.globalPosition.dx <= w - 200 * 0.5) {
                 x = d.globalPosition.dx - w * 0.5;
               }
               if (d.globalPosition.dy >= 200 * 0.5 &&
                   d.globalPosition.dy <= h - 200 * 0.5) {
                 y = d.globalPosition.dy - h * 0.5;
               }
               setState(() {
               });
             },
           ),
         ),
        ],
      ),
    );
  }
}


class MyPainter extends CustomPainter{
  MyPainter(this.w,this.h,this.dx,this.dy,this.image);
  double h;
  double w;
  var dx=0.0;
  var dy=0.0;
  ui.Image image;
  static const double scan=200.0;
  @override
  void paint(Canvas canvas, Size size) {
      canvas.clipPath(Path()
      ..moveTo((w-scan)*0.5+dx,(h-scan)*0.5+dy)
        ..lineTo((w + scan) * 0.5 + dx,
            (h - scan) * 0.5 + dy)
        ..lineTo((w + scan) * 0.5 + dx,
            (h + scan) * 0.5 + dy)
        ..lineTo((w - scan) * 0.5 + dx,
            (h + scan) * 0.5 + dy));
      canvas.drawImage(image, ui.Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

}

