import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/config/api/api.dart';
import 'package:oktoast/oktoast.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketUtils {
  WebSocketUtils._init();
  static WebSocketUtils _webSocketUtils;
  StreamController chattersController;
  StreamController chattingController;
  IOWebSocketChannel _channel;
  IOWebSocketChannel get channel => _channel;
  void startConnect() {
    if (_channel == null) {
      chattersController = StreamController.broadcast();
      chattingController = StreamController.broadcast();
      _channel = IOWebSocketChannel.connect(
        Api.ws + Api.chat,
        headers: {'Authorization': Api.token},
      );
      _channel.stream.listen(_handleData, onDone: () {
        _channel = null;
      }, onError: (e, s) {
        _channel = null;
        showToast('失去网络连接');
      }, cancelOnError: true);
    }
  }

  void _handleData(dynamic data) {
    var jsonData = jsonDecode(data);
    if (jsonData['type'] == 'chatting') {
      chattingController.add(jsonData);
    }
    if (jsonData['type'] == 'chatter') {
      chattersController.add(jsonData);
    }
  }

  void getChatters() {
    if (_channel == null) {
      startConnect();
      if (_channel != null) {
        _channel.sink.add(jsonEncode({
          'code': 202,
        }));
      }
      return;
    }
    _channel.sink.add(jsonEncode({
      'code': 202,
    }));
  }

  dispose() {
    chattersController.close();
    chattingController.close();
    _channel = null;
  }

  void sendData(String msg, String toId) {
    if (_channel == null) {
      startConnect();
      if (_channel != null) {
        _channel.sink.add(jsonEncode({'code': 200, 'toId': toId, 'msg': msg}));
      }
      return;
    }
    _channel.sink.add(jsonEncode({'code': 200, 'toId': toId, 'msg': msg}));
  }

  void createNewChatter(String toId) {
    if (_channel == null) {
      startConnect();
      if (_channel != null) {
        _channel.sink.add(jsonEncode({'code': 201, 'toId': toId}));
      }
      return;
    }
    _channel.sink.add(jsonEncode({'code': 201, 'toId': toId}));
  }

  void deleteChatter(String toId) {
    if (_channel == null) {
      startConnect();
      if (_channel != null) {
        _channel.sink.add(jsonEncode({'code': 208, 'toId': toId}));
      }
      return;
    }
    _channel.sink.add(jsonEncode({'code': 208, 'toId': toId}));
  }

  void getHistoryMessage() {
    _channel.sink.add(jsonEncode({
      'code': 203,
    }));
  }

  factory WebSocketUtils() {
    return _webSocketUtils ??= WebSocketUtils._init();
  }
}
