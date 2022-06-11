import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  factory WebSocket() {
    return _singleton;
  }

  WebSocket._internal();

  WebSocketChannel? _channel = null;

  bool _connect = false;
  List<String> _subscriber = [];

  void subscribe(String subject){
    if(!_subscriber.contains(subject)){
      _subscriber.add(subject);
      _onListen();
      send(subject, {"action": "subscribe"});
    }
  }

  void unsubscribe(String subject){
    send(subject, {"action": "unsubscribe"});
    _subscriber.remove(subject);
    _onClose();
  }

  send(String subject, dynamic data){
    String toSend = json.encode({
      "subject": subject,
      "data": data
    });
    print(toSend);
    if (_subscriber.contains(subject) && !_connect && _channel != null) {
      _channel!.sink.add(toSend);
    }
  }

  _onListen(){
    if (!_connect) {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://jamsys.ru:8081/websocket'),
      );
      _channel!.stream.listen((message) {
        print(message);
      });
    }
  }

  _onClose(){
    if(_channel != null && _subscriber.isEmpty && _channel != null){
      _channel!.sink.close(status.goingAway);
      _connect = false;
    }
  }

}
