import 'package:flutter/cupertino.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test3/DynamicPage/DynamicDirective.dart';
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
      "getAppStore": getAppStore,
      //"getUrlPersonAvatar": getUrlPersonAvatar,
      "getMD5": getMD5,
      "timestampToDate": DynamicDirective.timestampToDate,
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

  static dynamic evalTextFunction(String? value, map, AppStoreData appStoreData, int index, String originKeyData) {
    if (value == null) {
      return null;
    }
    //value = '=>getAppStore(getAppStoreDataTime)|timestampToDate(timestampToDateData)';
    String del = value.toString().startsWith("=>") ? "=>" : ":";
    localFunction() {
      //print("evalTextFunction: ${value}");
      List<String> exp = value.toString().split("|");
      exp[0] = exp[0].split(del)[1];
      List<dynamic> listFn = [];
      for (String item in exp) {
        listFn.add(parseNameAndArguments(item));
      }
      Map<String, dynamic> originData =
          _getChainObject(appStoreData.getServerResponse(), [originKeyData, index, "data"], map);
      dynamic retExec;
      for (Map item in listFn) {
        List<dynamic> args = [appStoreData];
        if (retExec != null) {
          args.add(retExec);
        }
        for (String key in item["args"]) {
          args.add(originData[key]);
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

  static dynamic closeWindow(AppStoreData appStoreData, dynamic data) {
    //print("DATA: ${data}");
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
      print(e);
      print(stacktrace);
    }
  }

  static dynamic openWindow(AppStoreData appStoreData, dynamic data) {
    String st = appStoreData.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    print("openWindow: ${data}");
    Navigator.push(
      appStoreData.getCtx()!,
      /*MaterialPageRoute(
          settings: RouteSettings(name: data["url"]),
          builder: (context) => DynamicPage.fromMap(data),
        )*/
      CupertinoPageRoute(
        settings: RouteSettings(name: data["url"]),
        builder: (context) => DynamicPage.fromMap(data),
      ),
    );
    return null;
  }

  static dynamic openDialog(AppStoreData appStoreData, dynamic data) {
    data["dialog"] = true;
    String st = appStoreData.getStringStoreState();
    if (st.isNotEmpty) {
      data["parentState"] = st;
    }
    //print("openDialog: ${data}");
    showDialog(
      context: appStoreData.getCtx()!,
      builder: (context) => DynamicPage.fromMap(data),
    );
  }

  static dynamic test(AppStoreData appStoreData, dynamic data) {
    print("test: ${data}");
    return const Text("Hoho");
  }

  static dynamic alert(AppStoreData appStoreData, dynamic data) {
    print("alert: ${data}");
    ScaffoldMessenger.of(appStoreData.getCtx()!).showSnackBar(
      SnackBar(
        content: Text(data["data"]),
      ),
    );
  }

  static dynamic getTimestamp(AppStoreData appStoreData, dynamic data) {
    return DateTime.now().millisecondsSinceEpoch;
  }

  static dynamic getMD5(AppStoreData appStoreData, dynamic data) {
    return md5.convert(utf8.encode(data["data"])).toString();
  }

  /*
  static dynamic getUrlPersonAvatar(AppStoreData appStoreData, dynamic data) {
    //http://jamsys.ru:8081/avatar-get/a7d437fa-d47a-4e0f-9417-f9701ece125e?time=${time}
    return "${AppStore.host}/avatar-get/${getMD5(appStoreData, {"data": AppStore.personKey})}?time=${getTimestamp(appStoreData, data)}";
  }*/

  static dynamic getAppStore(AppStoreData appStoreData, dynamic data) {
    //print("getAppStore: ${data}");
    //print("return getAppStore: ${appStoreData.get(data["key"], data["defaultValue"])}");
    return appStoreData.get(data["key"], data["defaultValue"]);
  }

  static dynamic openGallery(AppStoreData appStoreData, dynamic data) async {
    //print("OPEN GALLERY");
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
      for(int i = 0; i< response['list'].length;i++){
        ret.add(DynamicUI.mainJson(response['list'][i], appStoreData, i, 'Data'));
      }
      return (int index){
        return ret[index];
      };
    } else{
      return (int index){
        return const Text("Server response is empty");
      };
    }
  }

  static Widget getFutureBuilder(AppStoreData appStoreData, dynamic data) {
    //print("getFutureBuilder");
    if (appStoreData.getServerResponse().isNotEmpty && appStoreData.nowDownloadContent == false) {
      Map<String, dynamic> response = appStoreData.getServerResponse();
      bool grid = appStoreData.getWidgetData("grid");
      if (grid == false) {
        return Util.getListView(
          appStoreData.getWidgetData("separated"),
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          response['list'].length,
          getFutureList(appStoreData, data),
        );
      } else {
        Map x = appStoreData.getWidgetDataConfig({"crossAxisCount": 2, "childAspectRatio": 1.0, "mainAxisSpacing": 0.0, "crossAxisSpacing": 0.0});
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
    return CircularProgressIndicator(
      backgroundColor: FlutterTypeConstant.parseColor(appStoreData.getWidgetData("progressIndicatorBackgroundColor")),
      color: FlutterTypeConstant.parseColor(appStoreData.getWidgetData("progressIndicatorColor")),
    );
  }
}
