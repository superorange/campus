import 'dart:async';
import 'dart:convert';

import 'package:flutter_app/config/api/api.dart';
import 'package:oktoast/oktoast.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketUtils {
  WebSocketUtils._init();
  static WebSocketUtils _webSocketUtils;
  StreamController chattersController = StreamController.broadcast();
  StreamController chattingController = StreamController.broadcast();
  IOWebSocketChannel _channel;
  StreamSubscription _subscription;
  bool isOk = false;
  void startConnect() async {
    if (_channel == null) {
      _channel = IOWebSocketChannel.connect(
        Api.socketUrl + Api.chat,
        headers: {'Authorization': Api.token},
      );
      _subscription = _channel.stream.listen(_handleData, onDone: _socketDone,
          onError: (e, s) {
        showToast('网络错误');
        isOk = false;
        _subscription.cancel();
      }, cancelOnError: true);
    }
  }

  void _socketDone() {
    isOk = false;
    _subscription.cancel();
  }

  void _handleData(dynamic data) {
    print('处理！');
    if (!isOk) isOk = true;
    var jsonData = jsonDecode(data);
    if (jsonData['type'] == 'chatting') {
      chattingController.add(jsonData);
    }
    if (jsonData['type'] == 'chatter') {
      chattersController.add(jsonData);
    }
  }

  void resetConnect() {
    _channel = IOWebSocketChannel.connect(
      Api.socketUrl + Api.chat,
      headers: {'Authorization': Api.token},
    );
    _subscription = _channel.stream.listen(_handleData, onDone: _socketDone,
        onError: (e, s) {
      showToast('网络错误');
      isOk = false;
      _subscription.cancel();
    }, cancelOnError: true);
  }

  void getChatters() {
    _channel.sink.add(jsonEncode({
      'code': 202,
    }));
  }

  dispose() {
    isOk = false;
    _subscription.cancel();
    _channel = null;
  }

  void sendData(String msg, String toId) {
    _channel.sink.add(jsonEncode({'code': 200, 'toId': toId, 'msg': msg}));
  }

  void getHistoryMessage() {
    _channel.sink.add(jsonEncode({
      'code': 203,
    }));
  }

  factory WebSocketUtils() {
    return _webSocketUtils ??= WebSocketUtils._init();
  }
  void createNewChatter(String toId) {
//    _channel.sink.add(jsonEncode(CreateConnectModel.toJson(toId)));
  }
}
