import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:test3/AppStore/AppStore.dart';
import 'package:test3/DynamicPage/DynamicPageUtil.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/FlutterTypeConstant.dart';

class DynamicPage extends StatefulWidget{
  final String title;
  final bool root;
  final String url;
  final String parentState;
  final String dataUID;
  final String wrapPage;

  const DynamicPage({Key? key, required this.title, required this.url, required this.parentState, this.root = false, this.dataUID = "", this.wrapPage = ""}) : super(key: key);

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  AppStoreData? appStoreData;

  @override
  Widget build(BuildContext context) {
    AppStoreData? s = AppStore.getStore(context, widget.dataUID);
    print("Store: $s; ${widget.url}; ${widget.dataUID}");

    return Scaffold(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor("blue.600"),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: AppStore.connect(widget.dataUID, (store, def) => Text(store != null ? store.get("title", def) : def), defaultValue: widget.title),
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
          /*child: DynamicUI.mainJson({"flutterType": "Container", "color": "red.600", "padding": "20,0,10,0", "child": "():getFutureBuilder"}, widget),*/
          child: widget.wrapPage.isNotEmpty ? DynamicUI.main(widget.wrapPage, widget) : DynamicPageUtil.getFutureBuilder(widget),
        ),
      ),
    );
  }
}
