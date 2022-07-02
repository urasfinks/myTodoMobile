import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';
import 'AppStoreData.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:uuid/uuid.dart';

class AppStore {
  static String host = "http://jamsys.ru:8081/";
  static String personKey = const Uuid().v4();
  static final AppStore _singleton = AppStore._internal();

  factory AppStore() {
    return _singleton;
  }

  AppStore._internal();

  static Store<AppStore> store = Store(
    (AppStore state, dynamic action) => state,
    initialState: AppStore(),
  );

  static AppStoreData getStore(BuildContext context, {bool syncSocket = false}) {
    return StoreProvider.of<AppStore>(context).state.get(context, {syncSocket: syncSocket});
  }

  static dynamic connect(String dataUID, Widget Function(AppStoreData? store, dynamic defaultValue) builder, {syncSocket = false, defaultValue = ""}) {
    AppStoreData? byName = store.state.getByDataUID(dataUID);
    if (byName != null) {
      return StoreConnector<AppStore, AppStoreData>(
        converter: (store) => store.state.getByDataUID(dataUID)!,
        builder: (context, state) {
          return Function.apply(builder, [state, defaultValue]);
        },
      );
    } else {
      return Function.apply(builder, [null, defaultValue]);
    }
  }

  final Map<BuildContext, AppStoreData> _map = {};

  AppStoreData get(BuildContext key, Map map, {bool syncSocket = false}) {
    if(!_map.containsKey(key)){
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
    if(value.isNotEmpty){
      for (var item in _map.entries) {
        if (value.isNotEmpty && item.value.getWidgetData(key) == value) {
          ret.add(item.value);
        }
      }
    }
    return ret;
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
