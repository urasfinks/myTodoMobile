import 'package:myTODO/CacheLoadPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Cache {
  static Cache? _cache;
  static bool isInit = false;
  dynamic shared;
  CacheLoadPage cacheLoadPage = CacheLoadPage();

  static Future<Cache> getInstance() async {
    _cache ??= Cache();
    if (!isInit) {
      _cache!.shared = await SharedPreferences.getInstance();
      _cache!.cacheLoadPage.fromState(_cache!.get('CacheLoadPage'));
      isInit = true;
    }
    return _cache!;
  }

  void pageAdd(String url, String data) {
    cacheLoadPage.add(url, data);
    _cache!.set('CacheLoadPage', cacheLoadPage.getState());
  }

  String? pageGet(String url) {
    return cacheLoadPage.get(url)?.data;
  }

  dynamic getShared() {
    return shared;
  }

  String? get(String key) {
    return shared.getString(key);
  }

  set(String key, String value) {
    shared.setString(key, value);
  }
}
