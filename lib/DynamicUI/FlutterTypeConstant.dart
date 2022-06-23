
import 'package:flutter/material.dart';

class FlutterTypeConstant{
  static dynamic parseToFontStyle(value) {
    Map<String, FontStyle> map = {
      'normal': FontStyle.normal,
      'italic': FontStyle.italic,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static double? parseToDouble(value) {
    if (value == null) {
      return null;
    }
    return double.parse(value.toString());
  }

  static int? parseToInt(value) {
    if (value == null) {
      return null;
    }
    return int.parse(value.toString());
  }

  static dynamic parseToCrossAxisAlignment(value) {
    Map<String, CrossAxisAlignment> map = {
      'start': CrossAxisAlignment.start,
      'center': CrossAxisAlignment.center,
      'end': CrossAxisAlignment.end,
      'baseline': CrossAxisAlignment.baseline,
      'stretch': CrossAxisAlignment.stretch,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static Color? parseToMaterialColor(String? value) {
    if (value == null) {
      return null;
    }
    if(value.startsWith("rgba:")){
      List<String> l = value.split("rgba:")[1].split(",");
      return Color.fromRGBO(parseToInt(l[0])!, parseToInt(l[1])!, parseToInt(l[2])!, parseToDouble(l[3])!);
    } else if (value.startsWith("#")) {
      return _parseHexColor(value);
    } else {
      Map<String, Color> map = {"grey": Colors.grey, "blue": Colors.blue, "red": Colors.red, "transparent": Colors.transparent, "amber": Colors.amber, "black": Colors.black, "white": Colors.white, "yellow": Colors.yellow, "brown": Colors.brown, "cyan": Colors.cyan, "green": Colors.green, "indigo": Colors.indigo, "orange": Colors.orange, "lime": Colors.lime, "pink": Colors.pink, "purple": Colors.purple, "teal": Colors.teal};
      return map.containsKey(value) ? map[value] : null;
    }
  }

  static Color? _parseHexColor(String? hexColorString) {
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

  static FontWeight? parseFontWeight(String? value) {
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
    return map.containsKey(value) ? map[value] : null;
  }

  static EdgeInsetsGeometry? parseEdgeInsetsGeometry(String? edgeInsetsGeometryString) {
    //left,top,right,bottom
    if (edgeInsetsGeometryString == null || edgeInsetsGeometryString.trim() == '') {
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

  static BoxFit? parseBoxFit(String value){
    Map<String, BoxFit> map = {
      "contain": BoxFit.contain,
      "cover": BoxFit.cover,
      "fill": BoxFit.fill,
      "fitHeight": BoxFit.fitHeight,
      "fitWidth": BoxFit.fitWidth,
      "none": BoxFit.none,
      "scaleDown": BoxFit.scaleDown,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static ImageRepeat? parseImageRepeat(value) {
    Map<String, ImageRepeat> map = {
      "noRepeat": ImageRepeat.noRepeat,
      "repeat": ImageRepeat.repeat,
      "repeatX": ImageRepeat.repeatX,
      "repeatY": ImageRepeat.repeatY
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static Alignment? parseAlignmentGeometry(String value) {
    Map<String, Alignment> map = {
      "center": Alignment.center,
      "centerLeft": Alignment.centerLeft,
      "centerRight": Alignment.centerRight,
      "bottomCenter": Alignment.bottomCenter,
      "bottomLeft": Alignment.bottomLeft,
      "bottomRight": Alignment.bottomRight,
      "topCenter": Alignment.topCenter,
      "topLeft": Alignment.topLeft,
      "topRight": Alignment.topRight,
    };
    return map.containsKey(value) ? map[value] : null;
  }

}