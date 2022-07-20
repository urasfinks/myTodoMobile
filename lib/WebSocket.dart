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

  void subscribe(String dataUID) {
    if (dataUID.isNotEmpty) {
      print("Subscribe: $dataUID");
      if (!_subscribeListDataUID.contains(dataUID)) {
        _subscribeListDataUID.add(dataUID);
        _onListen();
        send(dataUID, "SUBSCRIBE");
      }
    }
  }

  void unsubscribe(String dataUID) {
    send(dataUID, "UNSUBSCRIBE");
    _subscribeListDataUID.remove(dataUID);
    _onClose();
  }

  send(String dataUID, String action, {dynamic data}) {
    String toSend = json.encode({"DataUID": dataUID, "Action": action, if (data != null) "Data": data});

    print("Send: $toSend; connect: $_connect");
    if (_subscribeListDataUID.contains(dataUID) && _connect == true && _channel != null) {
      _channel!.sink.add(toSend);
    }
  }

  _onListen() {
    if(_subscribeListDataUID.isEmpty){
      return;
    }
    if (!_connect) {
      print(AppStore.getUriWebSocket());
      _channel = WebSocketChannel.connect(
        Uri.parse(AppStore.getUriWebSocket()),
      );
      _connect = true;

      _channel!.stream.listen((message) {
        print("Recive: $message");
        Map<String, dynamic> jsonDecoded = json.decode(message);
        if (check(
            jsonDecoded, {"Action": "UPDATE_REVISION", "Revision": null, "DataUID": null, "Time": null, "Key": null})) {
          //AppStore().getByDataUID(jsonDecoded["DataUID"])?.setIndexRevision(jsonDecoded["Revision"]);
          AppStoreData? storeData = AppStore().getByDataUID(jsonDecoded["DataUID"]);
          if (storeData != null) {
            storeData.setIndexRevision(jsonDecoded["Revision"]);
            storeData.set("time_${jsonDecoded["Key"]}", jsonDecoded["Time"], notify: false);
            //print("UPDATE_REVISION: ${storeData.getStringStoreState()}");
            storeData.apply();
          }
        }
        if (check(jsonDecoded, {"Action": "RELOAD_PAGE", "DataUID": null})) {
          AppStore().getByDataUID(jsonDecoded["DataUID"])?.onIndexRevisionError();
        }
        if (check(jsonDecoded,
            {"Action": "UPDATE_STATE", "Revision": null, "DataUID": null, "Data": null, "Time": null, "Key": null})) {
          AppStoreData? storeData = AppStore().getByDataUID(jsonDecoded["DataUID"]);
          if (storeData != null) {
            storeData.set("time_${jsonDecoded["Key"]}", jsonDecoded["Time"], notify: false);
            if (check(jsonDecoded["Data"], {"key": null, "value": null})) {
              storeData.set(jsonDecoded["Data"]["key"], jsonDecoded["Data"]["value"], notify: false);
            }
            //print("UPDATE_STATE: ${storeData.getStringStoreState()}");
            storeData.apply();
            storeData.setIndexRevision(jsonDecoded["Revision"]);
          }
        }
      }, onDone: (){
        print("Socket Done");
        _connect = false;
        if(_subscribeListDataUID.isNotEmpty){
          reconnect();
        }
      }, onError: (e, stacktrace){
        print("Socket OnError $e");
        print(stacktrace);
        _connect = false;
        reconnect();
      },cancelOnError: true);
    }
  }

  int delay = 5000;

  void reconnect() async{
    await Future.delayed(Duration(milliseconds: delay), () {});
    if(_connect == false){
      print("Reconnect WebSocket");
      try {
        if (_channel != null) {
          _channel!.sink.close(status.goingAway);
          _connect = false;
        }
      }catch(e){}
      _onListen();
    }
  }

  bool check(dynamic object, Map<String, dynamic> map) {
    //print(map.keys);
    for (String key in map.keys) {
      if (object[key] == null) {
        return false;
      }
      if (map[key] != null && object[key] != map[key]) {
        return false;
      }
    }
    return true;
  }

  _onClose() {
    if (_channel != null && _subscribeListDataUID.isEmpty) {
      _channel!.sink.close(status.goingAway);
      _connect = false;
    }
  }
}
