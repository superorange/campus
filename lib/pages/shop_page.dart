import 'package:flutter/material.dart';
import 'package:flutter_app/pages/trade_search_page.dart';

class TradePage extends StatefulWidget {
  @override
  _TradePageState createState() => _TradePageState();
}

class _TradePageState extends State<TradePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
            TradeSearchPage(),
        ],
      ),
    );
  }
}

