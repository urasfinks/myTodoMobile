import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:test3/AppStore/AppStore.dart';
import 'package:test3/DynamicPage/DynamicPageUtil.dart';
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
  State<DynamicPage> createState() => DynamicPageState();

  static fromMap(Map<String, dynamic>? data) {
    Map<String, dynamic> def = {'title': '', 'root': false, 'url': '', 'parentState': '', 'dataUID': "", 'wrapPage': '', 'pullToRefreshBackgroundColor': 'blue.600', 'appBarBackgroundColor': 'blue.600', 'backgroundColor': '#ffffff', 'progressIndicatorBackgroundColor': 'blue.600'};
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

  void refresh(AppStoreData appStoreData){
    //DynamicPageUtil.loadDataTest(this);
    DynamicPageUtil.loadData(this, appStoreData);
  }

}

class DynamicPageState extends State<DynamicPage> {

  @override
  void dispose() {
    print("Dispose");
    if(widget.dataUID.isNotEmpty){
      AppStore().removeByDataUID(widget.dataUID);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppStoreData appStoreData = AppStore.getStore(context);
    appStoreData.setOnIndexRevisionError(() {
      widget.refresh(appStoreData);
    });
    if(appStoreData.getWidgetDates().isEmpty){ //Only first initialization
      appStoreData.addWidgetDataByPage(widget); //!!!! DON'T REMOVE!!!!!! (Page Load replace this property)
      widget.refresh(appStoreData);
    }
    print("Build CTX: ${context.hashCode}; WidgetData: ${appStoreData.getWidgetDates()}");
    appStoreData.setCtx(context);
    appStoreData.setPageState(this);

    dynamic wrapPage = const Text("Undefined WrapPage in Templates");
    if (
      appStoreData.getServerResponse().containsKey("Template")
      && appStoreData.getWidgetData("wrapPage").isNotEmpty
      && (appStoreData.getServerResponse()["Template"] as Map).containsKey(appStoreData.getWidgetData("wrapPage"))
    ) {
      wrapPage = DynamicUI.main((appStoreData.getServerResponse()["Template"] as Map)[appStoreData.getWidgetData("wrapPage")], appStoreData);
    }

    return Scaffold(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(appStoreData.getWidgetData("backgroundColor")), //s?.getWidgetData("")
      appBar: AppBar(
        elevation: 0,
        backgroundColor: FlutterTypeConstant.parseToMaterialColor(appStoreData.getWidgetData("appBarBackgroundColor")),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: Text(appStoreData.getWidgetData("title")),
      ),
      body: Center(
        child: LiquidPullToRefresh(
          color: FlutterTypeConstant.parseToMaterialColor(appStoreData.getWidgetData("pullToRefreshBackgroundColor")),
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          animSpeedFactor: 2,
          height: 90,
          onRefresh: () async {
            AppStore.getStore(context).clearState();
            widget.refresh(appStoreData);
          },
          child: appStoreData.getWidgetData("wrapPage").isNotEmpty ? wrapPage : DynamicPageUtil.getFutureBuilder(appStoreData),
        ),
      ),
    );
  }
}
