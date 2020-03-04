import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FullWidget extends StatelessWidget {
  FullWidget({@required this.child,this.t=false,this.b=false,this.l=false,this.r=false});
  Widget child;
  bool t,b,l,r;
  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        removeBottom: b,
        removeLeft: l,
        removeRight: r,
        removeTop: t,
        context: context,
        child: child
    );
  }
}
