import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ImageErrorWidget extends StatelessWidget {
  Color color;
  ImageErrorWidget({this.color = Colors.grey});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/image_error.png',
      width: 40,
      height: 40,
      color: color,
    );
  }
}
