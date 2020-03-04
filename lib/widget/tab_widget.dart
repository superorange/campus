import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TABWidget extends StatelessWidget {
  Widget t;
  Widget b;
  EdgeInsets edgeInsetsPt;
  EdgeInsets edgeInsetsPb;
  EdgeInsets edgeInsetsMt;
  EdgeInsets edgeInsetsMb;
  MainAxisAlignment mainAxisAlignment;
  CrossAxisAlignment crossAxisAlignment;
  TABWidget({
    @required this.t,
    @required this.b,
    this.edgeInsetsPt=EdgeInsets.zero,
  this.edgeInsetsMb=EdgeInsets.zero,
  this.edgeInsetsMt=EdgeInsets.zero,
  this.edgeInsetsPb=EdgeInsets.zero,
    this.mainAxisAlignment=MainAxisAlignment.center,
    this.crossAxisAlignment=CrossAxisAlignment.center});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: <Widget>[
         Container(child: t,padding: edgeInsetsPt,margin: edgeInsetsMt,),
          Container(child: b,padding: edgeInsetsPb,margin: edgeInsetsMb,)
        ],
      ),
    );
  }
}
