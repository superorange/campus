import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'image_error.dart';

class CircleHeadPic extends StatelessWidget {
  final String url;
  CircleHeadPic(this.url);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      margin: EdgeInsets.only(
          left: 2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: CachedNetworkImage(
          fit: BoxFit.fill,
          imageUrl:url,
          errorWidget: (context,
              s, _) =>
              ImageErrorWidget(),
          fadeInCurve:
          Curves.easeIn,
          placeholder: (context,
              s) =>
              CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}
