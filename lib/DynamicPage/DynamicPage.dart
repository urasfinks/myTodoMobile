import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:test3/AppStore/AppStore.dart';
import 'package:test3/DynamicPage/DynamicPageUtil.dart';
import 'package:uuid/uuid.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/FlutterTypeConstant.dart';

class DynamicPage extends StatefulWidget {
  final String title;
  final bool root;
  final String url;
  final String parentState;
  final String dataUID;
  final String wrapPage; //{"flutterType": "Container", "color": "red.600", "padding": "20,0,10,0", "child": "()=>getFutureBuilder"}
  final String pullToRefreshBackgroundColor;
  final String appBarBackgroundColor;
  final String backgroundColor;
  final String progressIndicatorBackgroundColor;

  const DynamicPage({Key? key, required this.title, required this.url, required this.parentState, this.root = false, this.dataUID = "", this.wrapPage = "", this.appBarBackgroundColor = "blue.600", this.pullToRefreshBackgroundColor = "blue.600", this.backgroundColor = "#ffffff", this.progressIndicatorBackgroundColor = "blue.600"}) : super(key: key);

  @override
  State<DynamicPage> createState() => _DynamicPageState();

  static fromJson(Map<String, dynamic>? data) {
    Map<String, dynamic> def = {'title': '', 'root': false, 'url': '', 'parentState': '', 'dataUID': const Uuid().v4(), 'wrapPage': '', 'pullToRefreshBackgroundColor': 'blue.600', 'appBarBackgroundColor': 'blue.600', 'backgroundColor': '#ffffff', 'progressIndicatorBackgroundColor': 'blue.600'};
    if (data != null && data.isNotEmpty) {
      for (var item in data.entries) {
        if (def.containsKey(item.key)) {
          def[item.key] = item.value;
        }
      }
    }
    return DynamicPage(
      title: def['title'],
      url: def['url'],
      parentState: def['parentState'],
      backgroundColor: def['backgroundColor'],
      progressIndicatorBackgroundColor: def['progressIndicatorBackgroundColor'],
      pullToRefreshBackgroundColor: def['pullToRefreshBackgroundColor'],
      wrapPage: def['wrapPage'],
      dataUID: def['dataUID'],
      root: def['root'],
      appBarBackgroundColor: def['appBarBackgroundColor'],
    );
  }
}

class _DynamicPageState extends State<DynamicPage> {
  AppStoreData? appStoreData;

  refresh(){
    //DynamicPageUtil.loadDataTest(widget);
    DynamicPageUtil.loadData(widget);
  }

  @override
  void initState() {
    refresh();

    super.initState();
  }

  @override
  void dispose() {
    AppStore().removeByName(widget.dataUID);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStoreData? s = AppStore.getStore(context, widget.dataUID);
    s?.addWidgetDataByPage(widget);
    if (s != null) {
      s.setCtx(context);
      s.setPageState(this);
    }
    print("_DynamicPageState.build() Store: $s; ${widget.url}; ${widget.dataUID}");

    return Scaffold(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(s?.getWidgetData("backgroundColor")), //s?.getWidgetData("")
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FlutterTypeConstant.parseToMaterialColor(s?.getWidgetData("appBarBackgroundColor")),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: Text(s?.getWidgetData("title")),
      ),
      body: Center(
        child: LiquidPullToRefresh(
          color: FlutterTypeConstant.parseToMaterialColor(s?.getWidgetData("pullToRefreshBackgroundColor")),
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          animSpeedFactor: 2,
          height: 90,
          onRefresh: () async {
            AppStore().getByName(widget.dataUID)?.clearState();
            refresh();
          },
          child: s?.getWidgetData("wrapPage").isNotEmpty ? DynamicUI.mainJson(s?.getWidgetData("wrapPage"), widget) : DynamicPageUtil.getFutureBuilder(widget),
        ),
      ),
    );
  }
}
