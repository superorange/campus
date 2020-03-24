import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/api/api.dart';
import 'package:flutter_app/config/app_text/app_text.dart';
import 'package:flutter_app/model/base_model.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/service/goods_service.dart';
import 'package:flutter_app/utils/base_utils.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:oktoast/oktoast.dart';

typedef UploadProgress = void Function(int c, double p);
typedef UploadResult = void Function(Response response);
typedef UploadSize = void Function(int size);

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  bool l1 = false, l2 = false, l3 = false, l4 = false;
  bool c1 = false, c2 = false, c3 = false, c4 = false;
  String schoolLocation = '';
  String category = '';
  TextEditingController _gName = TextEditingController();
  TextEditingController _gDec = TextEditingController();
  TextEditingController _gPri = TextEditingController();
  FocusNode _gNameFocus = FocusNode();
  FocusNode _gDecFocus = FocusNode();
  FocusNode _gPriFocus = FocusNode();
  List<Asset> images = [];
  bool net = true;
  int mainPicIndex = 0;
  List<bool> showMainHint = List.generate(9, (_) => true);
  StreamSubscription _netSubscription;
  ConnectivityResult _connectivityResult;
  void resetMainHint() {
    showMainHint = List.generate(9, (_) => true);
  }

  Widget addWidget() {
    return InkWell(
      onTap: () async {
        var r;
        try {
          r = await MultiImagePicker.pickImages(maxImages: 9 - images.length);
        } catch (e) {
          return;
        }
        images.addAll(r);
        setState(() {});
      },
      child: Container(
        height: setHeight(140),
        width: setWidth(200),
        decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: BorderRadius.circular(7)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              AppText.choosePicture,
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
            ),
            Text(
              AppText.changeMainPic,
              style: TextStyle(color: Colors.black, fontSize: 10),
            ),
          ],
        )),
      ),
    );
  }

  @override
  void initState() {
    showMainHint.first = false;
    _netSubscription = Connectivity().onConnectivityChanged.listen((r) {
      _connectivityResult = r;
    }, cancelOnError: true);
    super.initState();
  }

  @override
  void dispose() {
    if (_gNameFocus.hasFocus) {
      _gNameFocus.unfocus();
    }
    if (_gPriFocus.hasFocus) {
      _gPriFocus.unfocus();
    }
    if (_gDecFocus.hasFocus) {
      _gDecFocus.unfocus();
    }
    _netSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppText.faBu),
        automaticallyImplyLeading: true,
        elevation: .0,
      ),
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _gName,
              focusNode: _gNameFocus,
              maxLines: 1,
              decoration: InputDecoration(hintText: AppText.goodsHint1),
            ),
            TextField(
              controller: _gDec,
              focusNode: _gDecFocus,
              maxLines: 6,
              decoration: InputDecoration(hintText: AppText.goodsHint2),
            ),
            SizedBox(
              height: setHeight(10),
            ),
            Container(
              child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisSpacing: 3, mainAxisSpacing: 3, crossAxisCount: 3),
                itemBuilder: (context, index) {
                  if (images.length == 0) {
                    return addWidget();
                  }
                  if (index == images.length && images.length < 9) {
                    return addWidget();
                  }
                  return Container(
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        GestureDetector(
                          onLongPress: () {
                            mainPicIndex = index;
                            resetMainHint();
                            showMainHint[index] = false;
                            setState(() {});
                          },
                          child: AssetThumb(
                            asset: images[index],
                            width: setWidth(220).round(),
                            height: setHeight(200).round(),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0.9, -1),
                          child: InkWell(
                            onTap: () {
                              mainPicIndex = 0;
                              resetMainHint();
                              showMainHint.first = false;
                              images.removeAt(index);
                              setState(() {});
                            },
                            child: Container(
                              height: 20,
                              width: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: Colors.yellowAccent.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(36)),
                              child: Text('X'),
                            ),
                          ),
                        ),
                        Offstage(
                          offstage: showMainHint[index],
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[300].withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(3)),
                              child: Text(
                                AppText.mainPic,
                                style: TextStyle(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemCount:
                    images.length < 9 ? images.length + 1 : images.length,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              AppText.location,
              style: TextStyle(
                  color: (c2 || c3 || c4 || c1)
                      ? Colors.blueAccent
                      : Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 10, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        c2 = c3 = c4 = false;
                        c1 = !c1;
                        if (c1) {
                          schoolLocation = AppText.yiBin;
                        }

                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: c1 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.yiBin,
                          style: TextStyle(
                              color: c1 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        c1 = c3 = c4 = false;
                        c2 = !c2;
                        if (c2) {
                          schoolLocation = AppText.huiNan;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: c2 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.huiNan,
                          style: TextStyle(
                              color: c2 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        c2 = c1 = c4 = false;
                        c3 = !c3;
                        if (c3) {
                          schoolLocation = AppText.yinPan;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: c3 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.yinPan,
                          style: TextStyle(
                              color: c3 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        c2 = c3 = c1 = false;
                        c4 = !c4;
                        if (c4) {
                          schoolLocation = AppText.qiTaLocation;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: c4 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.qiTaLocation,
                          style: TextStyle(
                              color: c4 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Text(
              AppText.category,
              style: TextStyle(
                  color: (l2 || l3 || l4 || l1)
                      ? Colors.blueAccent
                      : Colors.black54,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
            Container(
              height: 40,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        l2 = l3 = l4 = false;
                        l1 = !l1;
                        if (l1) {
                          category = AppText.shuMa;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: l1 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.shuMa,
                          style: TextStyle(
                              color: l1 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        l1 = l3 = l4 = false;
                        l2 = !l2;
                        if (l2) {
                          category = AppText.kaoYan;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: l2 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.kaoYan,
                          style: TextStyle(
                              color: l2 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        l2 = l1 = l4 = false;
                        l3 = !l3;
                        if (l3) {
                          category = AppText.shuJi;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: l3 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.shuJi,
                          style: TextStyle(
                              color: l3 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                  Flexible(
                    child: InkWell(
                      onTap: () {
                        l2 = l3 = l1 = false;
                        l4 = !l4;
                        if (l4) {
                          category = AppText.qiTaCategory;
                        }
                        setState(() {});
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: l4 ? Colors.blueAccent : Colors.black54,
                            borderRadius: BorderRadius.circular(7)),
                        width: double.infinity,
                        height: double.infinity,
                        child: Text(
                          AppText.qiTaCategory,
                          style: TextStyle(
                              color: l4 ? Colors.white : Colors.grey[300]),
                        ),
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  AppText.goodsPrice,
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                Container(
                  width: setWidth(300),
                  child: TextField(
                      keyboardType: TextInputType.phone,
                      controller: _gPri,
                      focusNode: _gPriFocus,
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                      decoration: InputDecoration(
                          hintText: '¥: 9.99', border: InputBorder.none)),
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7)),
              onPressed: () async {
                var _price;
                if (!(l1 || l2 || l3 || l4)) {
                  showToast(AppText.chooseCategory, position: ToastPosition.bottom);
                  return;
                }
                if (!(c1 || c2 || c3 || c4)) {
                  showToast(AppText.chooseLocation, position: ToastPosition.bottom);
                  return;
                }
                try {
                  _price = double.parse(_gPri.text).floor();
                } catch (e) {
                  showToast(AppText.priceError, position: ToastPosition.bottom);
                  return;
                }
                if (_gName.text.length <= 2 || _gDec.text.length <= 10) {
                  showToast(AppText.tooSmallText, position: ToastPosition.bottom);
                  return;
                }
                if (images.length == 0) {
                  showToast(AppText.tooSmallPic);
                  return;
                }
                if (_connectivityResult == ConnectivityResult.none) {
                  showToast(AppText.netError1);
                  return;
                }
                print(_connectivityResult);
                if (_connectivityResult != ConnectivityResult.mobile) {
                  showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(AppText.hint),
                          content: Text(AppText.mobile),
                          actions: <Widget>[
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(AppText.cancle)),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (context) {
                                        int onlyOne = 0;
                                        int totalSize = 0;
                                        bool isGetToken = false;
                                        bool isJiMi = false;
                                        int currentIndex = 1;
                                        double currentProgress = 0.1;
                                        List<String> imagesList = [];
                                        return StatefulBuilder(
                                          builder: (context, newSet) {
                                            if (onlyOne == 0) {
                                              GoodsService()
                                                  .getImageToken()
                                                  .then((val) async {
                                                BaseModel model =
                                                    BaseModel.fromJson(
                                                        val.data);
                                                if (model.code == 200) {
                                                  isGetToken = true;
                                                  if (mounted) {
                                                    newSet(() {});
                                                  }
                                                  var ak = await JiaMi.jm(
                                                      model.token);
                                                  isJiMi = true;
                                                  if (mounted) {
                                                    newSet(() {});
                                                  }
                                                  QiNiu().uploadImages(images,
                                                      '$ak:${model.msg}',
                                                      uploadResult: (t) async {
                                                    imagesList
                                                        .add(t.data['hash']);
                                                    if (imagesList.length ==
                                                        images.length) {
                                                      var data = {
                                                        "gPrice": _price,
                                                        "gName": _gName.text,
                                                        "gDec": _gDec.text,
                                                        "gImages": imagesList,
                                                        "gStar": 0,
                                                        "schoolLocation":
                                                            schoolLocation,
                                                        "category": category,
                                                        "mainPic": imagesList[
                                                            mainPicIndex]
                                                      };
                                                      var result =
                                                          await GoodsService()
                                                              .addGood(data);
                                                      if (result.data['code'] ==
                                                          200) {
                                                        Navigator.pop(context);
                                                        Navigator.pushReplacementNamed(
                                                            context,
                                                            RouteName
                                                                .uploadPageOk,
                                                            arguments: result
                                                                    .data[
                                                                'data']['gId']);
                                                      } else {
                                                        showToast('上传失败');
                                                        Navigator.pop(context);
                                                      }
                                                    }
                                                  }, uploadProgress: (c, t) {
                                                    currentIndex = c;
                                                    currentProgress = t;
                                                    if (mounted) {
                                                      newSet(() {});
                                                    }
                                                  }, uploadSize: (c) {
                                                    totalSize += c;
                                                    if (mounted) {
                                                      newSet(() {});
                                                    }
                                                  });
                                                }
                                              }, onError: (e) {});
                                              onlyOne++;
                                            }
                                            return Material(
                                              type: MaterialType.transparency,
                                              child: Center(
                                                child: Container(
                                                  height: setHeight(550),
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  margin: EdgeInsets.only(
                                                    left: 30,
                                                    right: 30,
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      top: setHeight(30),
                                                      left: 20,
                                                      right: 20),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Container(
                                                        alignment:
                                                            Alignment.center,
                                                        width: double.infinity,
                                                        margin: EdgeInsets.only(
                                                            bottom: 10),
                                                        child: Text(
                                                          '开始上传图片',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 24),
                                                        ),
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              AppText.getToken,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            isGetToken
                                                                ? Text(
                                                                    AppText.getSuccess,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .greenAccent,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : CupertinoActivityIndicator()
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              AppText.tokenDecryption,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontSize: 15,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            isJiMi
                                                                ? Text(
                                                                    AppText.decryptionSuccess,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .greenAccent,
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  )
                                                                : CupertinoActivityIndicator()
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        alignment: Alignment
                                                            .centerLeft,
                                                        child: Text.rich(
                                                            TextSpan(children: [
                                                          TextSpan(
                                                            text: AppText.picCount,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          TextSpan(
                                                              text: images
                                                                  .length
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent,
                                                                  fontSize:
                                                                      17)),
                                                          TextSpan(
                                                            text: AppText.totalCount,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500),
                                                          ),
                                                          TextSpan(
                                                              text: totalSize ==
                                                                      0
                                                                  ? AppText.jiSuan
                                                                  : '${(totalSize / 1024 / 1024).toString().substring(0, 6)}Mb',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blueAccent)),
                                                        ])),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Container(
                                                        height: setHeight(190),
                                                        child: AnimatedSwitcher(
                                                          duration: Duration(
                                                              milliseconds:
                                                                  100),
                                                          child: totalSize == 0
                                                              ? Center(
                                                                  key: ValueKey(
                                                                      '2'),
                                                                  child:
                                                                      CupertinoActivityIndicator(),
                                                                )
                                                              : Column(
                                                                  key: ValueKey(
                                                                      '1'),
                                                                  children: <
                                                                      Widget>[
                                                                    Container(
                                                                      child:
                                                                          Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: <
                                                                            Widget>[
                                                                          Text.rich(
                                                                              TextSpan(children: [
                                                                            TextSpan(
                                                                              text: AppText.uploadHint1,
                                                                              style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            TextSpan(
                                                                              text: '$currentIndex',
                                                                              style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            TextSpan(
                                                                              text: AppText.uploadHint2,
                                                                              style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ])),
                                                                          Text.rich(
                                                                              TextSpan(children: [
                                                                            TextSpan(
                                                                              text: AppText.uploadHint3,
                                                                              style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            TextSpan(
                                                                              text: '${images.length - currentIndex}',
                                                                              style: TextStyle(color: Colors.blueAccent, fontSize: 15, fontWeight: FontWeight.w500),
                                                                            ),
                                                                            TextSpan(
                                                                              text: AppText.uploadHint2,
                                                                              style: TextStyle(color: Colors.black54, fontSize: 15, fontWeight: FontWeight.w500),
                                                                            ),
                                                                          ])),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                    Stack(
                                                                      children: <
                                                                          Widget>[
                                                                        Align(
                                                                            alignment:
                                                                                Alignment.center,
                                                                            child: Container(
                                                                              height: 50,
                                                                              width: 50,
                                                                              child: CircularProgressIndicator(
                                                                                value: currentProgress,
                                                                                backgroundColor: Colors.black,
                                                                              ),
                                                                            )),
                                                                        Align(
                                                                          alignment:
                                                                              Alignment.center,
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                50,
                                                                            width:
                                                                                50,
                                                                            child:
                                                                                Align(
                                                                              alignment: Alignment.center,
                                                                              child: Text('${(currentProgress * 100).toDouble().toString().substring(0, 3)}%'),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                        ),
                                                      ),
                                                      Align(
                                                        alignment: Alignment
                                                            .bottomRight,
                                                        child: InkWell(
                                                          onTap: () {
                                                            dismissAllToast();
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (ctx2) {
                                                                  return CupertinoAlertDialog(
                                                                    title: Text(
                                                                        AppText.hint),
                                                                    content: Text(
                                                                        AppText.uploadPause),
                                                                    actions: <
                                                                        Widget>[
                                                                      FlatButton(
                                                                          onPressed:
                                                                              () {
                                                                            Navigator.pop(ctx2);
                                                                          },
                                                                          child:
                                                                              Text(AppText.no)),
                                                                      FlatButton(
                                                                          onPressed:
                                                                              () {
                                                                            QiNiu().uploadCancel();
                                                                            dismissAllToast();
                                                                            Navigator.pop(ctx2);
                                                                            Navigator.pop(context);
                                                                          },
                                                                          child:
                                                                              Text(AppText.yes))
                                                                    ],
                                                                  );
                                                                });
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          child: Container(
                                                            width:
                                                                setWidth(120),
                                                            height:
                                                                setHeight(50),
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              AppText.cancle,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          7),
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      });
                                },
                                child: Text(AppText.jiXu))
                          ],
                        );
                      });
                }
                if (_connectivityResult == ConnectivityResult.wifi) {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        int onlyOne = 0;
                        int totalSize = 0;
                        bool isGetToken = false;
                        bool isJiMi = false;
                        int currentIndex = 1;
                        double currentProgress = 0.1;
                        List<String> imagesList = [];

                        return StatefulBuilder(
                          builder: (context, newSet) {
                            if (onlyOne == 0) {
                              GoodsService().getImageToken().then((val) async {
                                BaseModel model = BaseModel.fromJson(val.data);
                                if (model.code == 200) {
                                  isGetToken = true;
                                  if (mounted) {
                                    newSet(() {});
                                  }
                                  var ak = await JiaMi.jm(model.token);
                                  isJiMi = true;
                                  if (mounted) {
                                    newSet(() {});
                                  }
                                  QiNiu()
                                      .uploadImages(images, '$ak:${model.msg}',
                                          uploadResult: (t) async {
                                    imagesList.add(t.data['hash']);
                                    if (imagesList.length == images.length) {
                                      var data = {
                                        "gPrice": _price,
                                        "gName": _gName.text,
                                        "gDec": _gDec.text,
                                        "gImages": imagesList,
                                        "gStar": 0,
                                        "schoolLocation": schoolLocation,
                                        "category": category,
                                        "mainPic": imagesList[mainPicIndex]
                                      };
                                      var result =
                                          await GoodsService().addGood(data);
                                      print(':${result.data}');
                                      if (result.data['code'] == 200) {
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(
                                            context, RouteName.uploadPageOk,
                                            arguments: result.data['data']
                                                ['gId']);
                                      } else {
                                        showToast(AppText.uploadFailed);
                                        Navigator.pop(context);
                                      }
                                    }
                                  }, uploadProgress: (c, t) {
                                    currentIndex = c;
                                    currentProgress = t;
                                    if (mounted) {
                                      newSet(() {});
                                    }
                                  }, uploadSize: (c) {
                                    totalSize += c;
                                    if (mounted) {
                                      newSet(() {});
                                    }
                                  });
                                }
                              }, onError: (e) {});
                              onlyOne++;
                            }
                            return Material(
                              type: MaterialType.transparency,
                              child: Center(
                                child: Container(
                                  height: setHeight(550),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15)),
                                  margin: EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                  ),
                                  padding: EdgeInsets.only(
                                      top: setHeight(30), left: 20, right: 20),
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        margin: EdgeInsets.only(bottom: 10),
                                        child: Text(
                                          AppText.startUpload,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 24),
                                        ),
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppText.getToken,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            isGetToken
                                                ? Text(
                                                    AppText.getSuccess,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.greenAccent,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : CupertinoActivityIndicator()
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              AppText.tokenDecryption,
                                              style: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            isJiMi
                                                ? Text(
                                                    AppText.decryptionSuccess,
                                                    style: TextStyle(
                                                        color:
                                                            Colors.greenAccent,
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  )
                                                : CupertinoActivityIndicator()
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Text.rich(TextSpan(children: [
                                          TextSpan(
                                            text: AppText.picCount,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                              text: images.length.toString(),
                                              style: TextStyle(
                                                  color: Colors.blueAccent,
                                                  fontSize: 17)),
                                          TextSpan(
                                            text: AppText.totalCount,
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          TextSpan(
                                              text: totalSize == 0
                                                  ? AppText.jiSuan
                                                  : '${(totalSize / 1024 / 1024).toString().substring(0, 6)}Mb',
                                              style: TextStyle(
                                                  color: Colors.blueAccent)),
                                        ])),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Container(
                                        height: setHeight(190),
                                        child: AnimatedSwitcher(
                                          duration: Duration(milliseconds: 100),
                                          child: totalSize == 0
                                              ? Center(
                                                  key: ValueKey('2'),
                                                  child:
                                                      CupertinoActivityIndicator(),
                                                )
                                              : Column(
                                                  key: ValueKey('1'),
                                                  children: <Widget>[
                                                    Container(
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Text.rich(TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text:AppText.uploadHint1,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '$currentIndex',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                TextSpan(
                                                                  text: AppText.uploadHint2,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ])),
                                                          Text.rich(TextSpan(
                                                              children: [
                                                                TextSpan(
                                                                  text: AppText.uploadHint3,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                TextSpan(
                                                                  text:
                                                                      '${images.length - currentIndex}',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .blueAccent,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                                TextSpan(
                                                                  text: AppText.uploadHint2,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black54,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                                ),
                                                              ])),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Stack(
                                                      children: <Widget>[
                                                        Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Container(
                                                              height: 50,
                                                              width: 50,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                value:
                                                                    currentProgress,
                                                                backgroundColor:
                                                                    Colors
                                                                        .black,
                                                              ),
                                                            )),
                                                        Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            child: Align(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child: Text(
                                                                  '${(currentProgress * 100).toDouble().toString().substring(0, 3)}%'),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: InkWell(
                                          onTap: () {
                                            dismissAllToast();
                                            showDialog(
                                                context: context,
                                                builder: (ctx2) {
                                                  return CupertinoAlertDialog(
                                                    title: Text(AppText.hint),
                                                    content: Text(AppText.uploadPause),
                                                    actions: <Widget>[
                                                      FlatButton(
                                                          onPressed: () {
                                                            Navigator.pop(ctx2);
                                                          },
                                                          child: Text(AppText.no)),
                                                      FlatButton(
                                                          onPressed: () {
                                                            QiNiu()
                                                                .uploadCancel();
                                                            dismissAllToast();
                                                            Navigator.pop(ctx2);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text(AppText.yes))
                                                    ],
                                                  );
                                                });
                                          },
                                          borderRadius:
                                              BorderRadius.circular(7),
                                          child: Container(
                                            width: setWidth(120),
                                            height: setHeight(50),
                                            alignment: Alignment.center,
                                            child: Text(
                                              AppText.cancle,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(7),
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      });
                }
              },
              child: Container(
                width: double.infinity,
                height: 50,
                child: Text(
                  AppText.submit,
                  style: TextStyle(
                      letterSpacing: 10,
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                alignment: Alignment.center,
              ),
              color: Colors.blueAccent,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      )),
    );
  }
}

class QiNiu {
  static Dio dio = Dio(BaseOptions(contentType: 'multipart/form-data'));

  uploadImages(List<Asset> images, String token,
      {UploadProgress uploadProgress,
      UploadResult uploadResult,
      UploadSize uploadSize}) async {
    List<FormData> dataList = [];
    images.forEach((image) async {
      var name = image.name;
      var byte = await image.getByteData();
      uploadSize(byte.buffer.lengthInBytes);
      dataList.add(FormData.fromMap({
        'token': token,
        'fileName': name,
        'file': MultipartFile.fromBytes(byte.buffer.asUint8List()),
      }));
      if (dataList.length == images.length) {
        int i = 0;
        Future run() async {
          if (i < dataList.length) {
            return await dio.post(Api.qiNiu, data: dataList[i],
                onSendProgress: (c, t) {
              uploadProgress(i + 1, c / t);
            }).then((val) {
              uploadResult(val);
              i++;
              run();
            }, onError: (e) {
              showToast(AppText.uploadFailed,
                  duration: Duration(seconds: 6),
                  position: ToastPosition.bottom);
            });
          } else {
            return;
          }
        }

        run();
      }
    });
  }

  Future<String> uploadImage(Asset image, String token) async {
    var byte = await image.getByteData();
    FormData data = FormData.fromMap({
      'token': token,
      'fileName': image.name,
      'file': MultipartFile.fromBytes(byte.buffer.asUint8List()),
    });
    var result = await dio.post(Api.qiNiu, data: data).catchError((e) {
      return null;
    });
    return result?.data['hash'];
  }

  uploadCancel() {
    dio.close(force: true);
  }
}
