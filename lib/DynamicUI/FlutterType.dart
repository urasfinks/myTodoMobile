import 'dart:core';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'icon.dart';

class FlutterType {
  static Widget defaultWidget = const SizedBox(width: 0);

  static Widget main(String jsonData) {
    if (jsonData.isEmpty) {
      return defaultWidget;
    }
    final parsedJson = jsonDecode(jsonData);
    return def(parsedJson, null, defaultWidget);
  }

  static Widget mainJson(Map<String, dynamic> jsonData) {
    if (jsonData.isEmpty) {
      return defaultWidget;
    }
    return def(jsonData, null, defaultWidget);
  }

  static dynamic getByType(String containsKey, map, dynamic def) {
    Map<String, Function> map1 = {
      "Text": _pText,
      "TextStyle": _pTextStyle,
      "Column": _pColumn,
      "Expanded": _pExpanded,
      "SizedBox": _pSizedBox,
      "Row": _pRow,
      "Container": _pContainer,
      "NetworkImage": _pNetworkImage,
      "CircleAvatar": _pCircleAvatar,
      "Icon": _pIcon,
    };
    return map1.containsKey(containsKey)
        ? Function.apply(map1[containsKey]!, [map])
        : def;
  }

  static dynamic def(map, key, def) {
    dynamic ret;
    if (key != null) {
      ret = map.containsKey(key) ? map[key] : def;
    } else {
      ret = map;
    }

    if (ret.runtimeType.toString() ==
            '_InternalLinkedHashMap<String, dynamic>' &&
        ret.containsKey('flutterType')) {
      return FlutterType.getByType(ret['flutterType'] as String, ret, def);
    }
    return ret;
  }

  static double? castToDouble(value) {
    if (value == null) {
      return null;
    }
    return double.parse(value.toString());
  }

  static dynamic castToCrossAxisAlignment(value) {
    Map<String, CrossAxisAlignment> map = {
      'start': CrossAxisAlignment.start,
      'center': CrossAxisAlignment.center,
      'end': CrossAxisAlignment.end,
      'baseline': CrossAxisAlignment.baseline,
      'stretch': CrossAxisAlignment.stretch,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static Color? castToMaterialColor(String? value) {
    if (value == null) {
      return null;
    }
    if (value.startsWith("#")) {
      return parseHexColor(value);
    } else {
      Map<String, Color> map = {
        "grey": Colors.grey,
        "blue": Colors.blue,
        "red": Colors.red,
        "transparent": Colors.transparent,
        "amber": Colors.amber,
        "black": Colors.black,
        "white": Colors.white,
        "yellow": Colors.yellow,
        "brown": Colors.brown,
        "cyan": Colors.cyan,
        "green": Colors.green,
        "indigo": Colors.indigo,
        "orange": Colors.orange,
        "lime": Colors.lime,
        "pink": Colors.pink,
        "purple": Colors.purple,
        "teal": Colors.teal
      };
      return map.containsKey(value) ? map[value] : null;
    }
  }

  static Color? parseHexColor(String? hexColorString) {
    if (hexColorString == null) {
      return null;
    }
    hexColorString = hexColorString.toUpperCase().replaceAll("#", "");
    if (hexColorString.length == 6) {
      hexColorString = "FF$hexColorString";
    }
    int colorInt = int.parse(hexColorString, radix: 16);
    return Color(colorInt);
  }

  static FontWeight? parseFontWeight(String? textFontWeight) {
    Map<String, FontWeight> map = {
      "normal": FontWeight.normal,
      "bold": FontWeight.bold,
      "w100": FontWeight.w100,
      "w200": FontWeight.w200,
      "w300": FontWeight.w300,
      "w400": FontWeight.w400,
      "w500": FontWeight.w500,
      "w600": FontWeight.w600,
      "w700": FontWeight.w700,
      "w800": FontWeight.w800,
      "w900": FontWeight.w900,
    };
    return map.containsKey(textFontWeight) ? map[textFontWeight] : null;
  }

  static EdgeInsetsGeometry? parseEdgeInsetsGeometry(
      String? edgeInsetsGeometryString) {
    //left,top,right,bottom
    if (edgeInsetsGeometryString == null ||
        edgeInsetsGeometryString.trim() == '') {
      return null;
    }
    var values = edgeInsetsGeometryString.split(",");
    return EdgeInsets.only(
      left: double.parse(values[0]),
      top: double.parse(values[1]),
      right: double.parse(values[2]),
      bottom: double.parse(values[3]),
    );
  }

  static dynamic _pText(parsedJson) {
    return Text(
      def(parsedJson, 'data', ''),
      style: def(parsedJson, 'style', null),
    );
  }

  static dynamic _pTextStyle(parsedJson) {
    return TextStyle(
      color: castToMaterialColor(def(parsedJson, 'color', null)),
      fontSize: castToDouble(def(parsedJson, 'fontSize', null)),
    );
  }

  static List<Widget> defList(parsedJson, String key) {
    List<Widget> list = [];
    List l2 = def(parsedJson, key, []);
    for (int i = 0; i < l2.length; i++) {
      list.add(def(l2[i], null, defaultWidget));
    }
    return list;
  }

  static dynamic _pColumn(parsedJson) {
    return Column(
      crossAxisAlignment:
          castToCrossAxisAlignment(def(parsedJson, 'crossAxisAlignment', null)),
      children: defList(parsedJson, 'children'),
    );
  }

  static dynamic _pExpanded(parsedJson) {
    return Expanded(
      child: def(parsedJson, 'child', defaultWidget),
    );
  }

  static dynamic _pSizedBox(parsedJson) {
    return SizedBox(
      width: castToDouble(def(parsedJson, 'width', null)),
    );
  }

  static dynamic _pRow(parsedJson) {
    return Row(
        crossAxisAlignment: castToCrossAxisAlignment(
            def(parsedJson, 'crossAxisAlignment', null)),
        children: defList(parsedJson, 'children'));
  }

  static dynamic _pContainer(parsedJson) {
    return Container(
      margin: parseEdgeInsetsGeometry(def(parsedJson, 'margin', null)),
      padding: parseEdgeInsetsGeometry(def(parsedJson, 'padding', null)),
      child: def(parsedJson, 'child', defaultWidget),
    );
  }

  static dynamic _pNetworkImage(parsedJson) {
    return NetworkImage(def(parsedJson, 'src', null));
  }

  static dynamic _pCircleAvatar(parsedJson) {
    return CircleAvatar(
        backgroundImage: def(parsedJson, 'backgroundImage', null));
  }

  static dynamic _pIcon(parsedJson) {
    return Icon(
      iconsMap[def(parsedJson, 'src', null)],
      color: castToMaterialColor(def(parsedJson, 'color', null)),
      size: castToDouble(def(parsedJson, 'size', null)),
    );
  }

}
