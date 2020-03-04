


import 'package:flutter/material.dart';

class DefaultRoute extends PageRouteBuilder{

  Widget child;
  DefaultRoute({@required this.child}):super(
    pageBuilder:(context, animation, secondaryAnimation)=>child,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) => child,
  );
}