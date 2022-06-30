import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/TextEditRow/TextEditRowJsonObject.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DynamicPageUtil{

  static Future<void> loadDataTest(DynamicPage widget) async {
    await Future.delayed(const Duration(milliseconds: 350), () {});
    dataUpdate(TextEditRowJsonObject.getPage(), AppStore().getByName(widget.dataUID));
  }

  static dataUpdate(Map<String, dynamic> data, AppStoreData? store){

    bool isUpdate = false;
    if (data['WidgetData'] != null && data['WidgetData'] != "" && store != null) {
      store.addWidgetDataByMap(data['WidgetData']);
    }

    if (data['State'] != null && data['State'] != "" && store != null) {
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
    if (isUpdate == true && store != null) {
      store.apply();
    }

    if(data.containsKey("Data")){
      List list = [];
      for (dynamic d in data['Data']) {
        String ret = Util.template(d['data'], data['Template'][d['template']]);
        list.add(jsonDecode(ret));
      }
      data['list'] = list;
    }

    store?.setServerResponse(data);
    store?.getPageState()?.setState(() {});
  }

  static Future<void> loadData(DynamicPage widget) async {
    if(!widget.root){
      await Future.delayed(const Duration(milliseconds: 350), () {});
    }
    print('Load data');
    try {
      Map<String, String> requestHeaders = {'Authorization': AppStore.personKey};

      final response = await http.post(Uri.parse("${AppStore.host}${widget.url}"), headers: requestHeaders, body: widget.parentState);

      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        dataUpdate(data, AppStore().getByName(widget.dataUID));
      } else {
        AppStore().getByName(widget.dataUID)?.setServerResponse(ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body));
      }
    } catch (e) {
      print(e.toString());
      AppStore().getByName(widget.dataUID)?.setServerResponse(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()));
    }
  }

  static Widget getFutureBuilder(DynamicPage widget) {
    var appStoreData = AppStore().getByName(widget.dataUID);
    if(appStoreData != null && appStoreData.getServerResponse().isNotEmpty){
      //return DynamicUI.mainJson(snapshot.data!['list'][index], widget);
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

  static dynamic openWindow(DynamicPage context, dynamic data){
    AppStoreData? s = AppStore().getByName(context.dataUID);
    if(s != null){
      Navigator.push(
        s.getCtx()!,
        CupertinoPageRoute(
          builder: (context) => DynamicPage.fromJson(data),
        ),
      );
    }
    return null;
  }

  static Widget test(DynamicPage context){
    print("YHOOO");
    return Text("Hoho");
  }
}

/*return GestureDetector(
                child: DynamicUI.mainJson(snapshot.data!['list'][index]),
                onTap: () {
                  if (snapshot.data!['list'][index]['url'] != null) {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => DynamicPage(
                          title: snapshot.data!['list'][index]['title'],
                          url: snapshot.data!['list'][index]['url'],
                          parentState: "",
                        ),
                      ),
                    );
                  }
                },
              );*/