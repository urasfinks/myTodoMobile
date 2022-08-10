import 'dart:convert';

class CacheLoadPage {
  int max = 20;
  List<CacheLoadPageItem> list = [];

  void add(String url, String data) {
    //print("CacheLoadPage.add: ${url}");
    CacheLoadPageItem? item = get(url);
    list.add(CacheLoadPageItem(url, data));
    if (list.length > max) {
      if (item == null) {
        list.sort((CacheLoadPageItem a, CacheLoadPageItem b) {
          return a.time > b.time ? -1 : 1;
        });
        //print("remove not find: ${list.last.url}");
        list.remove(list.last);
      } else {
        //print("remove find: ${item.url}");
        list.remove(item);
      }
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
    //print("getState: ${x}");
    return x;
  }

  void fromState(String? json) {
    if (json == null) {
      return;
    }
    //print("fromState: ${json}");
    try {
      dynamic lst = jsonDecode(json);
      for (Map item in lst) {
        list.add(CacheLoadPageItem(item["url"], item["data"], t: item["time"]));
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
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
