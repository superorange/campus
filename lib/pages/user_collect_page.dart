import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/vm/userCollectVm.dart';
import 'package:flutter_app/routes/routes.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

class UserCollectPage extends StatefulWidget {
  @override
  _UserCollectPageState createState() => _UserCollectPageState();
}

class _UserCollectPageState extends State<UserCollectPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>UserCollectVm(),
    child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Consumer<UserCollectVm>(builder: (context,vm,_){
          return Text('${vm.models?.length??''} 条记录');
        }),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more), onPressed: (){
            showToast('右滑删除');
          })
        ],
      ),
      body: Consumer<UserCollectVm>(builder: (context,vm,_){
        if(vm.models==null){
          vm.getUsers();
          return Center(
            child: CupertinoActivityIndicator(),
          );}
        return ListView.separated(
            itemBuilder: (_,index)=>Slidable(
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
                              title: Text('确定取消关注吗'),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text('取消')),
                                FlatButton(
                                    onPressed: () {
                                      vm.delete(vm.models[index].userId);
                                      Navigator.pop(ctx);
                                    },
                                    child: Text('确认')),
                              ],
                            );
                          });
                    },
                  ),
                ],
                child: InkWell(
                  onTap: (){
                    Navigator.pushNamed(context, RouteName.userPage,arguments: vm.models[index].userId);
                  },
                  child: Container(
                    height: 90,
                    margin: EdgeInsets.only(
                        left: 10,right: 10
                    ),
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              vm.models[index].headPic
                          ),
                        ),
                        SizedBox(width: 10,),
                        Text(vm.models[index].userName,overflow: TextOverflow.ellipsis,),

                      ],
                    ),
                  ),
                ),
                actionPane: SlidableScrollActionPane()),
            separatorBuilder: (_,__)=>Divider(),
            itemCount: vm.models.length
        );

      }),
    ),
    );
  }
}
