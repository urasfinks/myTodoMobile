import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'AppStoreData.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uuid/uuid.dart';

class AppStore {
  static String host = "http://jamsys.ru:8081";
  static String ws = "ws://jamsys.ru:8081";

  static String personKey = const Uuid().v4();
  static String personKeyBasicAuth = const Uuid().v4();
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

  static dynamic connect(AppStoreData appStoreData, Widget Function(dynamic defaultValue) builder, {defaultValue = ""}) {
    //print("connect");
    return StoreConnector<AppStore, AppStoreData>(
      converter: (store) => appStoreData,
      builder: (context, state) {
        //print("Build StoreConnector: ${state}");
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

  List<AppStoreData> getByKey(String key, String value) {
    List<AppStoreData> ret = [];
    if (value.isNotEmpty) {
      for (var item in _map.entries) {
        //If url condition check only before symbol "?"
        String v = key == "url" ? item.value.getWidgetData(key).toString().split("?")[0] : item.value.getWidgetData(key);
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
