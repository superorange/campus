import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/home_page_vm.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/tab_widget.dart';
import 'package:provider/provider.dart';
import '../utils/print_utils.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomePageVm _homePageVm=HomePageVm();
  @override
  void initState() {
    _homePageVm.getSwiperImage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _homePageVm,
      child: Scaffold(
        appBar: AppBar(
          elevation: .0,
          automaticallyImplyLeading: false,
          title: Container(
            width: double.infinity,
            height: setHeight(100),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Icon(CupertinoIcons.location),
                Text(
                  '四川轻化工大学(宜宾校区)',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                ),
                IconButton(icon: Icon(CupertinoIcons.search), onPressed: null),
              ],
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              height: setHeight(250),
              child: Consumer<HomePageVm>(builder: (context, vm, _) {
                return vm.swiperUrl.isEmpty
                    ? Container(
                        child: Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      )
                    : Swiper(
                        pagination: SwiperPagination(alignment: Alignment.bottomCenter),
                        autoplay: true,
                        viewportFraction: 0.8,
                        itemCount: vm.swiperUrl.length,
                        itemBuilder: (context, index) {
                          return vm.swiperUrl.map((f) {
                            return CachedNetworkImage(fit: BoxFit.fill,imageUrl: f.picUrl,placeholder:(context,_) => Center(child: CupertinoActivityIndicator(),),);
                          }).toList()[index];
                        },
                      );
              }),
            ),//250
            SizedBox(height:setHeight(30),), //30
           Card(margin: EdgeInsets.only(left: setWidth(25),right: setWidth(25)),child:
           Container(height: setHeight(125),
             color: Colors.white,
             width: double.infinity,child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
                 TABWidget(t: Icon(Icons.person), b: Text('实验'),),
                 TABWidget(t: Icon(Icons.person), b: Text('实验')),
                 TABWidget(t: Icon(Icons.person), b: Text('实验')),
                 TABWidget(t: Icon(Icons.person), b: Text('实验')),
               ],
             ),),), //125，
            SizedBox(height: setHeight(20),),
            Divider(),
            Padding(padding: EdgeInsets.only(left: setWidth(25)),child:
            Align(alignment: Alignment.centerLeft,child: Text('校园快讯'),),),
            Expanded(child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context,index){
              return Card(child: Container(
                child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: setWidth(500),
                    child:TABWidget(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      t:
                    Container(width: setWidth(500),child: Text('中国成功申办奥运会，兰凯被狗咬伤，lol被拳头取消支持',
                        overflow: TextOverflow.ellipsis,
                    maxLines: 1,style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),),),
                      b: ConstrainedBox(constraints: BoxConstraints(
                        maxHeight: setHeight(100)
                      ),child:Text('zsexdcfgvh除非v更不好对象吃饭v个不回家吃饭天vzsexdcfgvh除非v更不好对象吃饭v个不回家吃饭天vzsexdcfgvh除非v更不好对象吃饭v个不回家吃饭天vzsexdcfgvh除非v更不好对象吃饭v个不回家吃饭天v更好想当初法国v回北京呢除非过v回北京bjnesxdrcftvgbheszxdrcfgvh最新报道，兰凯被狗咬伤',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey
                        ),maxLines: 5,),),
                      crossAxisAlignment: CrossAxisAlignment.start,),
                  ),
                  Container(width: setWidth(150),height: setHeight(150),color: Colors.yellowAccent,),
                ],
              ),height: setHeight(200),),margin: EdgeInsets.only(left: setWidth(25),right: setWidth(25),bottom: setHeight(20)),);
            })),



          ],
        ),
      ),
    );
  }
}
