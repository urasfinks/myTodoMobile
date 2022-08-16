import 'package:flutter/cupertino.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myTODO/DynamicPage/DynamicDirective.dart';
import 'package:myTODO/DynamicPage/DynamicPageUtil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/DynamicUI.dart';
import '../TabWrap.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
      "appStoreOperator": appStoreOperator,
      "getMD5": getMD5,
      "launcher": launcher,
      "resetTextFieldValue": resetTextFieldValue,
      "joinAppStoreData": joinAppStoreData,
      "timestampToDate": DynamicDirective.timestampToDate,
      "formatNumber": DynamicDirective.formatNumber,
      "copyToClipBoard": copyToClipBoard,
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

  static dynamic evalTextFunction(String? value, Map? map, AppStoreData appStoreData, int index, String originKeyData) {
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

  static dynamic closeWindow(AppStoreData appStoreData, dynamic data) {
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

  static dynamic reloadPageByUrl(AppStoreData appStoreData, dynamic data) {
    try {
      //JavaScript - Java converter return List as Map object with key indexes view [1,2,3] => {0:1, 1:2, 2:3} WTF
      Map urls = data;
      for (var item in urls.entries) {
        List<AppStoreData> list = AppStore().getByKey("url", item.value.toString());
        for (AppStoreData store in list) {
          store.onIndexRevisionError();
        }
      }
    } catch (e, stacktrace) {
      AppStore.debug(e);
      AppStore.debug(stacktrace);
    }
  }

  static dynamic openWindow(AppStoreData appStoreData, dynamic data) async {
    /*try{
      FocusScope.of(appStoreData.getCtx()!).requestFocus(FocusNode());
    }catch(e, stacktrace){
      AppStore.print(e);
      AppStore.print(stacktrace);
    }*/
    if (data["delay"] != null) {
      await Future.delayed(Duration(milliseconds: FlutterTypeConstant.parseInt(data["delay"]) ?? delay), () {});
    }
    String st = appStoreData.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    AppStore.debug("openWindow: ${data}");
    AppStoreData? lastPage = TabScope.getInstance().getLast();
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

  static void _openWindowUpdateBridgeState(AppStoreData appStoreData, dynamic data){
    Map<String, dynamic> d = data;
    if(d.containsKey("bridgeState")){
      Map<String, dynamic> bs = d["bridgeState"];
      for(var item in bs.entries){
        dynamic value = appStoreData.get(item.key, null);
        if(value != null && value != ""){
          data["bridgeState"][item.key] = value;
        }
      }
    }
  }

  static dynamic joinAppStoreData(AppStoreData appStoreData, dynamic data) {
    appStoreData.join(data["key"], data["append"]);
    appStoreData.apply();
  }

  static dynamic openDialog(AppStoreData appStoreData, dynamic data) {
    data["dialog"] = true;
    String st = appStoreData.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    //AppStore.print("openDialog: ${data}");
    showDialog(
      context: appStoreData.getCtx()!,
      builder: (context) => DynamicPage.fromMap(data),
    );
  }

  static dynamic test(AppStoreData appStoreData, dynamic data) {
    AppStore.debug("test: ${data}");
    return const Text("Hoho");
  }

  static dynamic confirm(AppStoreData appStoreData, dynamic data) {
    data["action"] = true;
    data["duration"] = 5000;
    data["backgroundColor"] = "red.600";
    alert(appStoreData, data);
  }

  static dynamic resetTextFieldValue(AppStoreData appStoreData, dynamic data) {
    TextEditingController? tec = appStoreData.getTextController(
      data["name"],
      "",
    );
    if (tec != null) {
      tec.text = "";
      appStoreData.set(data["name"], null);
    }
  }

  static dynamic alert(AppStoreData appStoreData, dynamic data) {
    AppStore.debug("alert: ${data}");
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

  static dynamic getTimestamp(AppStoreData appStoreData, dynamic data) {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static dynamic getMD5(AppStoreData appStoreData, dynamic data) {
    return md5.convert(utf8.encode(data["data"])).toString();
  }

  static dynamic launcher(AppStoreData appStoreData, dynamic data) async {
    AppStore.debug("launcher: ${data}");
    if (data != null && data["url"] != null && data["url"] != "") {
      launch(data["url"], forceSafariVC: false);
    } else {
      alert(appStoreData, {"data": "Url is empty"});
    }
  }

  static dynamic copyToClipBoard(AppStoreData appStoreData, dynamic data) {
    Clipboard.setData(ClipboardData(text: data["data"]));
    alert(appStoreData, {"data": "Скопировано в буфер обмена"});
  }

  static dynamic setAppStore(AppStoreData appStoreData, dynamic data) {
    //AppStore.print("setAppStore: ${data}");
    dynamic now = appStoreData.get(data["key"], null);
    appStoreData.set(data["key"], data["value"] == now ? null : data["value"]);
    appStoreData.apply();
  }

  static dynamic getAppStore(AppStoreData appStoreData, dynamic data) {
    //AppStore.print("getAppStore: ${data}");
    //AppStore.print("return getAppStore: ${appStoreData.get(data["key"], data["defaultValue"])}");
    return appStoreData.get(data["key"], data["defaultValue"]);
  }

  static dynamic appStoreOperator(AppStoreData appStoreData, dynamic data) {
    //AppStore.print("appStoreOperator: ${data}");
    dynamic value = appStoreData.get(data["key"], null);
    if (value != null && value == data["value"]) {
      return data["trueCondition"];
    } else {
      return data["falseCondition"];
    }
  }

  static dynamic openGallery(AppStoreData appStoreData, dynamic data) async {
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
        await Util.uploadImage(File(croppedFile.path), "${AppStore.host}${data["url"]}");
        appStoreData.onIndexRevisionError();
      }
    }
    //print("IMAGE: ${image}");
  }

  static Widget Function(int index) getFutureList(AppStoreData appStoreData, dynamic data) {
    //print("getFutureList");
    if (appStoreData.getServerResponse().isNotEmpty) {
      Map<String, dynamic> response = appStoreData.getServerResponse();
      List<Widget> ret = [];
      for (int i = 0; i < response['list'].length; i++) {
        ret.add(DynamicUI.mainJson(response['list'][i], appStoreData, i, 'Data'));
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

  static Widget getFutureBuilder(AppStoreData appStoreData, dynamic data) {
    //print("FB resp length: ${appStoreData.getServerResponse().length}");
    //if (appStoreData.getServerResponse().isNotEmpty && appStoreData.nowDownloadContent == false) { //BEFORE
    if (appStoreData.getServerResponse().isNotEmpty) {
      //AFTER
      Map<String, dynamic> response = appStoreData.getServerResponse();
      bool grid = appStoreData.getWidgetData("grid");
      Map cfg = appStoreData.getWidgetDataConfig({"reverse": false});
      if (grid == false) {
        return Util.getListView(
            appStoreData.getWidgetData("separated"),
            const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            response['list'].length,
            getFutureList(appStoreData, data),
            reverse: cfg["reverse"]);
      } else {
        Map x = appStoreData.getWidgetDataConfig(
            {"crossAxisCount": 2, "childAspectRatio": 1.0, "mainAxisSpacing": 0.0, "crossAxisSpacing": 0.0});
        return GridView.count(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          crossAxisCount: x["crossAxisCount"],
          childAspectRatio: x["childAspectRatio"],
          mainAxisSpacing: x["mainAxisSpacing"],
          crossAxisSpacing: x["crossAxisSpacing"],
          children: List.generate(response['list'].length, getFutureList(appStoreData, data)),
        );
      }
    }
    //Я больше склонен, что бы первично отображалась всё таки актуальная информация с сервера
    //Но если через секунду содержимое не загружено, поднимать из кеша и отображать
    Future.delayed(const Duration(milliseconds: 1000), () {
      //print("Go1");
      if(appStoreData.nowDownloadContent == true){
        //print("Go2");
        String? cachedDataPage = AppStore.cache?.pageGet(appStoreData.getWidgetData("url"));
        if (cachedDataPage != null) {
          //print("Go3");
          DynamicPageUtil.dataUpdate(jsonDecode(cachedDataPage), appStoreData, native: false);
          //print("cachedDataPage: ${cachedDataPage}");
        }
      }
    });



    return CircularProgressIndicator(
      backgroundColor: FlutterTypeConstant.parseColor(appStoreData.getWidgetData("progressIndicatorBackgroundColor")),
      color: FlutterTypeConstant.parseColor(appStoreData.getWidgetData("progressIndicatorColor")),
    );
  }
}
