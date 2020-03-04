import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// ignore: must_be_immutable
class LoadingWidget extends StatelessWidget {
  LoadingWidget(this.ctx,{this.canRemove=true,this.canBack=true});
  BuildContext ctx;
  bool canRemove;
  bool canBack;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: IgnorePointer(
      ignoring: !canRemove,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(ctx);
        },
        child: Material(
            type: MaterialType.transparency,
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.black26.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(7)
                ),
                alignment: Alignment.center,
                child:SpinKitCircle(color: Colors.white,
                  size: 50.0,),
              ),
            )
        ),
      ),
    ), onWillPop: ()async{
      return canBack?true:false;
    });
  }
}
