import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/AccountPageJsonObject.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class DynamicPageUtil{
  static Widget getFutureBuilder(DynamicPage widget) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getServerData(widget),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Util.getListView(
            snapshot.data!['Separated'] == null || snapshot.data!['Separated'] == true,
            const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            snapshot.data!['list'].length,
                (BuildContext context, int index) {
              return DynamicUI.mainJson(snapshot.data!['list'][index], widget);
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
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return CircularProgressIndicator(
          backgroundColor: FlutterTypeConstant.parseToMaterialColor(widget.progressIndicatorBackgroundColor),
        );
      },
    );
  }

  static Future<Map<String, dynamic>> getServerDataTest(DynamicPage widget) async {
    return AccountPageJsonObject.getPage();
  }

  static Future<Map<String, dynamic>> getServerData(DynamicPage widget) async {
    if(!widget.root){
      await Future.delayed(const Duration(milliseconds: 350), () {
        print("DELAY");
      });
    }
    print('load data');
    try {
      Map<String, String> requestHeaders = {'Authorization': AppStore.personKey};

      final response = await http.post(Uri.parse("${AppStore.host}${widget.url}"), headers: requestHeaders, body: widget.parentState);
      print(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        AppStoreData? store = AppStore().getByName(widget.dataUID);
        bool isUpdate = false;
        if (data['Title'] != null && data['Title'] != "" && store != null) {
          store.set("title", data['Title'], notify: false);
          isUpdate = true;
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
          WebSocket().subscribe(widget.dataUID);
          isUpdate = true;
        }
        if (isUpdate == true && store != null) {
          store.apply();
        }

        List list = [];
        for (dynamic d in data['Data']) {
          String ret = Util.template(d['data'], data['Template'][d['template']]);
          list.add(jsonDecode(ret));
        }
        data['list'] = list;
        return data;
      } else {
        return ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body);
      }
    } catch (e) {
      print(e.toString());
      return ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString());
    }
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