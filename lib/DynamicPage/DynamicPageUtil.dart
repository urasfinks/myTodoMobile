import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myTODO/DynamicUI/Addon.dart';
import '../AppMetric.dart';
import '../AppStore/GlobalData.dart';
import '../AppStore/PageData.dart';
import 'package:flutter/material.dart';
import '../Cache.dart';
import '../Util.dart';
import 'DynamicFn.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode, jsonDecode;

import 'dart:async';

class DynamicPageUtil {
  static int delay = 350; //Animation open new page!!!

  static Future<void> loadData(PageData appStoreData, {pause = true}) async {
    //return;

    appStoreData.nowDownloadContent = true;
    appStoreData.needUpdateOnActive = false;

    //await Future.delayed(Duration(milliseconds: 5000), () {}); //Для тестирования загрузки из cache

    if (pause == true && !appStoreData.pageDataWidget.getWidgetData('root')) {
      await Future.delayed(Duration(milliseconds: delay), () {});
    }
    GlobalData.debug('Prepare download: ${appStoreData.pageDataWidget.getWidgetDates()}');
    try {
      final response = await http.post(Uri.parse("${GlobalData.host}${appStoreData.pageDataWidget.getWidgetData('url')}"),
          headers: GlobalData.requestHeader, body: appStoreData.pageDataWidget.getWidgetData('parentState'));

      appStoreData.clearState();

      //AppStore.fullDebug(response.body);
      GlobalData.debug("Download complete");
      //AppStore.fullDebug(response.body);
      if (response.statusCode == 200) {
        Map<String, dynamic> resp = jsonDecode(response.body);
        if (resp["Cache"] != null && resp["Cache"] == true) {
          Cache.getInstance().then((Cache cache) {
            cache.pageAdd(appStoreData.pageDataWidget.getWidgetData('url'), response.body);
          });
        }
        if (resp["AppMetricToken"] != null) {
          AppMetric().activate(resp["AppMetricToken"]);
        }
        dataUpdate(resp, appStoreData);
      } else {
        setErrorStyle(appStoreData);
        if (response.statusCode == 401) {
          //Получается персону удалили, повторный перезапуск приклада заного создат новую, понимаю - это как-то не человечно, однако не будет deadlock
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('key');
        }
        dataUpdate(ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body), appStoreData);
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
      setErrorStyle(appStoreData);
      if (e.toString().contains("Failed host lookup:")) {
        String? cachedDataPage = GlobalData.cache?.pageGet(appStoreData.pageDataWidget.getWidgetData("url"));
        if (cachedDataPage != null) {
          DynamicPageUtil.dataUpdate(jsonDecode(cachedDataPage), appStoreData, native: false);
          DynamicFn.alert(appStoreData, {"data": "Локальная версия"});
        } else {
          dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), appStoreData);
        }
      } else {
        dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), appStoreData);
      }
    }
    appStoreData.nowDownloadContent = false;
  }

  static void setErrorStyle(PageData appStoreData) {
    appStoreData.pageDataWidget.addWidgetData("title", "Ошибка");
    appStoreData.pageDataWidget.addWidgetData("dialog", false);
    appStoreData.pageDataWidget.addWidgetData('grid', false); //А то не влезает
  }

  static List<Widget>? getListAppBarActions(PageData appStoreData) {
    List<Widget> list = [];
    try {
      Map<String, dynamic> response = appStoreData.getServerResponse();
      List<dynamic>? listAppBarActions = response['actions'];
      if (listAppBarActions != null && listAppBarActions.isNotEmpty) {
        int idx = 0;
        for (dynamic act in listAppBarActions) {
          list.add(DynamicUI.mainJson(act, appStoreData, idx++, "AppBarActions"));
        }
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
    }
    return list.isNotEmpty ? list : null;
  }

  static void parseTemplate(Map<String, dynamic> data, String key, String ret) {
    if (data.containsKey(key)) {
      List<dynamic> list = [];
      Map<String, dynamic> template = data['Template'];
      bool needNextRoundBorderRadius = false;
      for (dynamic item in data[key]) {
        String ret;
        if (template.containsKey(item['template'])) {
          ret = Util.template(item['data'], data['Template'][item['template']]);
          if (item['wrapTemplate'] != null && item['wrapTemplate'] != "") {
            item['data']["dataWrapped"] = ret;
            ret = Util.template(item['data'], data['Template'][item['wrapTemplate']]);
            //AppStore.fullDebug(ret);
          }
        } else {
          ret = jsonEncode({"flutterType": "Text", "data": "Undefined Template: ${item['template']}"});
        }
        try {
          dynamic p = jsonDecode(ret);
          if (needNextRoundBorderRadius == true) {
            needNextRoundBorderRadius = false;
            Addon.radius(p, "top");
          }
          if (item['template'] == "GroupBottom" && list.isNotEmpty) {
            Addon.radius(list.last, "bottom");
          }
          list.add(p);
          if (item['template'] == "GroupTop") {
            needNextRoundBorderRadius = true;
          }
        } catch (e, stacktrace) {
          list.add({"flutterType": "Text", "data": "Exception template: $e"});
          AppMetric().exception(e, stacktrace);
        }
      }
      data[ret] = list;
    }
  }

  static dataUpdate(Map<String, dynamic> data, PageData pageData, {bool native = true}) {
    pageData.setServerResponse(data);

    List<dynamic>? action = data['Actions'];
    if (action != null && action.isNotEmpty) {
      for (Map item in action) {
        DynamicUI.def(item, "method", null, pageData, 0, "Data");
      }
    }

    if (data['RevisionState'] != null && data['RevisionState'] != "") {
      pageData.setIndexRevisionWithoutReload(data['RevisionState']);
    }
    if (data['WidgetData'] != null && data['WidgetData'] != "") {
      //GlobalData.debug("SET NEW WIDGET DATA(${data['WidgetData']})");
      pageData.pageDataWidget.addWidgetDataByMap(data['WidgetData']);
    }

    if (data['State'] != null && data['State'] != "") {
      Map<String, dynamic> map = data['State'];
      for (var item in map.entries) {
        pageData.pageDataState.set(item.key, item.value, notify: false);
      }
      pageData.apply(); //Maybe setState refresh Data on UI?
    }

    dynamic mapBridgeState = pageData.pageDataWidget.getWidgetData("bridgeState");
    if (mapBridgeState != null && mapBridgeState.runtimeType.toString().contains("Map<") && mapBridgeState.isNotEmpty) {
      for (var item in mapBridgeState.entries) {
        pageData.pageDataState.set(item.key, item.value, notify: false);
      }
      pageData.apply();
    }

    if (native == true &&
        data['SyncSocket'] != null &&
        data['SyncSocket'] == true &&
        (pageData.pageDataWidget.getWidgetData("dataUID") as String).isNotEmpty) {
      pageData.setSyncSocket(true);
      WebSocketService().subscribe(pageData.pageDataWidget.getWidgetData("dataUID"));
    }

    parseTemplate(data, "Data", "list");
    parseTemplate(data, "AppBarActions", "actions");
    //GlobalData.debug(data);

    /*Избежание рекурсивного переопредления _build статуса
     Поймал проблему, когда rebuild -> _build = true,
     но инициатор процесса initPage, в конце определяет build = false
     и на момент setState и повторного build мы не перекомпилируем отображение*/
    Future.delayed(const Duration(milliseconds: 1), () {
      pageData.reBuild();
      pageData.getPageState()?.setState(() {});
    });

    if (native == true && data['ParentPersonKey'] != null) {
      Future.delayed(Duration(milliseconds: delay), () {
        GlobalData.changePersonKey(data['ParentPersonKey']);
      });
    }
  }
}
