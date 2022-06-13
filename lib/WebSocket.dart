import 'package:test3/AppStore/AppStore.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'dart:convert';

import 'AppStore/AppStoreData.dart';

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

    print("Send: $toSend; connect: $_connect");
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
        print("Recive: $message");
        Map<String, dynamic> jsonDecoded = json.decode(message);
        if(check(jsonDecoded, {"Action": "update_revision", "Revision": null, "DataUID": null})){
          AppStore().getByName(jsonDecoded["DataUID"])?.setIndexRevision(jsonDecoded["Revision"]);
        }
        if(check(jsonDecoded, {"Action": "reload_page", "DataUID": null})){
          AppStore().getByName(jsonDecoded["DataUID"])?.onIndexRevisionError();
        }
        if(check(jsonDecoded, {"Action": "update_state", "Revision": null, "DataUID": null, "Data": null})){
          AppStoreData? storeData = AppStore().getByName(jsonDecoded["DataUID"]);
          if(storeData != null){
            if(check(jsonDecoded["Data"], {"key": null, "value": null})){
              storeData.set(jsonDecoded["Data"]["key"], jsonDecoded["Data"]["value"], notify: false);
              storeData.apply();
            }
            storeData.setIndexRevision(jsonDecoded["Revision"]);
          }
        }
      });
    }
  }

  bool check(dynamic object, Map<String, dynamic> map){
    //print(map.keys);
    for(String key in map.keys){
      if(object[key] == null){
        return false;
      }
      if(map[key] != null && object[key] != map[key]){
        return false;
      }
    }
    return true;
  }

  _onClose(){
    if(_channel != null && _subscribeListDataUID.isEmpty && _channel != null){
      _channel!.sink.close(status.goingAway);
      _connect = false;
    }
  }

}
