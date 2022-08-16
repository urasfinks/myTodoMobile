import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myTODO/DynamicUI/Addon.dart';
import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import 'package:flutter/material.dart';
import '../Cache.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show jsonEncode, jsonDecode;

import 'dart:async';

class DynamicPageUtil {
  static int delay = 350; //Animation open new page!!!

  static Future<void> loadDataTest(DynamicPage widget, AppStoreData appStoreData) async {
    await Future.delayed(Duration(milliseconds: delay), () {});
    //dataUpdate(TextEditRowJsonObject.getPage(), appStoreData);
  }

  static Future<void> loadData(AppStoreData appStoreData) async {

    //return;

    appStoreData.nowDownloadContent = true;
    appStoreData.needUpdateOnActive = false;

    //await Future.delayed(Duration(milliseconds: 5000), () {}); //Для тестирования загрузки из cache

    if (!appStoreData.getWidgetData('root')) {
      await Future.delayed(Duration(milliseconds: delay), () {});
    }
    AppStore.debug('Prepare download: ${appStoreData.getWidgetDates()}');
    try {
      final response = await http.post(Uri.parse("${AppStore.host}${appStoreData.getWidgetData('url')}"),
          headers: AppStore.requestHeader, body: appStoreData.getWidgetData('parentState'));

      appStoreData.clearState();

      //AppStore.print(response.body);
      AppStore.debug("Download complete");
      if (response.statusCode == 200) {
        Map<String, dynamic> resp = jsonDecode(response.body);
        if(resp["Cache"] != null && resp["Cache"] == true){
          Cache.getInstance().then((Cache cache) {
            cache.pageAdd(appStoreData.getWidgetData('url'), response.body);
          });
        }
        dataUpdate(resp, appStoreData);
      } else {
        setErrorStyle(appStoreData);
        if (response.statusCode == 401) {
          //Получается персону удалили, повторный перезапуск приклада заного создат новую, понимаю - это как-то не человечно, однако не будет deadlock
          final prefs = await SharedPreferences.getInstance();
          prefs.remove('key');
        }
        dataUpdate(
            ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body), appStoreData);
      }
    } catch (e, stacktrace) {
      AppStore.debug(e);
      AppStore.debug(stacktrace);
      setErrorStyle(appStoreData);
      dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), appStoreData);
    }
    appStoreData.nowDownloadContent = false;
  }

  static void setErrorStyle(AppStoreData appStoreData) {
    appStoreData.addWidgetData("title", "Ошибка");
    appStoreData.addWidgetData("dialog", false);
    appStoreData.addWidgetData('grid', false); //А то не влезает
  }

  static List<Widget>? getListAppBarActions(AppStoreData appStoreData) {
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
      AppStore.debug(e);
      AppStore.debug(stacktrace);
    }
    return list.isNotEmpty ? list : null;
  }

  static void parseTemplate(Map<String, dynamic> data, String key, String ret) {
    if (data.containsKey(key)) {
      List<dynamic> list = [];
      Map<String, dynamic> template = data['Template'];
      bool needNextRoundBorderRadius = false;
      for (dynamic d in data[key]) {
        String ret;
        if (template.containsKey(d['template'])) {
          //AppStore.print(data['Template'][d['template']]);
          ret = Util.template(d['data'], data['Template'][d['template']]);
          //AppStore.print(ret);
        } else {
          ret = jsonEncode({"flutterType": "Text", "data": "Undefined Template: ${d['template']}"});
        }
        try {
          dynamic p = jsonDecode(ret);
          if (needNextRoundBorderRadius == true) {
            needNextRoundBorderRadius = false;
            Addon.radius(p, "top");
          }
          if (d['template'] == "GroupBottom" && list.isNotEmpty) {
            //AppStore.print("Addon.radius: ${list.last}");
            Addon.radius(list.last, "bottom");
          }
          list.add(p);
          if (d['template'] == "GroupTop") {
            needNextRoundBorderRadius = true;
          }
        } catch (e, stackTrace) {
          list.add({"flutterType": "Text", "data": "Exception template: $e"});
          //AppStore.print(ret);
          //developer.log(ret);
          AppStore.debug(stackTrace);
        }
      }
      data[ret] = list;
    }
  }

  static dataUpdate(Map<String, dynamic> data, AppStoreData appStoreData, {bool native = true}) {
    appStoreData.setServerResponse(data);

    List<dynamic>? action = data['Actions'];
    if (action != null && action.isNotEmpty) {
      for (Map item in action) {
        DynamicUI.def(item, "method", null, appStoreData, 0, "Data");
      }
    }

    if (data['RevisionState'] != null && data['RevisionState'] != "") {
      appStoreData.setIndexRevisionWithoutReload(data['RevisionState']);
    }
    if (data['WidgetData'] != null && data['WidgetData'] != "") {
      //AppStore.print("SET NEW WIDGET DATA(${data['WidgetData']})");
      appStoreData.addWidgetDataByMap(data['WidgetData']);
    }

    if (data['State'] != null && data['State'] != "") {
      Map<String, dynamic> map = data['State'];
      for (var item in map.entries) {
        appStoreData.set(item.key, item.value, notify: false);
      }
      appStoreData.apply(); //Maybe setState refresh Data on UI?
    }

    dynamic mapBridgeState = appStoreData.getWidgetData("bridgeState");
    if (mapBridgeState != null && mapBridgeState.runtimeType.toString().contains("Map<") && mapBridgeState.isNotEmpty) {
      for (var item in mapBridgeState.entries) {
        appStoreData.set(item.key, item.value, notify: false);
      }
      appStoreData.apply();
    }

    if (native == true && data['SyncSocket'] != null &&
        data['SyncSocket'] == true &&
        (appStoreData.getWidgetData("dataUID") as String).isNotEmpty) {
      appStoreData.setSyncSocket(true);
      WebSocketService().subscribe(appStoreData.getWidgetData("dataUID"));
    }

    parseTemplate(data, "Data", "list");
    parseTemplate(data, "AppBarActions", "actions");
    //AppStore.print(data);

    /*Избежание рекурсивного переопредления _build статуса
     Поймал проблему, когда rebuild -> _build = true,
     но инициатор процесса initPage, в конце определяет build = false
     и на момент setState и повторного build мы не перекомпилируем отображение*/
    Future.delayed(const Duration(milliseconds: 1), () {
      appStoreData.reBuild();
      appStoreData.getPageState()?.setState(() {});
    });

    if (native == true && data['ParentPersonKey'] != null) {
      Future.delayed(Duration(milliseconds: delay), () {
        AppStore.changePersonKey(data['ParentPersonKey']);
      });
    }
  }
}
