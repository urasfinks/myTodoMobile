import 'package:flutter/cupertino.dart';
import 'package:test3/DynamicUI/Addon.dart';
import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import 'package:flutter/material.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/TextEditRowJsonObject.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8, base64, jsonEncode, jsonDecode;
import 'dart:async';

class DynamicPageUtil {
  static int delay = 350;

  static Future<void> loadDataTest(DynamicPage widget, AppStoreData appStoreData) async {
    await Future.delayed(Duration(milliseconds: delay), () {});
    dataUpdate(TextEditRowJsonObject.getPage(), appStoreData);
  }

  static Future<void> loadData(AppStoreData appStoreData) async {
    appStoreData.nowDownloadContent = true;
    if (!appStoreData.getWidgetData('root')) {
      await Future.delayed(Duration(milliseconds: delay), () {});
    }
    print('Prepare download: ${appStoreData.getWidgetDates()}');
    try {
      String encoded = base64.encode(utf8.encode("PersonKey:${AppStore.personKey}"));
      Map<String, String> requestHeaders = {'Authorization': "Basic $encoded"};

      final response = await http.post(Uri.parse("${AppStore.host}${appStoreData.getWidgetData('url')}"),
          headers: requestHeaders, body: appStoreData.getWidgetData('parentState'));

      //print(response.body);
      if (response.statusCode == 200) {
        dataUpdate(jsonDecode(response.body), appStoreData);
      } else {
        dataUpdate(
            ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body), appStoreData);
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), appStoreData);
    }
    appStoreData.nowDownloadContent = false;
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
      print(e);
      print(stacktrace);
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
          //print(data['Template'][d['template']]);
          ret = Util.template(d['data'], data['Template'][d['template']]);
          //print(ret);
        } else {
          ret = jsonEncode({"flutterType": "Text", "data": "Undefined Template: ${d['template']}"});
        }
        try {
          dynamic p = jsonDecode(ret);
          if (needNextRoundBorderRadius == true) {
            needNextRoundBorderRadius = false;
            Addon.radius(p, "top");
          }
          if (d['template'] == "GroupBottom") {
            Addon.radius(list.last, "bottom");
          }
          list.add(p);
          if (d['template'] == "GroupTop") {
            needNextRoundBorderRadius = true;
          }
        } catch (e, stackTrace) {
          list.add({"flutterType": "Text", "data": "Exception template: ${e}"});
          //print(ret);
          //developer.log(ret);
          print(stackTrace);
        }
      }
      data[ret] = list;
    }
  }



  static dataUpdate(Map<String, dynamic> data, AppStoreData appStoreData) {
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
      //print("SET NEW WIDGET DATA(${data['WidgetData']})");
      appStoreData.addWidgetDataByMap(data['WidgetData']);
    }

    if (data['State'] != null && data['State'] != "") {
      Map<String, dynamic> map = data['State'];
      for (var item in map.entries) {
        appStoreData.set(item.key, item.value, notify: false);
      }
      appStoreData.apply(); //Maybe setState refresh Data on UI?
    }
    if (data['SyncSocket'] != null &&
        data['SyncSocket'] == true &&
        (appStoreData.getWidgetData("dataUID") as String).isNotEmpty) {
      appStoreData.setSyncSocket(true);
      WebSocket().subscribe(appStoreData.getWidgetData("dataUID"));
    }

    parseTemplate(data, "Data", "list");
    parseTemplate(data, "AppBarActions", "actions");
    //print(data);
    appStoreData.setServerResponse(data);
    appStoreData.reBuild();
    appStoreData.getPageState()?.setState(() {});
  }
}
