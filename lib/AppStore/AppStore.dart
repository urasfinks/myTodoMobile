import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Cache.dart';
import 'AppStoreData.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert' show utf8, base64;
import 'package:http/http.dart' as http;
import 'dart:developer';

class AppStore {

  static bool isDebug = false;
  static Cache? cache;
  static String host = "https://jamsys.ru:8443";
  static String promo = "/project/to-do/promo";
  static String ws = "ws://jamsys.ru:8081";
  static String version = "1";

  static bool firstStart = false;

  static void fullDebug(dynamic data){
    if(isDebug) {
      log("${data}");
    }
  }

  static void debug(dynamic data){
    if(isDebug){
      print(data);
    }
  }

  static String _personKey = const Uuid().v4();
  static Map<String, String> requestHeader = {};

  static getUriWebSocket(){
    return "$ws/websocket/$_personKey";
  }

  static void updateRequestHeader(){
    String decoded = base64.encode(utf8.encode("PersonKey_$version:$_personKey"));
    requestHeader.addAll({
      'Authorization': "Basic $decoded"
    });

    AppStore.debug("Person key: $_personKey, header: $requestHeader");

  }

  static changePersonKey(String newPersonKey) async{
    AppStore.debug("changePersonKey: ${newPersonKey}");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('key', newPersonKey);
    _personKey = newPersonKey;
    updateRequestHeader();
    AppStore().reloadAll();
  }

  static Future registerPerson() async {
    String url = "${AppStore.host}/person/$_personKey";
    AppStore.debug("registerPerson URL: $url");
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      await cache?.set('key', _personKey);
      updateRequestHeader();
    }
  }

  static void setPersonKey(String key) {
    _personKey = key;
    updateRequestHeader();
  }

  static final AppStore _singleton = AppStore._internal();
  static int selectedTabIndex = 0;

  factory AppStore() {
    return _singleton;
  }

  AppStore._internal();

  static Store<AppStore> store = Store((AppStore state, dynamic action) {
    return state;
  }, initialState: AppStore());

  static AppStoreData getStore(BuildContext context, {bool syncSocket = false}) {
    return StoreProvider.of<AppStore>(context).state.get(context, {syncSocket: syncSocket});
  }

  static dynamic connect(AppStoreData appStoreData, Widget Function(dynamic defaultValue) builder,
      {defaultValue = ""}) {
    //AppStore.print("connect");
    return StoreConnector<AppStore, AppStoreData>(
      converter: (store) => appStoreData,
      builder: (context, state) {
        //AppStore.print("Build StoreConnector: ${state}");
        return Function.apply(builder, [defaultValue]);
      },
    );
  }

  final Map<BuildContext, AppStoreData> _map = {};

  AppStoreData get(BuildContext key, Map map, {bool syncSocket = false}) {
    if (!_map.containsKey(key)) {
      _map[key] = AppStoreData(AppStore.store);
    }
    return _map[key]!;
  }

  AppStoreData? getByDataUID(String dataUID) {
    List<AppStoreData> list = getByKey("dataUID", dataUID);
    return list.isNotEmpty ? list[0] : null;
  }

  void reloadAll() {
    for (var item in _map.entries) {
      item.value.onIndexRevisionError();
    }
  }

  List<AppStoreData> getByKey(String key, String value) {
    List<AppStoreData> ret = [];
    if (value.isNotEmpty) {
      for (var item in _map.entries) {
        //If url condition check only before symbol "?"
        String v =
            key == "url" ? item.value.getWidgetData(key).toString().split("?")[0] : item.value.getWidgetData(key);
        if (value.isNotEmpty && v == value) {
          ret.add(item.value);
        }
      }
    }
    return ret;
  }

  void remove(AppStoreData appStoreData) {
    BuildContext? ctx;
    for (var item in _map.entries) {
      if (item.value == appStoreData) {
        ctx = item.key;
        break;
      }
    }
    if (ctx != null) {
      _map[ctx]?.destroy();
      _map.remove(ctx);
    }
  }

  void removeByDataUID(String dataUID) {
    BuildContext? key;
    for (var item in _map.entries) {
      if (item.value.getWidgetData("dataUID") == dataUID) {
        key = item.key;
        break;
      }
    }
    if (key != null) {
      _map[key]?.destroy();
      _map.remove(key);
    }
  }

}
