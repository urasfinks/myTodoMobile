class Addon{

  static void radius(parsedJson, String type){
    if(type == "top"){
      _topRadius(parsedJson);
    }
    if(type == "bottom"){
      _bottomRadius(parsedJson);
    }
  }

  static void _topRadius(parsedJson){
    if(parsedJson["flutterType"] == "Material"){
      _materialTopRadius(parsedJson);
    }
    if(parsedJson["flutterType"] == "Container"){
      _containerTopRadius(parsedJson);
    }
  }

  static void _bottomRadius(parsedJson){
    if(parsedJson["flutterType"] == "Material"){
      _materialBottomRadius(parsedJson);
    }
    if(parsedJson["flutterType"] == "Container"){
      _containerBottomRadius(parsedJson);
    }
  }

  static void _containerTopRadius(parsedJson) {
    String saveColor = parsedJson["color"];
    parsedJson["color"] = null;
    if(parsedJson["decoration"] == null){
      Map<String, dynamic> x = {};
      parsedJson["decoration"] = x;
    }
    parsedJson["decoration"]["flutterType"] = "BoxDecoration";
    parsedJson["decoration"]["borderRadius"] = "10,10,0,0";
    parsedJson["decoration"]["color"] = saveColor;
  }

  static void _containerBottomRadius(parsedJson) {
    print("_containerBottomRadius: ${parsedJson["color"]}");
    String saveColor = parsedJson["color"] ?? parsedJson["decoration"]["color"];
    parsedJson["color"] = null;
    if (parsedJson["decoration"] == null){
      Map<String, dynamic> x = {};
      parsedJson["decoration"] = x;
    }
    if(parsedJson["decoration"]["borderRadius"] == "10,10,0,0") {
      parsedJson["decoration"]["borderRadius"] = "10,10,10,10";
    } else {
      parsedJson["decoration"]["flutterType"] = "BoxDecoration";
      parsedJson["decoration"]["borderRadius"] = "0,0,10,10";
      parsedJson["decoration"]["color"] = saveColor;
    }
  }

  static void _materialTopRadius(parsedJson) {
    parsedJson["borderRadius"] = "10,10,0,0";
  }

  static dynamic _materialBottomRadius(parsedJson) {
    if (parsedJson["borderRadius"] == "10,10,0,0") {
      parsedJson["borderRadius"] = "10,10,10,10";
    } else {
      parsedJson["borderRadius"] = "0,0,10,10";
    }
  }

}