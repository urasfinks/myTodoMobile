import 'package:flutter/material.dart';
import 'package:myTODO/DynamicPage/DynamicPageUtil.dart';
import '../AppMetric.dart';
import '../AppStore/GlobalData.dart';
import '../AppStore/PageData.dart';
import '../AppStore/ListPageData.dart';
import '../TabScope.dart';

class DynamicPageWidget extends StatefulWidget {
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
  final bool modalBottom;
  final bool separated;
  final bool grid;
  final dynamic config;
  final dynamic bridgeState;

  const DynamicPageWidget(
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
      this.modalBottom = false,
      this.separated = false,
      this.grid = false,
      this.config,
      this.bridgeState})
      : super(key: key);

  @override
  State<DynamicPageWidget> createState() => DynamicPageWidgetState();

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
        'modalBottom': false,
        'separated': false,
        'grid': false,
        'config': {},
        'bridgeState': {}
      };
      if (data != null && data.isNotEmpty) {
        for (var item in data.entries) {
          if (def.containsKey(item.key)) {
            def[item.key] = item.value;
          }
        }
      }

      DynamicPageWidget ret = DynamicPageWidget(
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
        modalBottom: def['modalBottom'],
        separated: def['separated'],
        grid: def['grid'],
        config: def['config'],
        bridgeState: def['bridgeState'],
      );
      return ret;
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
      return DynamicPageWidget.fromMap(
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

  Future<void> load(PageData pageData, {pause = true, prepareDelay = false}) async {
    if (TabScope.getInstance().iamActivePage(pageData)) {
      //GlobalData.debug("DynamicPage.refresh now: ${url}");
      await DynamicPageUtil.loadData(pageData, pause: pause, prepareDelay: prepareDelay);
    } else {
      //GlobalData.debug("DynamicPage.refresh lazy: ${url}");
      pageData.needUpdateOnActive = true;
    }
  }
}

class DynamicPageWidgetState extends State<DynamicPageWidget> {
  late PageData savePageData;

  @override
  void dispose() {
    //GlobalData.debug("Dispose");
    TabScope.getInstance().onDestroyPage(savePageData);
    ListPageData().remove(savePageData);
    super.dispose();
  }

  Future<void> load({pause = true, prepareDelay = false}) async {
    await widget.load(savePageData, pause: pause, prepareDelay: prepareDelay);
  }

  @override
  Widget build(BuildContext context) {
    //GlobalData.debug("DynamicPageWidget build");
    PageData pageData = ListPageData().createPageData(context);
    pageData.setPageState(this);
    savePageData = pageData;
    pageData.initPage(widget, context);
    return pageData.getCompiledWidget();
  }
}
