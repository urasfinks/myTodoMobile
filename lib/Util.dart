import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:test3/AppStore/AppStore.dart';

class Util {
  static ListView getListView(bool separated, ScrollPhysics physics, int itemCount, IndexedWidgetBuilder itemBuilder, {bool reverse = false}) {
    print("SEPARATED: ${separated}");
    if (separated == true) {
      return ListView.separated(
        reverse: reverse,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    } else {
      return ListView.builder(
        reverse: reverse,
        physics: physics,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
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
      return cur != null ? cur.toString().replaceAll("\\", "\\\\").replaceAll("\"", "\\\"") : "null";
    } else {
      return jsonEncode(cur);
    }
  }

  static String path(dynamic data, String path) {
    //print("PATH: '${path}'");
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
      String name = exp2[0];
      template = template.replaceAll("\${$name}", path2(data, name));
    }
    return template;
  }

  static Future uploadImage(File image, String url) async {
    var stream = http.ByteStream(image.openRead());
    var length = await image.length();
    var request = http.MultipartRequest("POST", Uri.parse(url));
    request.fields["personKey"] = AppStore.personKey;
    request.files.add(http.MultipartFile('avatar', stream, length, filename: basename(image.path)));
    return await request.send().then((response) async {
      //print("RESPONSE: ${response}");
      /*response.stream.transform(utf8.decoder).listen((value) {
        print("VALUE: ${value}");
      });*/
    }).catchError((e) {
      print(e);
    });
  }
}
