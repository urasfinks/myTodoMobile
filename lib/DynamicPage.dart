import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:test3/AppStore/AppStore.dart';

import 'DynamicUI/FlutterType.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'Util.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage(
      {Key? key, required this.title, required this.url, this.root = false})
      : super(key: key);

  final String title;
  final bool root;
  final String url;

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  Future<Map<String, dynamic>> getServerData() async {
    print('load data');
    try{
      Map<String, String> requestHeaders = {
        'Authorization': AppStore.personKey
      };
      final response = await http.get(Uri.parse(widget.url), headers: requestHeaders);
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode('{"list": [{"flutterType": "Text","data": "Ошибка загрузки"}]}');
      }
    }catch(e){
      return jsonDecode('{"list": [{"flutterType": "Text","data": "${e.toString()}"}]}');
    }
  }

  Widget getFutureBuilder() {
    return FutureBuilder<Map<String, dynamic>>(
      future: getServerData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Util.getListView(
              snapshot.data!['separated'] == null ||
                  snapshot.data!['separated'] == true,
              const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              FlutterType.parseEdgeInsetsGeometry(
                  FlutterType.def(snapshot.data, 'padding', null)),
              snapshot.data!['list'].length, (BuildContext context, int index) {
            return GestureDetector(
              child: FlutterType.mainJson(snapshot.data!['list'][index]),
              onTap: () {
                if (snapshot.data!['list'][index]['url'] != null) {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => DynamicPage(
                        title: 'Soround',
                        url: snapshot.data!['list'][index]['url'],
                        root: false,
                      ),
                    ),
                  );
                }
              },
            );
          }, (BuildContext context, int index) => const Divider());
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: Text(widget.title),
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
          child: getFutureBuilder(),
        ),
      ),
    );
  }
}
