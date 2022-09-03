import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:myTODO/DynamicPage/DynamicPage.dart';
import '../AppMetric.dart';
import '../DynamicPage/DynamicFn.dart';
import '../DynamicPage/DynamicPageUtil.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/FlutterType.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import '../TabScope.dart';
import '../Util.dart';
import '../WebSocket.dart';
import 'package:redux/redux.dart';

import 'AppStore.dart';

class AppStoreData {
  bool syncSocket;
  final Store store;
  final Map<String, dynamic> _map = {};
  int _indexRevision = 0;

  Map<String, bool> alreadyVisible = {};

  AppStoreData(this.store, {this.syncSocket = false});

  bool needUpdateOnActive = false;

  void setIndexRevisionWithoutReload(int index) {
    _indexRevision = index;
  }

  int inactiveTimestamp = 0;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    dynamic refreshOnResume = getWidgetData("refreshOnResume");
    //AppStore.print("didChangeAppLifecycleState: ${widgetData}");
    /*
    * Если явно установлено, что надо страницу перезагружать при восстановлении
    * Либо если у страницы подняты Socket слушатели, в момент опускания приложения могли поступить обновления, надо их подтянуть перезагрузкой страницы
    * Или время просто достаточно долгое (видел как разваливаются виджеты почемуто, но после оновления всё гуд)
    * */
    bool veryLong = state == AppLifecycleState.resumed && inactiveTimestamp > 0 && Util.getTimestamp() - inactiveTimestamp > 300000;
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

  BuildContext? _ctx;
  Map<String, TextEditingController> listController = {};
  State? pageState;

  Map<String, dynamic> widgetData = {};

  String getStringStoreState() {
    if (_map.isNotEmpty) {
      Map<String, dynamic> mapRet = {};
      for (var item in _map.entries) {
        if(!item.key.startsWith("_")){
          mapRet[item.key] = item.value;
        }
      }
      return jsonEncode(mapRet);
    }
    return "";
  }

  void addWidgetDataByMap(Map<String, dynamic> obj) {
    for (var item in obj.entries) {
      if (item.key != "dataUID") {
        addWidgetData(item.key, item.value);
      }
    }
  }

  void addWidgetDataByPage(DynamicPage widget) {
    addWidgetData("title", widget.title);
    addWidgetData("root", widget.root);
    addWidgetData("url", widget.url);
    addWidgetData("parentState", widget.parentState);
    addWidgetData("dataUID", widget.dataUID);
    addWidgetData("wrapPage", widget.wrapPage);
    addWidgetData("pullToRefreshBackgroundColor", widget.pullToRefreshBackgroundColor);
    addWidgetData("appBarBackgroundColor", widget.appBarBackgroundColor);
    addWidgetData("backgroundColor", widget.backgroundColor);
    addWidgetData("progressIndicatorBackgroundColor", widget.progressIndicatorBackgroundColor);
    addWidgetData("progressIndicatorColor", widget.progressIndicatorColor);
    addWidgetData("dialog", widget.dialog);
    addWidgetData("separated", widget.separated);
    addWidgetData("grid", widget.grid);
    addWidgetData("config", widget.config);
    addWidgetData("bridgeState", widget.bridgeState);
  }

  void addWidgetData(String key, dynamic value) {
    //AppStore.print("addWidgetData(${key}) = ${value}");
    widgetData[key] = value;
    if (key == "parentRefresh") {
      try {
        setParentRefresh(value);
      } catch (e, stacktrace) {
        AppMetric().exception(e, stacktrace);
      }
    }
  }

  Map<String, dynamic> getWidgetDates() {
    return widgetData;
  }

  void setWidgetDataConfig(String key, dynamic value) {
    dynamic x = widgetData["config"];
    x[key] = value;
  }

  dynamic getWidgetDataConfig(Map<String, dynamic> def) {
    dynamic x = widgetData["config"];
    if (x != null && x.runtimeType.toString().contains("Map")) {
      for (var item in x.entries) {
        def[item.key] = item.value;
      }
    }
    return def;
  }

  dynamic getWidgetData(String key) {
    return widgetData.containsKey(key) ? widgetData[key] : null;
  }

  void setPageState(State x) {
    pageState = x;
  }

  State? getPageState() {
    return pageState;
  }

  void setCtx(BuildContext value) {
    _ctx = value;
  }

  Map<String, dynamic> serverResponse = {};

  void setServerResponse(Map<String, dynamic> input) {
    serverResponse = input;
  }

  Map<String, dynamic> getServerResponse() {
    return serverResponse;
  }

  void clearState() {
    _map.clear();
    listController.clear();
  }

  void unFocusTextController() {
    for (var item in listController.entries) {
      item.value.clear();
    }
  }

  TextEditingController? getTextController(String key, String def) {
    if (!listController.containsKey(key)) {
      TextEditingController textController = TextEditingController();
      if (_map.containsKey(key) && _map[key] != null) {
        textController.text = _map[key];
      } else {
        textController.text = def;
      }
      listController[key] = textController;
      return textController;
    } else {
      return listController[key];
    }
  }

  BuildContext? getCtx() => _ctx;

  void setSyncSocket(bool syncSocket) {
    this.syncSocket = syncSocket;
  }

  void Function()? _onIndexRevisionError;

  void setOnIndexRevisionError(void Function()? fn) {
    _onIndexRevisionError = fn;
  }

  void onIndexRevisionError() {
    if (_onIndexRevisionError != null) {
      Function.apply(_onIndexRevisionError!, []);
    }
  }

  void setIndexRevision(int newValue, {bool checkSequence = true}) {
    //AppStore.print("setIndexRevision: ${newValue}; oldValue: ${_indexRevision}");
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

  dynamic get(String key, dynamic defValue) {
    if (_map[key] == null) {
      _map[key] = defValue;
    }
    return _map[key];
  }

  void set(String key, dynamic value, {bool notify = true}) {
    //AppStore.print("Set: $key = $value");
    _map[key] = value;
    onChange(key, notify);
  }

  void join(String key, String appendString, {bool notify = true}) {
    if (_map[key] == null) {
      _map[key] = "";
    }
    _map[key] = _map[key] + Util.template(_map, appendString);
    onChange(key, notify);
  }

  void inc(String key,
      {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
    _map[key] = double.parse("${_map[key]}") + step;
    if (_map[key] < min) {
      _map[key] = min;
    }
    if (_map[key] > max) {
      _map[key] = max;
    }
    _map[key] = (_map[key]).toStringAsFixed(fixed);
    onChange(key, notify);
  }

  void dec(String key,
      {double step = 1.0, double min = -999.0, double max = 999.0, int fixed = 0, bool notify = true}) {
    _map[key] = double.parse("${_map[key]}") - step;
    if (_map[key] < min) {
      _map[key] = min;
    }
    if (_map[key] > max) {
      _map[key] = max;
    }
    _map[key] = (_map[key]).toStringAsFixed(fixed);
    onChange(key, notify);
  }

  void toggle(String key, {bool notify = true}) {
    String x = "${_map[key]}".toLowerCase();
    if (x == "true" || x == "1") {
      _map[key] = true;
    } else {
      _map[key] = false;
    }
    onChange(key, notify);
  }

  void onChange(String key, bool notify) {
    dynamic x = getWidgetDataConfig({"parentRefreshOnChangeStateData": false});
    if (x["parentRefreshOnChangeStateData"] == true) {
      setParentRefresh(true);
    }
    if (notify == true) {
      if (syncSocket) {
        WebSocketService()
            .sendToServer(getWidgetData("dataUID"), "UPDATE_STATE", data: {"key": key, "value": _map[key]});
      }
    }
  }

  void apply() {
    //AppStore.print("apply");
    store.dispatch(null);
  }

  void destroy() {
    if (syncSocket) {
      WebSocketService().unsubscribe(getWidgetData("dataUID"));
    }
  }

  Widget getCompiledWidget() {
    if (getWidgetData("root") == true && AppStore.firstStart == true) {
      AppStore.firstStart = false;
      Map<String, dynamic> conf = {};
      conf["url"] = AppStore.promo;
      DynamicFn.promo(this, conf);
    }
    return compiledWidget!;
  }

  bool _build = true;

  void reBuild() {
    _build = true;
  }

  Widget? compiledWidget;
  bool firstLoad = true;
  Widget wrapPage = const Text("Undefined WrapPage in Templates");
  bool nowDownloadContent = false;

  void initPage(DynamicPage widget, BuildContext context) {
    try {
      //AppStore.debug("initPage ${widget.url}; _build: ${_build}; compiledWidget: ${compiledWidget}; nowDownloadContent: ${nowDownloadContent}");
      if (_build == true || compiledWidget == null || nowDownloadContent == true) {
        //AppStore.print("initPage ${widget.url}");
        setOnIndexRevisionError(() {
          widget.refresh(this);
        });
        if (firstLoad == true) {
          addWidgetDataByPage(widget); //!!!! DON'T REMOVE!!!!!! (Page Load replace this property)
          TabScope.getInstance().addHistory(this);
          widget.refresh(this);
          firstLoad = false;
        }
        setCtx(context);

        if (getServerResponse().containsKey("Template") &&
            getWidgetData("wrapPage").isNotEmpty &&
            (getServerResponse()["Template"] as Map).containsKey(getWidgetData("wrapPage"))) {
          wrapPage = DynamicUI.main((getServerResponse()["Template"] as Map)[getWidgetData("wrapPage")], this, 0, '');
        }

        BackButton? back = (widget.root == false)
            ? BackButton(
                onPressed: () {
                  TabScope.getInstance().popHistory(null);
                },
              )
            : null;
        if (getWidgetData("dialog") == true) {
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
    Map config = getWidgetDataConfig({"padding": 160, "elevation": 0.0, "borderRadius": 20, "height": 70});
    Widget ch;
    if (config["height"] == -1) {
      ch = _contentBuilder(wrapPage);
    } else {
      ch = SizedBox(
        height: FlutterTypeConstant.parseDouble(config["height"]),
        child: Center(
          child: _contentBuilder(wrapPage),
        ),
      );
    }
    compiledWidget = Dialog(
      backgroundColor: FlutterTypeConstant.parseColor(
        getWidgetData("backgroundColor"),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FlutterTypeConstant.parseDouble(config["borderRadius"])!),
      ),
      insetPadding: FlutterTypeConstant.parseEdgeInsets(config["padding"].toString())!,
      elevation: FlutterTypeConstant.parseDouble(config["elevation"]),
      child: ch,
    );
  }

  createSimplePage(DynamicPage widget, BackButton? back) {
    Map conf = getWidgetDataConfig({"gradient": null});
    //AppStore.print("AllWidgetData: ${getWidgetData("config")}");
    bool gradient = conf["gradient"] != null;
    //AppStore.print("FLAG grad: ${gradient}");
    compiledWidget = Scaffold(
      backgroundColor: gradient == true
          ? Colors.transparent
          : FlutterTypeConstant.parseColor(
              getWidgetData("backgroundColor"),
            ),
      appBar: _getAppBar(back, getWidgetData("title")),
      body: SafeArea(
        child: Center(
          child: LiquidPullToRefresh(
            color: FlutterTypeConstant.parseColor(
              getWidgetData("pullToRefreshBackgroundColor"),
            ),
            showChildOpacityTransition: false,
            springAnimationDurationInMilliseconds: 500,
            animSpeedFactor: 2,
            height: 90,
            onRefresh: () async {
              widget.refresh(this);
            },
            child: _contentBuilder(wrapPage),
          ),
        ),
      ),
    );
    if (gradient == true) {
      //AppStore.print("GRAD: ${FlutterType.pLinearGradient(conf["gradient"], this, 0, "")}");
      compiledWidget = Container(
        decoration: BoxDecoration(
          gradient: FlutterType.pLinearGradient(conf["gradient"], this, 0, ""),
        ),
        child: compiledWidget,
      );
    }
  }

  createErrorCompilation(DynamicPage widget, String error) {
    compiledWidget = Scaffold(
      appBar: _getAppBar(null, "Ошибка компиляции"),
      body: SafeArea(
        child: Center(
          child: LiquidPullToRefresh(
            showChildOpacityTransition: false,
            springAnimationDurationInMilliseconds: 500,
            animSpeedFactor: 2,
            height: 90,
            onRefresh: () async {
              widget.refresh(this);
            },
            child: ListView.separated(
              itemCount: 1,
              itemBuilder: (BuildContext context, int index) {
                return Text(error);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 1,
                color: FlutterTypeConstant.parseColor("#f5f5f5")!,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getAppBar(BackButton? back, String title) {
    //print("!!!${getWidgetData("url")} ${TabScope.getInstance().isBack()}");
    return AppBar(
      leading: back,
      elevation: 0,
      backgroundColor: FlutterTypeConstant.parseColor(
        getWidgetData("appBarBackgroundColor"),
      ),
      systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
          statusBarBrightness: Brightness.dark),
      title: !TabScope.getInstance().isBack() || getWidgetData("root") == true
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

  _contentBuilder(dynamic wrapPage) {
    return getWidgetData("wrapPage").isNotEmpty ? wrapPage : DynamicFn.getFutureBuilder(this, null);
  }

  bool _parentUpdate = false;

  void setParentRefresh(bool upd) {
    _parentUpdate = upd;
  }

  bool getParentUpdate() {
    return _parentUpdate;
  }

  @override
  String toString() {
    return 'AppStoreData{url: ${widgetData["url"]}';
  }
}
