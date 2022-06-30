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

    DynamicPage ret = DynamicPage(
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
    return ret;
  }

  void refresh(BuildContext context){
    //DynamicPageUtil.loadDataTest(this);
    DynamicPageUtil.loadData(this, context);
  }

}

class _DynamicPageState extends State<DynamicPage> {

  @override
  void dispose() {
    print("Dispose");
    AppStore().removeByDataUID(widget.dataUID);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStoreData s = AppStore.getStore(context);
    //print("Context: ${context.hashCode}");
    if(s.getWidgetDates().isEmpty){ //Only first initialization
      s.addWidgetDataByPage(widget);
      widget.refresh(context);
    }
    s.addWidgetData("dataUID", widget.dataUID);
    //print("HCC:${context.hashCode}; HCS:${s.hashCode}; ${s?.getWidgetDates()}");
    s.setCtx(context);
    s.setPageState(this);

    //print("_DynamicPageState.build() Store: $s; ${widget.url}; ${widget.dataUID}; WidgetData: ${s.getWidgetDates()}");
    dynamic wrapPage = const Text("Undefined WrapPage in Templates");
    if (
      s.getServerResponse().containsKey("Template")
      && s.getWidgetData("wrapPage").isNotEmpty
      && (s.getServerResponse()["Template"] as Map).containsKey(s.getWidgetData("wrapPage"))
    ) {
      wrapPage = DynamicUI.main((s.getServerResponse()["Template"] as Map)[s.getWidgetData("wrapPage")], widget);
    }

    return Scaffold(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(s.getWidgetData("backgroundColor")), //s?.getWidgetData("")
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FlutterTypeConstant.parseToMaterialColor(s.getWidgetData("appBarBackgroundColor")),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: Text(s.getWidgetData("title")),
      ),
      body: Center(
        child: LiquidPullToRefresh(
          color: FlutterTypeConstant.parseToMaterialColor(s.getWidgetData("pullToRefreshBackgroundColor")),
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          animSpeedFactor: 2,
          height: 90,
          onRefresh: () async {
            AppStore().getByDataUID(widget.dataUID)?.clearState();
            widget.refresh(context);
          },
          child: s.getWidgetData("wrapPage").isNotEmpty ? wrapPage : DynamicPageUtil.getFutureBuilder(widget),
        ),
      ),
    );
  }
}
