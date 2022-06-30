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

  static Future<void> loadDataTest(DynamicPage widget, BuildContext context) async {
    await Future.delayed(Duration(milliseconds: delay), () {});
    dataUpdate(TextEditRowJsonObject.getPage(), AppStore.getStore(context));
  }

  static Future<void> loadData(DynamicPage widget, BuildContext context) async {
    if (!widget.root) {
      await Future.delayed(Duration(milliseconds: delay), () {});
    }
    print('Load data');
    try {
      Map<String, String> requestHeaders = {'Authorization': AppStore.personKey};

      final response = await http.post(Uri.parse("${AppStore.host}${widget.url}"), headers: requestHeaders, body: widget.parentState);

      print(response.body);
      if (response.statusCode == 200) {
        //print("HERE! FIND: ${widget.dataUID}; FIND: ${AppStore().getByDataUID(widget.dataUID)}");
        dataUpdate(jsonDecode(response.body), AppStore.getStore(context));
      } else {
        dataUpdate(ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body), AppStore.getStore(context));
      }
    } catch (e) {
      print(e);
      dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), AppStore.getStore(context));
    }
  }

  static Widget getFutureBuilder(DynamicPage widget) {
    var appStoreData = AppStore().getByDataUID(widget.dataUID);
    if (appStoreData != null && appStoreData.getServerResponse().isNotEmpty) {
      Map<String, dynamic> snapshot = appStoreData.getServerResponse();
      return Util.getListView(
        snapshot['Separated'] == null || snapshot['Separated'] == true,
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        snapshot['list'].length,
        (BuildContext context, int index) {
          return DynamicUI.mainJson(snapshot['list'][index], widget);
        },
      );
    }
    return CircularProgressIndicator(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(widget.progressIndicatorBackgroundColor),
    );
  }

  static dataUpdate(Map<String, dynamic> data, AppStoreData? store) {
    if(store != null){
      bool isUpdate = false;

      if (data['WidgetData'] != null && data['WidgetData'] != "") {
        store.addWidgetDataByMap(data['WidgetData']);
      }

      if (data['State'] != null && data['State'] != "") {
        Map<String, dynamic> map = data['State'];
        for (var item in map.entries) {
          store.set(item.key, item.value, notify: false);
        }
        isUpdate = true;
      }

      if (data['SyncSocket'] != null && data['SyncSocket'] == true && store != null) {
        store.setSyncSocket(true);
        WebSocket().subscribe(store.getWidgetData("dataUID"));
        isUpdate = true;
      }
      if (isUpdate == true) {
        store.apply();
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
    }else{
      print("ERROR State not found");
    }
  }

  static dynamic openWindow(DynamicPage context, dynamic data) {
    AppStoreData? s = AppStore().getByDataUID(context.dataUID);
    print("openWindow: ${data}");
    if (s != null) {
      Navigator.push(
        s.getCtx()!,
        CupertinoPageRoute(
          builder: (context) => DynamicPage.fromJson(data),
        ),
      );
    }
    return null;
  }

  static Widget test(DynamicPage context) {
    print("YHOOO");
    return Text("Hoho");
  }
}
