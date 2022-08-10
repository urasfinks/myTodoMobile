import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:myTODO/DynamicPage/DynamicPage.dart';
import '../DynamicPage/DynamicFn.dart';
import '../DynamicPage/DynamicPageUtil.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/FlutterType.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import '../TabWrap.dart';
import '../WebSocket.dart';
import 'package:redux/redux.dart';

class AppStoreData {
  bool syncSocket;
  final Store store;
  final Map<String, dynamic> _map = {};
  int _indexRevision = 0;

  AppStoreData(this.store, {this.syncSocket = false});

  bool needUpdateOnActive = false;

  void setIndexRevisionWithoutReload(int index) {
    _indexRevision = index;
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    dynamic refreshOnResume = getWidgetData("refreshOnResume");
    //print("didChangeAppLifecycleState: ${widgetData}");
    if (refreshOnResume != null && refreshOnResume == true && state == AppLifecycleState.resumed) {
      onIndexRevisionError();
    }
  }

  BuildContext? _ctx;
  Map<String, TextEditingController> listController = {};
  State? pageState;

  Map<String, dynamic> widgetData = {};

  String getStringStoreState() {
    if (_map.isNotEmpty) {
      return jsonEncode(_map);
    }
    return "";
  }

  void addWidgetDataByMap(Map<String, dynamic> obj) {
    for (var item in obj.entries) {
      if (item.key != "dataUID") {
        addWidgetData(item.key, item.value);
      }
    }
    /*for (var item in widgetData.entries) {
      if (obj.containsKey(item.key) && item.key != "dataUID") {
        //dataUID final by addWidgetDataByPage
        addWidgetData(item.key, obj[item.key]);
      }
    }*/
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
  }

  void addWidgetData(String key, dynamic value) {
    //print("addWidgetData(${key}) = ${value}");
    widgetData[key] = value;
    if (key == "parentRefresh") {
      try {
        setParentRefresh(value);
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
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
    return widgetData[key];
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
    for(var item in listController.entries){
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
    //print("setIndexRevision: ${newValue}; oldValue: ${_indexRevision}");
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
    //print("Set: $key = $value");
    _map[key] = value;
    onChange(key, notify);
  }

  void join(String key, String appendString, {bool notify = true}) {
    _map[key] = _map[key] + appendString;
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
        WebSocket().send(getWidgetData("dataUID"), "UPDATE_STATE", data: {"key": key, "value": _map[key]});
      }
    }
  }

  void apply() {
    //print("apply");
    store.dispatch(null);
  }

  void destroy() {
    if (syncSocket) {
      WebSocket().unsubscribe(getWidgetData("dataUID"));
    }
  }

  Widget getCompiledWidget() {
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
      //print("initPage ${widget.url}; _build: ${_build}; compiledWidget: ${compiledWidget}; nowDownloadContent: ${nowDownloadContent}");
      if (_build == true || compiledWidget == null || nowDownloadContent == true) {
        print("initPage ${widget.url}");
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
        if (getWidgetData("dialog") == false) {
          Map conf = getWidgetDataConfig({"gradient": null});
          //print("AllWidgetData: ${getWidgetData("config")}");
          bool gradient = conf["gradient"] != null;
          //print("FLAG grad: ${gradient}");
          compiledWidget = Scaffold(
            backgroundColor: gradient == true
                ? Colors.transparent
                : FlutterTypeConstant.parseColor(
                    getWidgetData("backgroundColor"),
                  ),
            appBar: AppBar(
              leading: back,
              elevation: 0,
              backgroundColor: FlutterTypeConstant.parseColor(
                getWidgetData("appBarBackgroundColor"),
              ),
              systemOverlayStyle: const SystemUiOverlayStyle(
                  statusBarColor: Colors.transparent, // Status bar
                  statusBarBrightness: Brightness.dark),
              title: Text(
                getWidgetData("title"),
              ),
              actions: DynamicPageUtil.getListAppBarActions(this),
            ),
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
                    clearState();
                    widget.refresh(this);
                  },
                  child: _contentBuilder(wrapPage),
                ),
              ),
            ),
          );
          if (gradient == true) {
            /*compiledWidget = Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.5, 0.5],
                colors: [Colors.blue[600]!, Colors.white],
              ),
            ),
            child: compiledWidget,
          );*/
            //print("GRAD: ${FlutterType.pLinearGradient(conf["gradient"], this, 0, "")}");
            compiledWidget = Container(
              decoration: BoxDecoration(
                gradient: FlutterType.pLinearGradient(conf["gradient"], this, 0, ""),
              ),
              child: compiledWidget,
            );
          }
        } else {
          Map config = getWidgetDataConfig({"padding": 160, "elevation": 0.0, "borderRadius": 20, "height": 70});
          compiledWidget = Dialog(
            backgroundColor: FlutterTypeConstant.parseColor(
              getWidgetData("backgroundColor"),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FlutterTypeConstant.parseDouble(config["borderRadius"])!),
            ),
            insetPadding: FlutterTypeConstant.parseEdgeInsets(config["padding"].toString())!,
            elevation: FlutterTypeConstant.parseDouble(config["elevation"]),
            child: SizedBox(
              height: FlutterTypeConstant.parseDouble(config["height"]),
              child: Center(
                child: _contentBuilder(wrapPage),
              ),
            ),
          );
        }
        _build = false;
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      compiledWidget = Scaffold(
        appBar: AppBar(
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent, // Status bar
              statusBarBrightness: Brightness.dark),
          title: const Text(
            "Ошибка компиляции",
          ),
        ),
        body: SafeArea(
          child: Center(
            child: LiquidPullToRefresh(
              showChildOpacityTransition: false,
              springAnimationDurationInMilliseconds: 500,
              animSpeedFactor: 2,
              height: 90,
              onRefresh: () async {
                clearState();
                widget.refresh(this);
              },
              child: ListView.separated(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index) {
                  return Text(e.toString());
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
