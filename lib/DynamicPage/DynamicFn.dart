import 'package:flutter/cupertino.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/DynamicUI.dart';
import '../TabWrap.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import '../Util.dart';
import 'DynamicPage.dart';

class DynamicFn {
  static int delay = 350;

  static dynamic parseUtilFunction(String value) {
    Map<String, Function> map = {
      "getFutureBuilder": getFutureBuilder,
      "test": test,
      "openWindow": openWindow,
      "closeWindow": closeWindow,
      "reloadPageByUrl": reloadPageByUrl,
      "openDialog": openDialog,
      "openGallery": openGallery,
      "alert": alert,
      "getAppStore": getAppStore,
      "timestampToDate": timestampToDate,
    };
    if (map.containsKey(value)) {
      return map[value];
    }
    return null;
  }

  static bool isTextFunction(dynamic value) {
    if (value != null &&
        value.runtimeType.toString() == "String" &&
        (value.toString().contains("):") || value.toString().contains(")=>"))) {
      return true;
    }
    return false;
  }

  static dynamic evalTextFunction(String value, map, AppStoreData appStoreData, int index, String originKeyData) {
    if (value.runtimeType.toString() == "String" && value.toString().contains("):")) {
      //Return reference function
      return (){
        List<String> exp = value.toString().split("):");
        Map<String, dynamic> originData = getChainObject(appStoreData.getServerResponse(), [originKeyData, index, "data"], map);
        print(originData);
        Function.apply(parseUtilFunction(exp[1]), [appStoreData, originData]);
      };
      //return parseUtilFunction(exp[1]); //Input arguments needs context
    }
    if (value.runtimeType.toString() == "String" && value.toString().contains(")=>")) {
      //Return execute function
      List<String> exp = value.toString().split(")=>");
      List<dynamic> args = [];
      args.add(appStoreData);
      List<String> exp2 = exp[0].split("(");
      Map<String, dynamic> originData = getChainObject(appStoreData.getServerResponse(), [originKeyData, index, "data"], map);

      if (exp2.length > 1 && originData.containsKey(exp2[1])) {
        args.add(originData[exp2[1]]);
      }
      if (args.length == 1) {
        args.add(null);
      }
      return Function.apply(parseUtilFunction(exp[1]), args);
    }
  }

  static dynamic getChainObject(dynamic obj, List<Object> chain, dynamic def) {
    if (obj == null || obj == '') {
      return def;
    }
    for (Object item in chain) {
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

  static dynamic timestampToDate(AppStoreData appStoreData, dynamic data) {
    DateTime dt = DateTime.fromMicrosecondsSinceEpoch(data["timestamp"]);
    return DateFormat(data["format"]).format(dt);
  }

  static Widget getFutureBuilder(AppStoreData appStoreData, dynamic data) {
    if (appStoreData.getServerResponse().isNotEmpty) {
      Map<String, dynamic> response = appStoreData.getServerResponse();
      return Util.getListView(
        appStoreData.getWidgetData("separated"),
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        response['list'].length,
        (BuildContext context, int index) {
          return DynamicUI.mainJson(response['list'][index], appStoreData, index, 'Data');
        },
      );
    }
    return CircularProgressIndicator(
      backgroundColor: FlutterTypeConstant.parseColor(appStoreData.getWidgetData("progressIndicatorBackgroundColor")),
      color: FlutterTypeConstant.parseColor(appStoreData.getWidgetData("progressIndicatorColor")),
    );
  }
}
