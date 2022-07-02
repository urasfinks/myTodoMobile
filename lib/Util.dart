import 'package:flutter/material.dart';

class Util {
  static ListView getListView(bool separated, ScrollPhysics physics, int itemCount, IndexedWidgetBuilder itemBuilder) {
    if (separated == true) {
      return ListView.separated(
        physics: physics,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    } else {
      return ListView.builder(
        physics: physics,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      );
    }
  }

  static String path(dynamic data, String path) {
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
      template = template.replaceAll("\${$name}", path(data, name));
    }
    return template;
  }



}
