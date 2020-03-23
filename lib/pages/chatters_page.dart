import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_app/widget/image_error.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class ChattersPage extends StatefulWidget {
  @override
  _ChattersPageState createState() => _ChattersPageState();
}

class _ChattersPageState extends State<ChattersPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('聊天'),
        elevation: .0,
        centerTitle: true,
      ),
      body: Consumer<ChatChattersPageVm>(builder: (context, vm, _) {
        return EasyRefresh(
            onRefresh: () async {
              vm.loading();
            },
            child: ListView.separated(
              addAutomaticKeepAlives: true,
              controller: scrollController,
              itemCount: vm.chatters.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, RouteName.chatPage,
                        arguments: {
                          'toId': vm.chatters[index].userId,
                          'headPic': vm.chatters[index].headPic,
                          'userName': vm.chatters[index].userName
                        });
                  },
                  child: Slidable(
                      actions: <Widget>[
                        IconSlideAction(
                          caption: 'Delete',
                          closeOnTap: false,
                          color: Colors.red,
                          icon: Icons.delete,
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (ctx) {
                                  return CupertinoAlertDialog(
                                    title: Text('确定删除吗'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () => Navigator.pop(ctx),
                                          child: Text('取消')),
                                      FlatButton(
                                          onPressed: () {
                                            vm.deleteChatter(
                                                vm.chatters[index].userId);
                                            Navigator.pop(ctx);
                                          },
                                          child: Text('确认')),
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 15, right: 15),
                        child: Row(
                          children: <Widget>[
                            Container(
                              width: 40,
                              height: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: CachedNetworkImage(
                                  imageUrl: vm.chatters[index].headPic,
                                  errorWidget: (context, s, _) =>
                                      ImageErrorWidget(),
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '${vm.chatters[index].userName}',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actionPane: SlidableScrollActionPane()),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  margin: EdgeInsets.only(left: setWidth(100)),
                  height: 1,
                  color: Colors.grey[200],
                );
              },
            ));
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
