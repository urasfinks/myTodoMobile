import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

class WebSocket {
  static final WebSocket _singleton = WebSocket._internal();

  factory WebSocket() {
    return _singleton;
  }

  WebSocket._internal();

  WebSocketChannel? _channel;

  bool _connect = false;
  final List<String> _subscribeListDataUID = [];

  void subscribe(String dataUID){
    if(!_subscribeListDataUID.contains(dataUID)){
      _subscribeListDataUID.add(dataUID);
      _onListen();
      send(dataUID, "subscribe");
    }
  }

  void unsubscribe(String dataUID){
    send(dataUID, "unsubscribe");
    _subscribeListDataUID.remove(dataUID);
    _onClose();
  }

  send(String dataUID, String action, {dynamic data}){
    String toSend = json.encode({
      "DataUID": dataUID,
      "Action": action,
      if (data != null) "Data": data
    });

    print("$toSend; connect: $_connect");
    if (_subscribeListDataUID.contains(dataUID) && _connect == true && _channel != null) {
      _channel!.sink.add(toSend);
    }
  }

  _onListen(){
    if (!_connect) {
      _channel = WebSocketChannel.connect(
        Uri.parse('ws://jamsys.ru:8081/websocket'),
      );
      _connect = true;
      _channel!.stream.listen((message) {
        print(message);
      });
    }
  }

  _onClose(){
    if(_channel != null && _subscribeListDataUID.isEmpty && _channel != null){
      _channel!.sink.close(status.goingAway);
      _connect = false;
    }
  }

}
