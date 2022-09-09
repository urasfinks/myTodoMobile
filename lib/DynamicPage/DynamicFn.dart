import 'package:flutter/cupertino.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myTODO/DynamicPage/DynamicDirective.dart';
import 'package:myTODO/DynamicPage/DynamicPageUtil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../AppMetric.dart';
import '../AppStore/GlobalData.dart';
import '../AppStore/PageData.dart';
import '../AppStore/ListPageData.dart';
import '../DynamicUI/DynamicUI.dart';
import '../TabScope.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_share/flutter_share.dart';

class DynamicFn {
  static int delay = 350;

  static dynamic parseUtilFunction(String value) {
    Map<String, Function> map = {
      "getFutureBuilder": getFutureBuilder,
      "getFutureList": getFutureList,
      "test": test,
      "openWindow": openWindow,
      "closeWindow": closeWindow,
      "reloadPageByUrl": reloadPageByUrl,
      "openDialog": openDialog,
      "openGallery": openGallery,
      "alert": alert,
      "confirm": confirm,
      "getAppStore": getAppStore,
      "setAppStore": setAppStore,
      "joinAppStoreData": joinAppStoreData,
      "appStoreOperator": appStoreOperator,
      "getMD5": getMD5,
      "launcher": launcher,
      "resetTextFieldValue": resetTextFieldValue,
      "timestampToDate": DynamicDirective.timestampToDate,
      "formatNumber": DynamicDirective.formatNumber,
      "copyToClipBoard": copyToClipBoard,
      "share": share,
      "promo": promo,
      "selectTab": selectTab,
    };
    if (map.containsKey(value)) {
      return map[value];
    }
    return null;
  }

  static bool isTextFunction(dynamic value) {
    if (value != null &&
        value.runtimeType.toString() == "String" &&
        (value.toString().startsWith(":") || value.toString().startsWith("=>")) &&
        value.toString().contains("(") &&
        value.toString().contains(")")) {
      return true;
    }
    return false;
  }

  static dynamic evalTextFunction(String? value, Map? map, PageData appStoreData, int index, String originKeyData) {
    if (value == null || value.isEmpty) {
      return null;
    }
    //value = '=>getAppStore(getAppStoreDataTime)|timestampToDate(timestampToDateData)';
    String del = value.toString().startsWith("=>") ? "=>" : ":";
    localFunction() {
      //AppStore.print("evalTextFunction: ${value}");
      List<String> exp = value.toString().split("|");
      exp[0] = exp[0].split(del)[1];
      List<dynamic> listFn = [];
      for (String item in exp) {
        listFn.add(parseNameAndArguments(item));
      }
      //AppStore.print(listFn);
      Map<String, dynamic> originData =
          _getChainObject(appStoreData.getServerResponse(), [originKeyData, index, "data"], map);
      dynamic retExec;
      for (Map item in listFn) {
        List<dynamic> args = [appStoreData];
        if (retExec != null) {
          args.add(retExec);
        }
        for (String key in item["args"]) {
          if (originData.containsKey(key)) {
            args.add(originData[key]);
          } else if (map != null && map.containsKey(key)) {
            args.add(map[key]);
          } else {
            args.add(null);
          }
        }
        //AppStore.print("args: $args");
        if (args[1] != null && args[1].runtimeType.toString().contains("Map<")) {
          Map f = args[1];
          if (f.containsKey("metric")) {
            AppMetric().send(f["metric"]);
          }
        }
        retExec = Function.apply(parseUtilFunction(item["fn"]), args);
      }
      return retExec;
    }

    return del == "=>" ? Function.apply(localFunction, []) : localFunction;
  }

  static Map<String, dynamic> parseNameAndArguments(String value) {
    //input nameFunction(arg1,arg2,arg3)
    //output {fn: "nameFunction", args:["arg1","arg2","arg3"]}
    Map<String, dynamic> ret = {};
    List<String> args = [];
    List<String> exp1 = value.split("(");
    ret["fn"] = exp1[0];
    if (exp1.length > 1) {
      List<String> exp2 = exp1[1].split(")")[0].split(",");
      for (String item in exp2) {
        args.add(item.trim());
      }
    }
    ret["args"] = args;
    return ret;
  }

  static dynamic _getChainObject(dynamic obj, List chain, dynamic def) {
    if (obj == null || obj == '') {
      return def;
    }
    for (dynamic item in chain) {
      if (obj != null && obj[item] != null) {
        obj = obj[item];
      } else {
        return def;
      }
    }
    return obj;
  }

  static dynamic closeWindow(PageData appStoreData, dynamic data) {
    //AppStore.print("DATA: ${data}");
    if (data != null && data["delay"] != null) {
      Future.delayed(Duration(milliseconds: FlutterTypeConstant.parseInt(data["delay"]) ?? delay), () {
        //Navigator.pop(appStoreData.getCtx()!);
        TabScope.getInstance().popHistory(data);
      });
    } else {
      //Navigator.pop(appStoreData.getCtx()!);
      TabScope.getInstance().popHistory(data);
    }
  }

  static dynamic reloadPageByUrl(PageData appStoreData, dynamic data) {
    try {
      //JavaScript - Java converter return List as Map object with key indexes view [1,2,3] => {0:1, 1:2, 2:3} WTF
      Map urls = data;
      for (var item in urls.entries) {
        List<PageData> list = ListPageData().getByKey("url", item.value.toString());
        for (PageData store in list) {
          store.onIndexRevisionError();
        }
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
    }
  }

  static dynamic openWindow(PageData appStoreData, dynamic data) async {
    if (data["delay"] != null) {
      await Future.delayed(Duration(milliseconds: FlutterTypeConstant.parseInt(data["delay"]) ?? delay), () {});
    }
    String st = appStoreData.pageDataState.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    GlobalData.debug("openWindow: ${data}");
    PageData? lastPage = TabScope.getInstance().getLast();
    if (lastPage != null) {
      _openWindowUpdateBridgeState(appStoreData, data);
      //AppStore.debug("YYY: ${data}");
      Navigator.push(
        lastPage.getCtx()!,
        CupertinoPageRoute(
          settings: RouteSettings(name: data["url"]),
          builder: (context) => DynamicPage.fromMap(data),
        ),
      );
    } else {
      alert(appStoreData, {"data": "Не найдена история страниц, повторите попытку позже"});
    }
    return null;
  }

  static void _openWindowUpdateBridgeState(PageData appStoreData, dynamic data) {
    Map<String, dynamic> d = data;
    if (d.containsKey("bridgeState")) {
      Map<String, dynamic> bs = d["bridgeState"];
      for (var item in bs.entries) {
        dynamic value = appStoreData.pageDataState.get(item.key, null);
        if (value != null && value != "") {
          data["bridgeState"][item.key] = value;
        }
      }
    }
  }

  static dynamic joinAppStoreData(PageData appStoreData, dynamic data) {
    appStoreData.pageDataState.join(data["key"], data["append"], notify: data["notify"] ?? true);
    appStoreData.apply();
  }

  static dynamic openDialog(PageData appStoreData, dynamic data) {
    //print(data);
    data["dialog"] = true;
    String st = appStoreData.pageDataState.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    //AppStore.print("openDialog: ${data}");
    showDialog(
      useSafeArea: false,
      barrierDismissible: false,
      context: appStoreData.getCtx()!,
      builder: (context) => DynamicPage.fromMap(data),
    );
  }

  static dynamic test(PageData appStoreData, dynamic data) {
    GlobalData.debug("test: ${data}");
    return const Text("Hoho");
  }

  static dynamic confirm(PageData appStoreData, dynamic data) {
    data["action"] = true;
    data["duration"] = 5000;
    data["backgroundColor"] = "red.600";
    alert(appStoreData, data);
  }

  static dynamic resetTextFieldValue(PageData appStoreData, dynamic data) {
    TextEditingController? tec = appStoreData.pageDataState.getTextController(
      data["name"],
      "",
    );
    if (tec != null) {
      tec.text = "";
      appStoreData.pageDataState.set(data["name"], null);
    }
  }

  static dynamic alert(PageData appStoreData, dynamic data) {
    GlobalData.debug("alert: ${data}");
    Map config = Util.merge({
      "data": "Сохранено",
      "backgroundColor": "rgba:30,136,229,0.95",
      "color": "white",
      "duration": 750,
      "action": false,
      "actionColor": "white",
      "actionTitle": "Удалить",
      "actionFn": null
    }, data);

    SnackBarAction? action = config["action"] == true
        ? SnackBarAction(
            textColor: FlutterTypeConstant.parseColor(config["actionColor"]),
            label: config["actionTitle"],
            onPressed: DynamicFn.evalTextFunction(data['onPressed'], data, appStoreData, 0, 'no-origin-data'),
          )
        : null;

    ScaffoldMessenger.of(appStoreData.getCtx()!).showSnackBar(
      SnackBar(
        duration: Duration(milliseconds: config["duration"]),
        content: Text(config["data"], style: TextStyle(color: FlutterTypeConstant.parseColor(config["color"]))),
        backgroundColor: FlutterTypeConstant.parseColor(config["backgroundColor"]),
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        action: action,
      ),
    );
  }

  static dynamic getTimestamp(PageData appStoreData, dynamic data) {
    return Util.getTimestamp();
  }

  static dynamic getMD5(PageData appStoreData, dynamic data) {
    return md5.convert(utf8.encode(data["data"])).toString();
  }

  static dynamic launcher(PageData appStoreData, dynamic data) async {
    GlobalData.debug("launcher: ${data}");
    if (data != null && data["url"] != null && data["url"] != "") {
      launch(data["url"], forceSafariVC: false);
    } else {
      alert(appStoreData, {"data": "Url is empty"});
    }
  }

  static dynamic copyToClipBoard(PageData appStoreData, dynamic data) {
    Clipboard.setData(ClipboardData(text: data["data"]));
    alert(appStoreData, {"data": "Скопировано в буфер обмена"});
  }

  static dynamic share(PageData appStoreData, dynamic data) async {
    //await Share.share(data["data"], subject: 'Поделиться', sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    await FlutterShare.share(title: 'Поделиться', text: data["data"]);
    //Clipboard.setData(ClipboardData(text: data["data"]));
  }

  static dynamic openUri(PageData? appStoreData, dynamic data) {
    String uri = data["uri"];
    GlobalData.debug("openUri: ${data}");
    if(uri != null){
      if(uri.endsWith("/")){
        uri = uri.substring(0, uri.length - 1);
      }
      List<String> s = uri.split("/");
      s.remove(s.first);
      s.remove(s.first);
      s.remove(s.first);
      if (s.isNotEmpty) {
        String requestUri = "/${s.join("/")}";
        if (requestUri != "/") {
          selectTab(null, {"index": 0});
          PageData? asd = TabScope.getInstance().getLast();
          if (asd != null) {
            Map<String, dynamic> d = {};
            d["url"] = requestUri;
            openWindow(asd, d);
          }
        }
      }
    }
  }

  static dynamic selectTab(PageData? appStoreData, dynamic data) {
    int? index = FlutterTypeConstant.parseInt(data["index"]);
    if (index != null) {
      GlobalData.tabWrapState?.selectTab(index);
    }
  }

  static dynamic setAppStore(PageData appStoreData, dynamic data) {
    //AppStore.print("setAppStore: ${data}");
    dynamic now = appStoreData.pageDataState.get(data["key"], null);
    appStoreData.pageDataState.set(data["key"], data["value"] == now ? null : data["value"]);
    appStoreData.apply();
  }

  static dynamic getAppStore(PageData appStoreData, dynamic data) {
    //AppStore.print("getAppStore: ${data}");
    //AppStore.print("return getAppStore: ${appStoreData.get(data["key"], data["defaultValue"])}");
    if(data != null){
      Map x = data;
      if(x.containsKey("key")){
        return appStoreData.pageDataState.get(data["key"], data["defaultValue"]);
      }
      return data["defaultValue"];
    }
    return null;
  }

  static dynamic appStoreOperator(PageData appStoreData, dynamic data) {
    //AppStore.print("appStoreOperator: ${data}");
    if (data["value"] != null) {
      dynamic value = appStoreData.pageDataState.get(data["key"], null);
      List x = Util.getListFromMapOrString(data["value"]);
      if (x.contains(value)) {
        return data["trueCondition"];
      }
    }
    if (data["valueGroup"] != null) {
      Map<String, dynamic> valueGroup = data["valueGroup"];
      //AppStore.debug("${valueGroup}");
      bool lCond = true;
      for (var item in valueGroup.entries) {
        dynamic value = appStoreData.pageDataState.get(item.value["key"], null);
        //AppStore.debug("${value}");
        List x = Util.getListFromMapOrString(item.value["list"]);
        if (item.value["condition"] == "and") {
          if (lCond == true && x.contains(value)) {
            lCond = true;
          } else {
            lCond = false;
            break;
          }
        }
        if (item.value["condition"] == "or") {
          if (lCond == true || x.contains(value)) {
            lCond = true;
          } else {
            lCond = false;
            break;
          }
        }
      }
      return lCond ? data["trueCondition"] : data["falseCondition"];
    }

    return data["falseCondition"];
  }

  static dynamic openGallery(PageData appStoreData, dynamic data) async {
    //AppStore.print("OPEN GALLERY");
    var image = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: 'Редактировать',
              toolbarColor: Colors.blue[600],
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: true,
              hideBottomControls: true),
          IOSUiSettings(
              title: 'Редактировать',
              hidesNavigationBar: true,
              aspectRatioPickerButtonHidden: true,
              rotateButtonsHidden: true,
              rotateClockwiseButtonHidden: true,
              resetAspectRatioEnabled: false),
        ],
      );
      if (croppedFile != null) {
        await Util.uploadImage(File(croppedFile.path), "${GlobalData.host}${data["url"]}");
        appStoreData.onIndexRevisionError();
      }
    }
    //print("IMAGE: ${image}");
  }

  static dynamic wrapVisibility(Map<String, dynamic> data, PageData appStoreData, int index, Map<String, dynamic>? extraData) {
    dynamic w = DynamicUI.mainJson(data, appStoreData, index, 'Data');
    if (extraData != null &&
        extraData.containsKey("onVisibility") &&
        extraData["onVisibility"] == true &&
        extraData.containsKey("metric")) {
      return VisibilityDetector(
        key: Key(extraData["metric"]),
        onVisibilityChanged: (visibilityInfo) {
          if (visibilityInfo.visibleFraction * 100 == 100) {
            if (!appStoreData.alreadyVisible.containsKey(visibilityInfo.key.toString())) {
              appStoreData.alreadyVisible[visibilityInfo.key.toString()] = true;
              AppMetric().send(extraData["metric"]);
            }
          }
        },
        child: w,
      );
    }
    return w;
  }

  static Widget Function(int index) getFutureList(PageData appStoreData) {
    //print("getFutureList");
    if (appStoreData.getServerResponse().isNotEmpty) {
      Map<String, dynamic> response = appStoreData.getServerResponse();
      List<Widget> ret = [];
      for (int i = 0; i < response['list'].length; i++) {
        ret.add(wrapVisibility(response['list'][i], appStoreData, i, response['Data'] != null ? response['Data'][i]["data"] : null));
      }
      return (int index) {
        return ret[index];
      };
    } else {
      return (int index) {
        return const Text("Server response is empty");
      };
    }
  }

  static dynamic promo(PageData appStoreData, dynamic data) {
    Future.delayed(const Duration(milliseconds: 1), () {
      data["config"] = {"height": -1, "padding": 0, "borderRadius": 0};
      DynamicFn.openDialog(appStoreData, data);
    });
  }

  static Widget getFutureBuilder(PageData appStoreData, dynamic data) {
    //print("FB resp length: ${appStoreData.getServerResponse().length}");
    //if (appStoreData.getServerResponse().isNotEmpty && appStoreData.nowDownloadContent == false) { //BEFORE
    if (appStoreData.getServerResponse().isNotEmpty) {
      //AppStore.fullDebug(appStoreData.getServerResponse());
      //AFTER
      Map<String, dynamic> response = appStoreData.getServerResponse();
      bool grid = appStoreData.pageDataWidget.getWidgetData("grid") ?? false;
      bool withoutListView = appStoreData.pageDataWidget.getWidgetData("WithoutListView") ?? false;
      Map cfg = appStoreData.pageDataWidget.getWidgetDataConfig({"reverse": false});
      if (withoutListView == true) {
        //print("WithoutListView: ${response['list']}");
        return getFutureList(appStoreData)(0);
      }
      if (grid == false) {
        return Util.getListView(
            appStoreData,
            const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            reverse: cfg["reverse"]
        );
      } else {
        Map x = appStoreData.pageDataWidget.getWidgetDataConfig(
            {"crossAxisCount": 2, "childAspectRatio": 1.0, "mainAxisSpacing": 0.0, "crossAxisSpacing": 0.0});
        return GridView.count(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          crossAxisCount: x["crossAxisCount"],
          childAspectRatio: x["childAspectRatio"],
          mainAxisSpacing: x["mainAxisSpacing"],
          crossAxisSpacing: x["crossAxisSpacing"],
          children: List.generate(response['list'].length, getFutureList(appStoreData)),
        );
      }
    }
    //Я больше склонен, что бы первично отображалась всё таки актуальная информация с сервера
    //Но если через секунду содержимое не загружено, поднимать из кеша и отображать
    Future.delayed(const Duration(milliseconds: 1000), () {
      //print("Go1");
      if (appStoreData.nowDownloadContent == true) {
        //print("Go2");
        String? cachedDataPage = GlobalData.cache?.pageGet(appStoreData.pageDataWidget.getWidgetData("url"));
        if (cachedDataPage != null) {
          //print("Go3");
          DynamicPageUtil.dataUpdate(jsonDecode(cachedDataPage), appStoreData, native: false);
          //print("cachedDataPage: ${cachedDataPage}");
          DynamicFn.alert(appStoreData, {"data": "Локальная версия"});
        }
      }
    });

    return Center(
      child: CircularProgressIndicator(
        backgroundColor: FlutterTypeConstant.parseColor(appStoreData.pageDataWidget.getWidgetData("progressIndicatorBackgroundColor")),
        color: FlutterTypeConstant.parseColor(appStoreData.pageDataWidget.getWidgetData("progressIndicatorColor")),
      ),
    );
  }
}
