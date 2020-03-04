import 'dart:async';

class EventBus{
  StreamController _streamController;
  EventBus._init():_streamController=StreamController.broadcast();
  static final EventBus _eventBus=EventBus._init();
  factory EventBus() => _eventBus;

  StreamSubscription listen<T>(event){
      return _streamController.stream.listen(event);
  }
  void dispose() =>_streamController.close();
  void sendMsg(data) {
    if(!_streamController.isClosed){
      _streamController?.sink?.add(data);
    }

  }


}