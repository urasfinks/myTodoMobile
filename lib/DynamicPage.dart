import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:test3/AppStore/AppStore.dart';

import 'AppStore/AppStoreData.dart';
import 'DynamicUI/DynamicUI.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'DynamicUI/FlutterTypeConstant.dart';
import 'WebSocket.dart';

import 'Util.dart';

class DynamicPage extends StatefulWidget {
  final String title;
  final bool root;
  final String url;
  final String parentState;
  final String dataUID;

  const DynamicPage({Key? key, required this.title, required this.url, required this.parentState, this.root = false, this.dataUID = ""}) : super(key: key);

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  AppStoreData? appStoreData;

  Future<Map<String, dynamic>> getServerData() async {
    print('load data');
    try {
      Map<String, String> requestHeaders = {'Authorization': AppStore.personKey};

      final response = await http.post(Uri.parse(widget.url), headers: requestHeaders, body: widget.parentState);
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
        //return jsonDecode('{"list": [{"flutterType": "Text","data": "Ошибка загрузки"}]}');
        return {
          "list": [
            {
              "flutterType": "Center",
              "child": {
                "flutterType": "Column",
                "children": [
                  {
                    "flutterType": "SizedBox",
                    "height": 50
                  },
                  {
                    "flutterType": "Text",
                    "data": "${response.statusCode}",
                    "style": {
                      "flutterType": "TextStyle",
                      "fontStyle": "normal",
                      "fontWeight": "bold",
                      "fontSize": 100,
                      "color": "#ff0000",
                    }
                  },
                  {
                    "flutterType": "Text",
                    "data": "Ошибка загрузки",
                    "style": {
                      "flutterType": "TextStyle",
                      "fontSize": 16,
                      "color": "#ff0000",
                    }
                  },
                  {
                    "flutterType": "SizedBox",
                    "height": 16
                  },
                  {
                    "flutterType": "Padding",
                    "padding": "20,0,20,0",
                    "child": {
                      "flutterType": "Text",
                      "data": "${response.body}",
                      "style": {
                        "flutterType": "TextStyle",
                        "fontSize": 12,
                        "color": "#ff0000",
                      }
                    }
                  }
                ]
              }
            }
          ]
        };
      }
    } catch (e) {
      print(e.toString());
      return jsonDecode('{"list": [{"flutterType": "Text","data": "${e.toString()}"}]}');
    }
  }

  Widget getFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: getServerData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Util.getListView(
            snapshot.data!['Separated'] == null || snapshot.data!['Separated'] == true,
            const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            snapshot.data!['list'].length,
            (BuildContext context, int index) {
              //return FlutterType.mainJson(snapshot.data!['list'][index]);
              return GestureDetector(
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
                          root: false,
                        ),
                      ),
                    );
                  }
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    AppStoreData? s = AppStore.getStore(context, widget.dataUID);
    print("Store: $s; ${widget.url}; ${widget.dataUID}");
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: AppStore.connect(widget.dataUID, (store, def) => Text(store != null ? store.get("title", def) : def), defaultValue: widget.title),
        leading: widget.root == true
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  print("AppBar leading");
                },
              )
            : null,
      ),
      body: Center(
        child: LiquidPullToRefresh(
          color: Colors.blue[600],
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          animSpeedFactor: 2,
          height: 90,
          onRefresh: () async {
            setState(() {});
          },
          child: Container(
            padding: FlutterTypeConstant.parseEdgeInsetsGeometry("10,0,10,0"),
            child: getFutureBuilder(),
          ),
        ),
      ),
    );
  }
}
