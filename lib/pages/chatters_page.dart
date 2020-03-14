import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/chat_chatters_vm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_app/utils/screen_config.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';

class ChattersPage extends StatefulWidget {
  @override
  _ChattersPageState createState() => _ChattersPageState();
}

class _ChattersPageState extends State<ChattersPage>
    with AutomaticKeepAliveClientMixin {
  ScrollController scrollController = ScrollController();
  @override
  void initState() {
    Provider.of<ChatChattersPageVm>(context, listen: false).init();
    super.initState();
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        title: Text('聊天'),
        elevation: .0,
        centerTitle: true,
      ),
      body: Consumer<ChatChattersPageVm>(builder: (context, vm, _) {
        return EasyRefresh(
            onRefresh: () async {
              vm.loading();
//              vm.dataBaseManager.clearChatMsgTable();
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
                          'userId': vm.chatters[index].userId,
                          'headPic': vm.chatters[index].headPic,
                          'userName': vm.chatters[index].userName
                        });
                  },
                  child: Container(
                    height: 70,
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 50,
                          height: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: CachedNetworkImage(
                              imageUrl: vm.chatters[index].headPic,
                              errorWidget: (context, s, _) => Container(
                                color: Colors.blue,
                              ),
                              width: 50,
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
