import 'package:flutter/material.dart';
import 'package:myTODO/AppStore/AppStore.dart';
import 'package:myTODO/DynamicPage/DynamicPageUtil.dart';
import 'package:myTODO/TabWrap.dart';
import '../AppStore/AppStoreData.dart';

class DynamicPage extends StatefulWidget {
  final String title;
  final bool root;
  final String url;
  final String parentState;
  final String dataUID;
  final String
      wrapPage; //{"flutterType": "Container", "color": "red.600", "padding": "20,0,10,0", "child": "()=>getFutureBuilder"}
  final String pullToRefreshBackgroundColor;
  final String appBarBackgroundColor;
  final String backgroundColor;
  final String progressIndicatorBackgroundColor;
  final String progressIndicatorColor;
  final bool dialog;
  final bool separated;
  final bool grid;
  final dynamic config;

  const DynamicPage(
      {Key? key,
      required this.title,
      required this.url,
      required this.parentState,
      this.root = false,
      this.dataUID = "",
      this.wrapPage = "",
      this.appBarBackgroundColor = "blue.600",
      this.pullToRefreshBackgroundColor = "blue.600",
      this.backgroundColor = "#ffffff",
      this.progressIndicatorBackgroundColor = "transparent",
      this.progressIndicatorColor = "blue.600",
      this.dialog = false,
      this.separated = false,
      this.grid = false,
      this.config})
      : super(key: key);

  @override
  State<DynamicPage> createState() => DynamicPageState();

  static fromMap(Map<String, dynamic>? data) {
    try {
      Map<String, dynamic> def = {
        'title': '',
        'root': false,
        'url': '',
        'parentState': '',
        'dataUID': "",
        'wrapPage': '',
        'pullToRefreshBackgroundColor': 'blue.600',
        'appBarBackgroundColor': 'blue.600',
        'backgroundColor': '#ffffff',
        'progressIndicatorBackgroundColor': 'transparent',
        'progressIndicatorColor': 'blue.600',
        'dialog': false,
        'separated': false,
        'grid': false,
        'config': {}
      };
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
        progressIndicatorColor: def['progressIndicatorColor'],
        pullToRefreshBackgroundColor: def['pullToRefreshBackgroundColor'],
        wrapPage: def['wrapPage'],
        dataUID: def['dataUID'],
        root: def['root'],
        appBarBackgroundColor: def['appBarBackgroundColor'],
        dialog: def['dialog'],
        separated: def['separated'],
        grid: def['grid'],
        config: def['config'],
      );
      return ret;
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return DynamicPage.fromMap(
        {
          "title": 'Ошибка ',
          "url": '/project/system/error',
          "backgroundColor": "blue.600",
          "pullToRefreshBackgroundColor": "blue.600",
          "progressIndicatorBackgroundColor": "#ffffff",
          "root": true,
        },
      );
    }
  }

  void refresh(AppStoreData appStoreData) {
    if (TabScope.getInstance().iamActivePage(appStoreData)) {
      //print("DynamicPage.refresh now: ${url}");
      DynamicPageUtil.loadData(appStoreData);
    } else {
      //print("DynamicPage.refresh lazy: ${url}");
      appStoreData.needUpdateOnActive = true;
    }
  }
}

class DynamicPageState extends State<DynamicPage> {
  AppStoreData? saveStore;

  @override
  void dispose() {
    //print("Dispose");
    if (saveStore != null) {
      TabScope.getInstance().onDestroyPage(saveStore!);
      AppStore().remove(saveStore!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print("DynPage build");
    AppStoreData appStoreData = AppStore.getStore(context);
    appStoreData.setPageState(this);
    saveStore = appStoreData;
    appStoreData.initPage(widget, context);
    return appStoreData.getCompiledWidget();
  }
}
