import 'package:flutter/material.dart';
import 'package:test3/DynamicPage/DynamicPageUtil.dart';

class FlutterTypeConstant {
  static dynamic parseToFontStyle(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, FontStyle> map = {
      'normal': FontStyle.normal,
      'italic': FontStyle.italic,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static double? parseToDouble(dynamic value) {
    if (value == null || value.toString().trim() == '') {
      return null;
    }
    if (value.toString() == "infinity") {
      return double.infinity;
    }
    return double.parse(value.toString());
  }

  static int? parseToInt(dynamic value) {
    if (value == null || value.toString().trim() == '') {
      return null;
    }
    return int.parse(value.toString().replaceAll(".0", ""));
  }

  static Color? parseToMaterialColor(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, Color> map = {"grey": Colors.grey, "blue": Colors.blue, "red": Colors.red, "transparent": Colors.transparent, "amber": Colors.amber, "black": Colors.black, "white": Colors.white, "yellow": Colors.yellow, "brown": Colors.brown, "cyan": Colors.cyan, "green": Colors.green, "indigo": Colors.indigo, "orange": Colors.orange, "lime": Colors.lime, "pink": Colors.pink, "purple": Colors.purple, "teal": Colors.teal};
    if (value.startsWith("rgba:")) {
      List<String> l = value.split("rgba:")[1].split(",");
      return Color.fromRGBO(parseToInt(l[0])!, parseToInt(l[1])!, parseToInt(l[2])!, parseToDouble(l[3])!);
    } else if (value.startsWith("#")) {
      return _parseHexColor(value);
    } else if (value.contains(".")) {
      try {
        List<String> l = value.split(".");
        MaterialColor? x = (map.containsKey(l[0]) ? map[l[0]] : null) as MaterialColor?;
        if (x != null) {
          return x[parseToInt(l[1])!];
        }
      } catch (e, stacktrace) {
        print(e);
        print(stacktrace);
      }
      return null;
    } else {
      return map.containsKey(value) ? map[value] : null;
    }
  }

  static Color? _parseHexColor(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    value = value.toUpperCase().replaceAll("#", "");
    if (value.length == 6) {
      value = "FF$value";
    }
    int colorInt = int.parse(value, radix: 16);
    return Color(colorInt);
  }

  static FontWeight? parseFontWeight(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
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

  static EdgeInsets? parseEdgeInsetsGeometry(String? value) {
    //left,top,right,bottom
    if (value == null || value.trim() == '') {
      return null;
    }
    var values = value.split(",");
    if(values.length > 1){
      return EdgeInsets.only(
        left: double.parse(values[0]),
        top: double.parse(values[1]),
        right: double.parse(values[2]),
        bottom: double.parse(values[3]),
      );
    }else{
      return EdgeInsets.all(parseToDouble(value)!);
    }
  }

  static BoxFit? parseBoxFit(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
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

  static ImageRepeat? parseImageRepeat(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, ImageRepeat> map = {"noRepeat": ImageRepeat.noRepeat, "repeat": ImageRepeat.repeat, "repeatX": ImageRepeat.repeatX, "repeatY": ImageRepeat.repeatY};
    return map.containsKey(value) ? map[value] : null;
  }

  static Alignment? parseAlignmentGeometry(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
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

  static List<Color> parseListColor(parsedJson) {
    List<Color> ret = [];
    if (parsedJson != null) {
      for (String color in parsedJson) {
        Color? x = parseToMaterialColor(color);
        if (x != null) {
          ret.add(x);
        }
      }
    }
    return ret;
  }

  static MainAxisAlignment? parseToMainAxisAlignment(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, MainAxisAlignment> map = {
      'start': MainAxisAlignment.start,
      'center': MainAxisAlignment.center,
      'end': MainAxisAlignment.end,
      'spaceEvenly': MainAxisAlignment.spaceEvenly,
      'spaceBetween': MainAxisAlignment.spaceBetween,
      'spaceAround': MainAxisAlignment.spaceAround,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static CrossAxisAlignment? parseToCrossAxisAlignment(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, CrossAxisAlignment> map = {
      'start': CrossAxisAlignment.start,
      'center': CrossAxisAlignment.center,
      'end': CrossAxisAlignment.end,
      'baseline': CrossAxisAlignment.baseline,
      'stretch': CrossAxisAlignment.stretch,
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static BorderRadiusGeometry? parseToBorderRadius(dynamic value) {
    if (value == null || value.toString().trim() == '') {
      return null;
    }
    if (value.toString().contains(",")) {
      List<String> l = value.toString().split(",");
      return BorderRadius.only(
        topLeft: Radius.circular(parseToDouble(l[0])!),
        topRight: Radius.circular(parseToDouble(l[1])!),
        bottomRight: Radius.circular(parseToDouble(l[2])!),
        bottomLeft: Radius.circular(parseToDouble(l[3])!),
      );
    } else {
      return BorderRadius.all(Radius.circular(parseToDouble(value.toString())!));
    }
  }

  static dynamic parseUtilFunction(String value){
    Map<String, Function> map = {
      "getFutureBuilder": DynamicPageUtil.getFutureBuilder,
      "test": DynamicPageUtil.test,
      "openWindow": DynamicPageUtil.openWindow,
      "closeWindow": DynamicPageUtil.closeWindow,
      "reloadPageByUrl": DynamicPageUtil.reloadPageByUrl,
      "openDialog": DynamicPageUtil.openDialog,
      "openGallery": DynamicPageUtil.openGallery,
    };
    if(map.containsKey(value)){
      return map[value];
    }
    return null;
  }

  static TextInputType? parseToTextInputType(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, TextInputType> map = {
      'none': TextInputType.none,
      'url': TextInputType.url,
      'name': TextInputType.name,
      'datetime': TextInputType.datetime,
      'emailAddress': TextInputType.emailAddress,
      'multiline': TextInputType.multiline,
      'number': TextInputType.number,
      'phone': TextInputType.phone,
      'streetAddress': TextInputType.streetAddress,
      'text': TextInputType.text,
      'visiblePassword': TextInputType.visiblePassword
    };
    return map.containsKey(value) ? map[value] : null;
  }

  static BorderStyle? parseToBorderStyle(String? value) {
    if (value == null || value.trim() == '') {
      return null;
    }
    Map<String, BorderStyle> map = {
      'solid': BorderStyle.solid,
      'none': BorderStyle.none,
    };
    return map.containsKey(value) ? map[value] : null;
  }

}
