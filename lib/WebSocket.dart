import 'dart:io';

import 'package:myTODO/AppStore/GlobalData.dart';
import 'package:myTODO/DynamicPage/DynamicFn.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/io.dart';
import 'dart:convert';

import 'AppMetric.dart';
import 'AppStore/PageData.dart';
import 'AppStore/ListPageData.dart';

class WebSocketService {
  static final WebSocketService _singleton = WebSocketService._internal();

  factory WebSocketService() {
    return _singleton;
  }

  WebSocketService._internal();

  WebSocketChannel? _channel;

  bool _connect = false;
  final List<String> _subscribeListDataUID = [];

  void subscribe(String dataUID) {
    if (dataUID != null && dataUID.isNotEmpty) {
      GlobalData.debug("Subscribe: $dataUID");
      if (!_subscribeListDataUID.contains(dataUID)) {
        _subscribeListDataUID.add(dataUID);
        sendToServer(dataUID, "SUBSCRIBE");
      }
      _onListen();
    }
  }

  void unsubscribe(String dataUID) {
    sendToServer(dataUID, "UNSUBSCRIBE");
    _subscribeListDataUID.remove(dataUID);
    _onClose();
  }

  List<String> listToSend = [];

  sendToServer(String dataUID, String action, {dynamic data}) {
    String toSend = json.encode({"DataUID": dataUID, "Action": action, if (data != null) "Data": data});
    GlobalData.debug("prepare sendToServer: $toSend");
    if (_subscribeListDataUID.contains(dataUID)) {
      listToSend.add(toSend);
    } else {
      GlobalData.debug("prepare sendToServer not fount $dataUID");
    }
    _deferredSend();
  }

  _deferredSend() {
    //AppStore.debug("_deferredSend _connect: $_connect;");
    try {
      if (_connect == true) {
        while (listToSend.isNotEmpty) {
          String data = listToSend.last;
          if (_connect == true && _channel != null) {
            GlobalData.debug("Send to WebSocket: $data");
            _channel!.sink.add(data);
            listToSend.removeLast();
          } else {
            break;
          }
        }
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
    }
  }

  _startListener() {
    _channel!.stream.listen((message) {
      GlobalData.debug("Recive: $message");
      Map<String, dynamic> jsonDecoded = json.decode(message);
      if (check(
          jsonDecoded, {"Action": "UPDATE_REVISION", "Revision": null, "DataUID": null, "Time": null, "Key": null})) {
        //AppStore().getByDataUID(jsonDecoded["DataUID"])?.setIndexRevision(jsonDecoded["Revision"]);
        PageData? storeData = ListPageData().getByDataUID(jsonDecoded["DataUID"]);
        if (storeData != null) {
          storeData.setIndexRevision(jsonDecoded["Revision"]);
          DynamicFn.alert(storeData, {"data": "Сохранено"});
          storeData.pageDataState.set("_time_${jsonDecoded["Key"]}", jsonDecoded["Time"], notify: false);
          //GlobalData.debug("UPDATE_REVISION: ${storeData.getStringStoreState()}");
          storeData.apply();
        }
      }
      if (check(jsonDecoded, {"Action": "RELOAD_PAGE", "DataUID": null})) {
        ListPageData().getByDataUID(jsonDecoded["DataUID"])?.onIndexRevisionError();
      }
      if (check(jsonDecoded,
          {"Action": "UPDATE_STATE", "Revision": null, "DataUID": null, "Data": null, "Time": null, "Key": null})) {
        PageData? storeData = ListPageData().getByDataUID(jsonDecoded["DataUID"]);
        if (storeData != null) {
          storeData.pageDataState.set("_time_${jsonDecoded["Key"]}", jsonDecoded["Time"], notify: false);
          if (check(jsonDecoded["Data"], {"key": null, "value": null})) {
            storeData.pageDataState.set(jsonDecoded["Data"]["key"], jsonDecoded["Data"]["value"], notify: false);
          }
          //GlobalData.debug("UPDATE_STATE: ${storeData.getStringStoreState()}");
          storeData.apply();
          storeData.setIndexRevision(jsonDecoded["Revision"]);
        }
      }
    }, onDone: () {
      GlobalData.debug("Socket Done");
      _connect = false;
      if (_subscribeListDataUID.isNotEmpty && _isStop == false) {
        reconnect();
      }
    }, onError: (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
      _connect = false;
      reconnect();
    }, cancelOnError: true);
  }

  bool _connectProcess = false;

  _onListen() {
    if (_subscribeListDataUID.isEmpty) {
      GlobalData.debug("_onListen _subscribeListDataUID.isEmpty");
      return;
    }
    //AppStore.debug("_onListen 1");
    if (!_connect) {
      //AppStore.debug("_onListen 2 _connectProcess: $_connectProcess");
      if (!_connectProcess) {
        //AppStore.debug("_onListen 3");
        _connectProcess = true;
        //AppStore.debug("Open connection: ${AppStore.getUriWebSocket()}");
        try {
          WebSocket.connect(GlobalData.getUriWebSocket()).timeout(const Duration(seconds: 5)).then((ws) {
            try {
              _channel = IOWebSocketChannel(ws);
              GlobalData.debug('WebSocket connect');
              _connect = true;
              _startListener();
              _deferredSend();
            } catch (e, stacktrace) {
              //AppStore.debug('Error happened when opening a new websocket connection. ${e.toString()}');
              AppMetric().exception(e, stacktrace);
            }
            _connectProcess = false;
          });
        } catch (e) {
          reconnect();
        }
      } else {
        //Принудительно переводим статус остановки
        Future.delayed(const Duration(milliseconds: 5100), () {
          if (_connectProcess == true) {
            _connectProcess = false;
            reconnect();
          }
        });
      }
    } else {
      GlobalData.debug("Pass because connect = true");
    }
  }

  void _restoreSubscribe() {
    if (_subscribeListDataUID.isNotEmpty) {
      for (String dataUID in _subscribeListDataUID) {
        sendToServer(dataUID, "SUBSCRIBE");
      }
    }
  }

  int delay = 5000;

  void reconnect() async {
    await Future.delayed(Duration(milliseconds: delay), () {});
    if (_connect == false) {
      GlobalData.debug("Reconnect WebSocket");
      try {
        if (_channel != null) {
          _channel!.sink.close(status.goingAway);
          _connect = false;
        }
      } catch (e) {}
      _onListen();
      _restoreSubscribe();
    }
  }

  bool check(dynamic object, Map<String, dynamic> map) {
    //GlobalData.debug(map.keys);
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

  void start() {
    GlobalData.debug("Start WebSocket");
    _isStop = false;
    _onListen();
    _restoreSubscribe();
  }

  bool _isStop = false;

  void stop() {
    GlobalData.debug("Stop WebSocket; connect: $_connect");
    _isStop = true;
    if (_channel != null && _connect == true) {
      _channel!.sink.close(status.goingAway);
      _connect = false;
    }
  }

  void checkConnection() {
    GlobalData.debug("Connect: $_connect; ConnectProcess: $_connectProcess; Chanel: $_channel");
  }
}
