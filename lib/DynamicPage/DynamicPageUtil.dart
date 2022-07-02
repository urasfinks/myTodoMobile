import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/TextEditRowJsonObject.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DynamicPageUtil {
  static int delay = 350;

  static Future<void> loadDataTest(DynamicPage widget, AppStoreData appStoreData) async {
    await Future.delayed(Duration(milliseconds: delay), () {});
    dataUpdate(TextEditRowJsonObject.getPage(), appStoreData);
  }

  static Future<void> loadData(DynamicPage widget, AppStoreData appStoreData) async {
    if (!widget.root) {
      await Future.delayed(Duration(milliseconds: delay), () {});
    }
    print('Load data');
    try {
      Map<String, String> requestHeaders = {'Authorization': AppStore.personKey};

      final response = await http.post(Uri.parse("${AppStore.host}${widget.url}"), headers: requestHeaders, body: widget.parentState);

      print(response.body);
      if (response.statusCode == 200) {
        dataUpdate(jsonDecode(response.body), appStoreData);
      } else {
        dataUpdate(ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body), appStoreData);
      }
    } catch (e) {
      print(e);
      dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), appStoreData);
    }
  }

  static Widget getFutureBuilder(AppStoreData appStoreData) {
    if (appStoreData.getServerResponse().isNotEmpty) {
      Map<String, dynamic> snapshot = appStoreData.getServerResponse();
      return Util.getListView(
        snapshot['Separated'] == null || snapshot['Separated'] == true,
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        snapshot['list'].length,
            (BuildContext context, int index) {
          return DynamicUI.mainJson(snapshot['list'][index], appStoreData);
        },
      );
    }
    return CircularProgressIndicator(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(appStoreData.getWidgetData("progressIndicatorBackgroundColor")),
    );
  }

  static dataUpdate(Map<String, dynamic> data, AppStoreData store) {

    if (data['Actions'] != null && data['Actions'] != "") {

    }

    if (data['WidgetData'] != null && data['WidgetData'] != "") {
      //print("SET NEW WIDGET DATA(${data['WidgetData']})");
      store.addWidgetDataByMap(data['WidgetData']);
    }

    if (data['State'] != null && data['State'] != "") {
      Map<String, dynamic> map = data['State'];
      for (var item in map.entries) {
        store.set(item.key, item.value, notify: false);
      }
      store.apply(); //Maybe setState refresh Data on UI?
    }

    if (data['SyncSocket'] != null && data['SyncSocket'] == true && (store.getWidgetData("dataUID") as String).isNotEmpty) {
      store.setSyncSocket(true);
      WebSocket().subscribe(store.getWidgetData("dataUID"));
    }

    if (data.containsKey("Data")) {
      List list = [];
      Map<String, dynamic> template = data['Template'];
      for (dynamic d in data['Data']) {
        String ret;
        if (template.containsKey(d['template'])) {
          ret = Util.template(d['data'], data['Template'][d['template']]);
          //print(ret);
        } else {
          ret = jsonEncode({"flutterType": "Text", "data": "Undefined Template: ${d['template']}"});
        }
        list.add(jsonDecode(ret));
      }
      data['list'] = list;
    }
    store.setServerResponse(data);
    store.getPageState()?.setState(() {});
  }

  static dynamic openWindow(AppStoreData appStoreData, dynamic data) {
    String st = appStoreData.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    print("openWindow: ${data}");
    Navigator.push(
      appStoreData.getCtx()!,
      CupertinoPageRoute(
        builder: (context) => DynamicPage.fromMap(data),
      ),
    );
    return null;
  }

  static Widget test(AppStoreData appStoreData) {
    print("YHOOO");
    return Text("Hoho");
  }
}
