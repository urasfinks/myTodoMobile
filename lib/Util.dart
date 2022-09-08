import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:myTODO/AppStore/AppStore.dart';
import 'package:myTODO/DynamicUI/FlutterTypeConstant.dart';
import 'dart:developer' as developer;

import 'AppMetric.dart';
import 'AppStore/AppStoreData.dart';
import 'SliversApp.dart';

class Util {
  static dynamic getListView(AppStoreData appStoreData, ScrollPhysics physics,{bool reverse = false}) {
    return ShrinkWrapSlivers(appStoreData);
  }

  static ListView getListView2(bool separated, ScrollPhysics physics, int itemCount, Widget Function(int index) itemBuilder,
      {bool reverse = false}) {
    //AppStore.print("SEPARATED: ${separated}");
    if (separated == true) {
      return ListView.separated(
        reverse: reverse,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return itemBuilder(index);
        },
        separatorBuilder: (BuildContext context, int index) => Divider(
          height: 1,
          color: FlutterTypeConstant.parseColor("#f5f5f5")!,
        ),
      );
    } else {
      return ListView.builder(
        reverse: reverse,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return itemBuilder(index);
        },
      );
    }
  }

  static String path2(dynamic data, String path) {
    List<String> exp = path.split(".");
    dynamic cur = data;
    for (String key in exp) {
      if (cur != null && cur[key] != null) {
        cur = cur[key];
      }
    }
    if (cur.runtimeType.toString() == "String") {
      return cur != null ? cur.toString() : "null";
    } else {
      return jsonEncode(cur);
    }
  }

  static String path(dynamic data, String path) {
    //AppStore.print("PATH: '${path}'");
    List<String> exp = path.split(".");
    dynamic cur = data;
    for (String key in exp) {
      if (cur != null && cur[key] != null) {
        cur = cur[key];
      }
    }
    return cur != null ? cur.toString().replaceAll("\\", "\\\\").replaceAll("\"", "\\\"") : "null";
  }

  static String template(dynamic data, String template) {
    List<String> exp = template.split('\${');

    for (String expItem in exp) {
      if (!expItem.contains("}")) {
        continue;
      }
      List<String> exp2 = expItem.split("}");
      if (exp2.isEmpty) {
        continue;
      }
      List<String> name = exp2[0].split("|");
      String fName = exp2[0];
      String rName = name[0];
      if (name.length > 1 && name[1] == "unescape") {
        template = template.replaceAll("\${$fName}", path2(data, rName));
      } else {
        template = template.replaceAll("\${$fName}", jsonStringEscape(path2(data, rName)));
      }
    }
    return template;
  }

  static Future uploadImage(File image, String url) async {
    var stream = http.ByteStream(image.openRead());
    var length = await image.length();
    var request = http.MultipartRequest("POST", Uri.parse(url));

    request.files.add(http.MultipartFile('avatar', stream, length, filename: basename(image.path)));

    request.headers.addAll(AppStore.requestHeader);
    return await request.send().then((response) async {
      //AppStore.print("RESPONSE: ${response}");
      /*response.stream.transform(utf8.decoder).listen((value) {
        AppStore.print("VALUE: ${value}");
      });*/
    }).catchError((e) {
      AppMetric().exception(e, null);
    });
  }

  static void log(dynamic mes) {
    developer.log(mes);
  }

  static String jsonStringEscape(String raw) {
    String escaped = raw;
    escaped = escaped.replaceAll("\\", "\\\\");
    escaped = escaped.replaceAll("\"", "\\\"");
    escaped = escaped.replaceAll("\b", "\\b");
    escaped = escaped.replaceAll("\f", "\\f");
    escaped = escaped.replaceAll("\n", "\\n");
    escaped = escaped.replaceAll("\r", "\\r");
    escaped = escaped.replaceAll("\t", "\\t");
    return escaped;
  }

  static Map merge(Map def, Map? input) {
    if (input == null || input.isEmpty) {
      return def;
    }
    for (var item in input.entries) {
      def[item.key] = item.value;
    }
    return def;
  }

  static String intLPad(int i, {int pad = 0, String char = "0"}) => i.toString().padLeft(pad, char);

  static String intRPad(int i, {int pad = 0, String char = "0"}) => i.toString().padRight(pad, char);

  static bool isIndexKey(dynamic data) {
    if (data.runtimeType.toString().contains("Map<")) {
      Map x = data;
      for (String s in x.keys) {
        if (!isNumeric(s)) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  static List<dynamic> getListFromMapOrString(dynamic data) {
    List list = [];
    if (data.runtimeType.toString().startsWith("String")) {
      String x = data;
      if (x.contains(",")) {
        list.addAll(x.split(","));
      } else {
        list.add(data);
      }
    } else if (isIndexKey(data)) {
      Map<String, dynamic> x = data;
      for (var item in x.entries) {
        list.add(item.value);
      }
    }
    return list;
  }

  static bool isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  static int getTimestamp() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}
