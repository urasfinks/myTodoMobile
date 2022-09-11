import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:myTODO/AppStore/PageDataState.dart';
import 'package:myTODO/AppStore/PageDataWidget.dart';
import 'package:myTODO/DynamicPage/DynamicPageWidget.dart';
import '../AppMetric.dart';
import '../DynamicPage/DynamicFn.dart';
import '../DynamicPage/DynamicPageUtil.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/FlutterType.dart';
import '../DynamicUI/TypeParser.dart';
import '../TabScope.dart';
import '../Util.dart';
import '../WebSocket.dart';

import 'GlobalData.dart';

class PageData {
  bool syncSocket;
  late final PageDataWidget pageDataWidget;
  late final PageDataState pageDataState;

  PageData({this.syncSocket = false}) {
    pageDataWidget = PageDataWidget(this);
    pageDataState = PageDataState(this);
  }

  int _indexRevision = 0;
  Map<String, bool> alreadyVisible = {};
  bool needUpdateOnActive = false;
  Widget? compiledWidget;
  bool firstLoad = true;
  Widget wrapPage = const Text("Undefined WrapPage in Templates");
  bool nowDownloadContent = false;
  BuildContext? _ctx;
  DynamicPageWidgetState? pageState;
  Map<String, dynamic> serverResponse = {};
  bool _build = true;
  bool _parentUpdate = false;
  void Function()? _onIndexRevisionError;

  void setIndexRevisionWithoutReload(int index) {
    _indexRevision = index;
  }

  int inactiveTimestamp = 0;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    dynamic refreshOnResume = pageDataWidget.getWidgetData("refreshOnResume");
    //GlobalData.debug("didChangeAppLifecycleState: ${widgetData}");
    /*
    * Если явно установлено, что надо страницу перезагружать при восстановлении
    * Либо если у страницы подняты Socket слушатели, в момент опускания приложения могли поступить обновления, надо их подтянуть перезагрузкой страницы
    * Или время просто достаточно долгое (видел как разваливаются виджеты почемуто, но после оновления всё гуд)
    * */
    bool veryLong =
        state == AppLifecycleState.resumed && inactiveTimestamp > 0 && Util.getTimestamp() - inactiveTimestamp > 300000;
    if (state == AppLifecycleState.resumed &&
        ((refreshOnResume != null && refreshOnResume == true) || syncSocket == true || veryLong == true)) {
      onIndexRevisionError();
    }
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      inactiveTimestamp = Util.getTimestamp();
      WebSocketService().stop();
    }
    if (state == AppLifecycleState.resumed) {
      WebSocketService().start();
    }
  }

  void setPageState(DynamicPageWidgetState x) {
    pageState = x;
  }

  DynamicPageWidgetState? getPageState() {
    return pageState;
  }

  void setCtx(BuildContext value) {
    _ctx = value;
  }

  void setServerResponse(Map<String, dynamic> input) {
    serverResponse = input;
  }

  Map<String, dynamic> getServerResponse() {
    return serverResponse;
  }

  void clearState() {
    pageDataState.clear();
  }

  BuildContext? getCtx() => _ctx;

  void setSyncSocket(bool syncSocket) {
    this.syncSocket = syncSocket;
  }

  void setOnIndexRevisionError(void Function()? fn) {
    _onIndexRevisionError = fn;
  }

  void onIndexRevisionError() {
    if (_onIndexRevisionError != null) {
      Function.apply(_onIndexRevisionError!, []);
    }
  }

  void setIndexRevision(int newValue, {bool checkSequence = true}) {
    //GlobalData.debug("setIndexRevision: ${newValue}; oldValue: ${_indexRevision}");
    if (checkSequence == true) {
      if (_indexRevision == newValue - 1) {
        _indexRevision++;
      } else {
        onIndexRevisionError();
      }
    } else {
      _indexRevision = newValue;
    }
  }

  void onChange(String key, bool notify) {
    //GlobalData.debug("onChange: $key = ${pageDataState.get(key, null)}");
    dynamic x = pageDataWidget.getWidgetDataConfig({"parentRefreshOnChangeStateData": false});
    if (x["parentRefreshOnChangeStateData"] == true) {
      setParentRefresh(true);
    }
    if (notify == true) {
      if (syncSocket) {
        if (WebSocketService().isConnect()) {
          WebSocketService().sendToServer(pageDataWidget.getWidgetData("dataUID"), "UPDATE_STATE",
              data: {"key": key, "value": pageDataState.get(key, null)});
        } else {
          DynamicFn.alert(this, {"backgroundColor": "red", "data": "Нет подключения к серверу"});
        }
      }
    }
  }

  void apply() {
    GlobalData.debug("PageData -> apply");
    reBuild();
    getPageState()?.setState(() {});
  }

  void destroy() {
    if (syncSocket) {
      WebSocketService().unsubscribe(pageDataWidget.getWidgetData("dataUID"));
    }
  }

  Widget getCompiledWidget() {
    if (pageDataWidget.getWidgetData("root") == true && GlobalData.firstStart == true) {
      GlobalData.firstStart = false;
      Map<String, dynamic> conf = {};
      conf["url"] = GlobalData.promo;
      DynamicFn.promo(this, conf);
    }
    //print("GetCompiletWidget");
    return compiledWidget!;
  }

  void reBuild() {
    _build = true;
  }

  void initPage(DynamicPageWidget widget, BuildContext context) {
    try {
      //AppStore.debug("initPage ${widget.url}; _build: ${_build}; compiledWidget: ${compiledWidget}; nowDownloadContent: ${nowDownloadContent}");
      if (_build == true || compiledWidget == null || nowDownloadContent == true) {
        //GlobalData.debug("initPage ${widget.url}");
        setOnIndexRevisionError(() {
          widget.load(this);
        });
        if (firstLoad == true) {
          pageDataWidget.addWidgetDataByPage(widget); //!!!! DON'T REMOVE!!!!!! (Page Load replace this property)
          TabScope.getInstance().addHistory(this);
          widget.load(this);
          firstLoad = false;
        }
        setCtx(context);

        if (getServerResponse().containsKey("Template") &&
            pageDataWidget.getWidgetData("wrapPage").isNotEmpty &&
            (getServerResponse()["Template"] as Map).containsKey(pageDataWidget.getWidgetData("wrapPage"))) {
          wrapPage = DynamicUI.main(
              (getServerResponse()["Template"] as Map)[pageDataWidget.getWidgetData("wrapPage")], this, 0, '');
        }

        BackButton? back = (widget.root == false)
            ? BackButton(
                onPressed: () {
                  TabScope.getInstance().popHistory(null);
                },
              )
            : null;

        if (pageDataWidget.getWidgetData("dialog") == true) {
          createDialog();
        } else {
          createSimplePage(widget, back);
        }
        _build = false;
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
      createErrorCompilation(widget, e.toString());
    }
  }

  createDialog() {
    Map config = pageDataWidget.getWidgetDataConfig({"padding": 0, "elevation": 0.0, "borderRadius": 20, "height": -1});
    bool? withoutListView = pageDataWidget.getWidgetData("WithoutListView");
    if (withoutListView == null) {
      pageDataWidget.widgetData["WithoutListView"] = true;
    }
    Widget ch;
    if (config["height"] == -1) {
      ch = _getContent();
    } else {
      ch = SizedBox(
        height: TypeParser.parseDouble(config["height"]),
        child: Center(
          child: _getContent(),
        ),
      );
    }
    compiledWidget = Dialog(
      backgroundColor: TypeParser.parseColor(
        pageDataWidget.getWidgetData("backgroundColor"),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TypeParser.parseDouble(config["borderRadius"])!),
      ),
      insetPadding: TypeParser.parseEdgeInsets(config["padding"].toString())!,
      elevation: TypeParser.parseDouble(config["elevation"]),
      child: ch,
    );
  }

  createSimplePage(DynamicPageWidget widget, BackButton? back) {
    Map conf = pageDataWidget.getWidgetDataConfig({"gradient": null});
    //GlobalData.debug("AllWidgetData: ${getWidgetData("config")}");
    bool gradient = conf["gradient"] != null;
    //GlobalData.debug("FLAG grad: ${gradient}");
    compiledWidget = Scaffold(
      backgroundColor: gradient == true
          ? Colors.transparent
          : TypeParser.parseColor(
              pageDataWidget.getWidgetData("backgroundColor"),
            ),
      appBar: _getAppBar(back, pageDataWidget.getWidgetData("title")),
      body:  _getContent(),
    );
    /*LiquidPullToRefresh(
        color: TypeParser.parseColor(
          pageDataWidget.getWidgetData("pullToRefreshBackgroundColor"),
        ),
        showChildOpacityTransition: false,
        springAnimationDurationInMilliseconds: 500,
        animSpeedFactor: 2,
        height: 90,
        onRefresh: () async {
          await widget.load(this, pause: false);
        },
        child: _getContent(),
      )*/
    if (gradient == true) {
      //GlobalData.debug("GRAD: ${FlutterType.pLinearGradient(conf["gradient"], this, 0, "")}");
      compiledWidget = Container(
        decoration: BoxDecoration(
          gradient: FlutterType.pLinearGradient(conf["gradient"], this, 0, ""),
        ),
        child: compiledWidget,
      );
    }
  }

  createErrorCompilation(DynamicPageWidget widget, String error) {
    compiledWidget = Scaffold(
      appBar: _getAppBar(null, "Ошибка компиляции"),
      body: LiquidPullToRefresh(
        showChildOpacityTransition: true,
        springAnimationDurationInMilliseconds: 500,
        animSpeedFactor: 2,
        height: 90,
        onRefresh: () async {
          await widget.load(this);
        },
        child: ListView.separated(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Text(error);
          },
          separatorBuilder: (BuildContext context, int index) => Divider(
            height: 1,
            color: TypeParser.parseColor("#f5f5f5")!,
          ),
        ),
      ),
    );
  }

  _getAppBar(BackButton? back, String title) {
    //print("AppBar rebuild");
    //print("!!!${getWidgetData("url")} ${TabScope.getInstance().isBack()}");
    return AppBar(
      leading: back,
      elevation: 0,
      backgroundColor: TypeParser.parseColor(
        pageDataWidget.getWidgetData("appBarBackgroundColor"),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
          statusBarBrightness: Brightness.dark),
      title: !TabScope.getInstance().isBack() || pageDataWidget.getWidgetData("root") == true
          ? Text(
              title,
              style: const TextStyle(fontSize: 19),
            )
          : Transform(
              // you can forcefully translate values left side using Transform
              transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 19),
              ),
            ),
      centerTitle: false,
      actions: DynamicPageUtil.getListAppBarActions(this),
    );
  }

  _getContent() {
    return pageDataWidget.getWidgetData("wrapPage").isNotEmpty ? wrapPage : DynamicFn.getFutureBuilder(this, null);
    //return DynamicFn.getFutureBuilder(this, null);
  }

  void setParentRefresh(bool upd) {
    _parentUpdate = upd;
  }

  bool getParentUpdate() {
    return _parentUpdate;
  }

  @override
  String toString() {
    return 'AppStoreData{url: ${pageDataWidget.widgetData["url"]}';
  }
}
