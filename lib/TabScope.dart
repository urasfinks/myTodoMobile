import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myTODO/TabPageHistory.dart';
import 'AppStore/AppStore.dart';
import 'AppStore/AppStoreData.dart';
import 'DynamicPage/DynamicPage.dart';
import 'DynamicPage/DynamicPageUtil.dart';

class TabScope {
  // singleton class
  static TabScope? _tabScope;

  /*DynamicPage.fromMap(
        {
          "title": 'Доступные сервисы',
          "url": '/project/system',
          "backgroundColor": "#f5f5f5",
          "pullToRefreshBackgroundColor": "blue.600",
          "progressIndicatorBackgroundColor": "#ffffff",
          "root": true,
          "config": {
            "crossAxisCount": 2,
            "crossAxisSpacing": 10.0
          },
          "grid": true
        },
      ),*/
  final List<TabPageHistory> tabs = [
    TabPageHistory(
      DynamicPage.fromMap(
        {
          "title": 'Главная',
          "url": '/project/to-do',
          "backgroundColor": "#f5f5f5",
          "pullToRefreshBackgroundColor": "blue.600",
          "progressIndicatorBackgroundColor": "#ffffff",
          "root": true
        },
      ),
    ),
    TabPageHistory(
      DynamicPage.fromMap(
        {
          "title": 'Аккаунт',
          "url": '/project/system/account',
          "backgroundColor": "blue.600",
          "pullToRefreshBackgroundColor": "blue.600",
          "progressIndicatorBackgroundColor": "#ffffff",
          "root": true,
        },
      ),
    ),
  ];
  int tabIndex = 0;

  AppStoreData? getLast() {
    if (tabs[tabIndex].history.isNotEmpty) {
      return tabs[tabIndex].history.last;
    }
    return null;
  }

  bool isBack() {
    return tabs[tabIndex].history.length > 1;
  }

  void addHistory(AppStoreData appStoreData) {
    //AppStore.print("addHistory: tabIndex: ${tabIndex};  AppStore: ${appStoreData}");
    if (!tabs[tabIndex].history.contains(appStoreData)) {
      tabs[tabIndex].history.add(appStoreData);
    }
  }

  void onDestroyPage(AppStoreData appStoreData) {
    if (tabs[tabIndex].history.length > 1) {
      if (tabs[tabIndex].history.last == appStoreData) {
        tabs[tabIndex].history.removeLast();
      }
    }
  }

  bool iamActivePage(AppStoreData appStoreData) {
    if (tabs[tabIndex].history.isNotEmpty) {
      return tabs[tabIndex].history.last == appStoreData;
    }
    return false;
  }

  bool popHistory(dynamic data) {
    if (tabs[tabIndex].history.length > 1) {
      if (data != null && data["url"] != null) {
        AppStoreData? last;
        while (tabs[tabIndex].history.length > 1) {
          if (tabs[tabIndex].history.last.getWidgetData("url") == data["url"]) {
            break;
          }
          last = tabs[tabIndex].history.removeLast();
          Navigator.pop(last.getCtx()!);
        }
        if (last != null && tabs[tabIndex].history.isNotEmpty) {
          checkReload(tabs[tabIndex].history.last, last);
        }
      } else if (data != null && data["count"] != null) {
        AppStoreData? last;
        for (int i = 0; i < data["count"]; i++) {
          last = tabs[tabIndex].history.removeLast();
          Navigator.pop(last.getCtx()!);
        }
        if (last != null && tabs[tabIndex].history.isNotEmpty) {
          checkReload(tabs[tabIndex].history.last, last);
        }
      } else {
        AppStoreData last = tabs[tabIndex].history.removeLast();
        Navigator.pop(last.getCtx()!);
        if (tabs[tabIndex].history.isNotEmpty) {
          checkReload(tabs[tabIndex].history.last, last);
        }
      }
      return true;
    }
    return false;
  }

  void checkReload(AppStoreData viewPage, AppStoreData? removePage) {
    bool forwardState = false;
    //Если страница, которую мы открывали была с параметра bridgeState, то надо её состояния партировать в страницу к которой мы переключаемся обратно
    if (removePage != null) {
      dynamic mapBridgeState = removePage.getWidgetData("bridgeState");
      if (mapBridgeState != null &&
          mapBridgeState.runtimeType.toString().contains("Map<") &&
          mapBridgeState.isNotEmpty) {
        for (var item in mapBridgeState.entries) {
          dynamic value = removePage.get(item.key, null);
          if (value != null) {
            viewPage.set(item.key, value, notify: false);
            forwardState = true;
          }
        }
        viewPage.apply();
      }
    }
    if (viewPage.needUpdateOnActive || (removePage != null && removePage.getParentUpdate())) {
      if (forwardState == false) {
        //Можно накосячить с обновлениями, что бы багов небыло при передачи обратно состояния
        DynamicPageUtil.loadData(viewPage);
      }
    }
  }

  static TabScope getInstance() {
    _tabScope ??= TabScope();
    return _tabScope!;
  }

  void setTabIndex(int index) {
    //AppStore.print("SELECTED TAB: ${index}");
    //AppStore.print(tabs[index].history);
    AppStore.selectedTabIndex = index;
    if (tabs[index].history.isNotEmpty) {
      checkReload(tabs[index].history.last, null);
    }
    tabIndex = index;
  }
}