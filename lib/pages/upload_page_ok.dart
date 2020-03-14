import 'package:flutter/material.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';

// ignore: must_be_immutable
class UploadPageOk extends StatefulWidget {
  String gId;
  UploadPageOk(this.gId);
  @override
  _UploadPageOkState createState() => _UploadPageOkState();
}

class _UploadPageOkState extends State<UploadPageOk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('上传成功！'),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: setHeight(300),
          ),
          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/xiaolian.png',
              height: 100,
              width: 100,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, RouteName.tradeInformationPage,
                    arguments: widget.gId);
              },
              color: Colors.yellow,
              child: Container(
                child: Text('看看新上传的宝贝'),
              )),
        ],
      ),
    );
  }
}
