import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../AppStore/AppStore.dart';
import '../AppStore/AppStoreData.dart';
import '../DynamicUI/FlutterTypeConstant.dart';
import '../Util.dart';
import 'DynamicPage.dart';
import '../DynamicUI/DynamicUI.dart';
import '../DynamicUI/page/TextEditRowJsonObject.dart';
import '../DynamicUI/page/ErrorPageJsonObject.dart';
import '../WebSocket.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class DynamicPageUtil {
  static int delay = 350;

  static Future<void> loadDataTest(DynamicPage widget, AppStoreData appStoreData) async {
    await Future.delayed(Duration(milliseconds: delay), () {});
    dataUpdate(TextEditRowJsonObject.getPage(), appStoreData);
  }

  static Future<void> loadData(DynamicPage widget, AppStoreData appStoreData) async {
    if (!widget.root) {
      await Future.delayed(Duration(milliseconds: delay), () {});
    }
    print('Load data');
    try {
      Map<String, String> requestHeaders = {'Authorization': AppStore.personKey};

      final response = await http.post(Uri.parse("${AppStore.host}${widget.url}"), headers: requestHeaders, body: widget.parentState);

      print(response.body);
      if (response.statusCode == 200) {
        dataUpdate(jsonDecode(response.body), appStoreData);
      } else {
        dataUpdate(ErrorPageJsonObject.getPage(response.statusCode.toString(), "Ошибка сервера", response.body), appStoreData);
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      dataUpdate(ErrorPageJsonObject.getPage("500", "Ошибка приложения", e.toString()), appStoreData);
    }
  }

  static Widget getFutureBuilder(AppStoreData appStoreData, dynamic data) {
    if (appStoreData.getServerResponse().isNotEmpty) {
      Map<String, dynamic> snapshot = appStoreData.getServerResponse();
      return Util.getListView(
        appStoreData.getWidgetData("separated"),
        const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        snapshot['list'].length,
        (BuildContext context, int index) {
          return DynamicUI.mainJson(snapshot['list'][index], appStoreData, index);
        },
      );
    }
    return CircularProgressIndicator(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(appStoreData.getWidgetData("progressIndicatorBackgroundColor")),
      color: FlutterTypeConstant.parseToMaterialColor(appStoreData.getWidgetData("progressIndicatorColor")),
    );
  }

  static dataUpdate(Map<String, dynamic> data, AppStoreData appStoreData) {
    List<dynamic>? action = data['Actions'];
    if (action != null && action.isNotEmpty) {
      for (Map item in action) {
        DynamicUI.def(item, "method", null, appStoreData, 0);
      }
    }

    if (data['WidgetData'] != null && data['WidgetData'] != "") {
      //print("SET NEW WIDGET DATA(${data['WidgetData']})");
      appStoreData.addWidgetDataByMap(data['WidgetData']);
    }

    if (data['State'] != null && data['State'] != "") {
      Map<String, dynamic> map = data['State'];
      for (var item in map.entries) {
        appStoreData.set(item.key, item.value, notify: false);
      }
      appStoreData.apply(); //Maybe setState refresh Data on UI?
    }

    if (data['SyncSocket'] != null && data['SyncSocket'] == true && (appStoreData.getWidgetData("dataUID") as String).isNotEmpty) {
      appStoreData.setSyncSocket(true);
      WebSocket().subscribe(appStoreData.getWidgetData("dataUID"));
    }

    if (data.containsKey("Data")) {
      List list = [];
      Map<String, dynamic> template = data['Template'];
      for (dynamic d in data['Data']) {
        String ret;
        if (template.containsKey(d['template'])) {
          //print(data['Template'][d['template']]);
          ret = Util.template(d['data'], data['Template'][d['template']]);
          //print(ret);
        } else {
          ret = jsonEncode({"flutterType": "Text", "data": "Undefined Template: ${d['template']}"});
        }
        list.add(jsonDecode(ret));
      }
      data['list'] = list;
    }
    //print(data);
    appStoreData.setServerResponse(data);
    appStoreData.getPageState()?.setState(() {});
  }

  static dynamic closeWindow(AppStoreData appStoreData, dynamic data) {
    print("DATA: ${data}");
    if (data != null && data["delay"] != null) {
      Future.delayed(Duration(milliseconds: FlutterTypeConstant.parseToInt(data["delay"]) ?? delay), () {
        Navigator.pop(appStoreData.getCtx()!);
      });
    } else {
      Navigator.pop(appStoreData.getCtx()!);
    }
  }

  static dynamic reloadPageByUrl(AppStoreData appStoreData, dynamic data) {
    try {
      List<dynamic> urls = data;
      for (dynamic url in urls) {
        List<AppStoreData> list = AppStore().getByKey("url", url.toString());
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
      CupertinoPageRoute(
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
    print("openDialog: ${data}");
    showDialog(
      context: appStoreData.getCtx()!,
      builder: (context) => DynamicPage.fromMap(data),
    );
  }

  static dynamic test(AppStoreData appStoreData, dynamic data) {
    print("YHOOO");
    return Text("Hoho");
  }

  static dynamic openGallery(AppStoreData appStoreData, dynamic data) async {
    //print("OPEN GALLERY");
    var image = await ImagePicker().pickImage(source: ImageSource.gallery, maxWidth: 600);
    if (image != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
        ],
        uiSettings: [
          AndroidUiSettings(toolbarTitle: 'Редактировать', toolbarColor: Colors.blue[600], toolbarWidgetColor: Colors.white, initAspectRatio: CropAspectRatioPreset.square, lockAspectRatio: true, hideBottomControls: true),
          IOSUiSettings(
            title: 'Редактировать',
          ),
        ],
      );
      if(croppedFile != null){
        await Util.uploadImage(File(croppedFile.path), "${AppStore.host}${data["url"]}");
        appStoreData.onIndexRevisionError();
      }
    }
    //print("IMAGE: ${image}");
  }
}
