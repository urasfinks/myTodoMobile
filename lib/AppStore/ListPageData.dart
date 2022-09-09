import 'package:flutter/cupertino.dart';

import 'PageData.dart';

class ListPageData{

  static final ListPageData _singleton = ListPageData._internal();
  factory ListPageData() { return _singleton; }
  ListPageData._internal();

  final Map<BuildContext, PageData> _mapPage = {};

  PageData createPageData(BuildContext context, {bool syncSocket = false}) {
    if(!_mapPage.containsKey(context)){
      _mapPage[context] = PageData();
    }
    return _mapPage[context]!;
  }

  List<PageData> getByKey(String key, String value) {
    List<PageData> ret = [];
    if (value.isNotEmpty) {
      for (var item in _mapPage.entries) {
        //If url condition check only before symbol "?"
        String v =
        key == "url" ? item.value.pageDataWidget.getWidgetData(key).toString().split("?")[0] : item.value.pageDataWidget.getWidgetData(key);
        if (value.isNotEmpty && v == value) {
          ret.add(item.value);
        }
      }
    }
    return ret;
  }

  PageData? getByDataUID(String dataUID) {
    List<PageData> list = getByKey("dataUID", dataUID);
    return list.isNotEmpty ? list[0] : null;
  }

  void reloadAll() {
    for (var item in _mapPage.entries) {
      item.value.onIndexRevisionError();
    }
  }

  void remove(PageData appStoreData) {
    BuildContext? ctx;
    for (var item in _mapPage.entries) {
      if (item.value == appStoreData) {
        ctx = item.key;
        break;
      }
    }
    if (ctx != null) {
      _mapPage[ctx]?.destroy();
      _mapPage.remove(ctx);
    }
  }

  void removeByDataUID(String dataUID) {
    BuildContext? key;
    for (var item in _mapPage.entries) {
      if (item.value.pageDataWidget.getWidgetData("dataUID") == dataUID) {
        key = item.key;
        break;
      }
    }
    if (key != null) {
      _mapPage[key]?.destroy();
      _mapPage.remove(key);
    }
  }
}