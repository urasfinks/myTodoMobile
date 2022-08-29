import 'dart:convert';

import 'AppMetric.dart';

class CacheLoadPage {
  int max = 100;
  List<CacheLoadPageItem> list = [];

  void add(String url, String data) {
    //AppStore.print("CacheLoadPage.add: ${url}");
    CacheLoadPageItem? item = get(url);
    if(item != null){ //Сумарно получается замещение
      list.remove(item);
    }
    list.add(CacheLoadPageItem(url, data));
    if (list.length > max) {
      list.sort((CacheLoadPageItem a, CacheLoadPageItem b) {
        return a.time > b.time ? -1 : 1;
      });
      //AppStore.print("remove not find: ${list.last.url}");
      list.remove(list.last);
    }
  }

  String getState() {
    List<Map> to = [];
    for (CacheLoadPageItem item in list) {
      Map x = {};
      x["url"] = item.url;
      x["data"] = item.data;
      x["time"] = item.time;
      to.add(x);
    }
    String x = jsonEncode(to);
    //AppStore.print("getState: ${x}");
    return x;
  }

  void fromState(String? json) {
    if (json == null) {
      return;
    }
    //AppStore.print("fromState: ${json}");
    try {
      dynamic lst = jsonDecode(json);
      for (Map item in lst) {
        list.add(CacheLoadPageItem(item["url"], item["data"], t: item["time"]));
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
    }
  }

  CacheLoadPageItem? get(String url) {
    for (CacheLoadPageItem item in list) {
      if (item.url == url) {
        return item;
      }
    }
    return null;
  }
}

class CacheLoadPageItem {
  String url;
  String data;
  int time = 0;

  CacheLoadPageItem(this.url, this.data, {int? t = null}) {
    if (t != null) {
      time = t;
    } else {
      time = DateTime.now().millisecondsSinceEpoch;
    }
  }
}
