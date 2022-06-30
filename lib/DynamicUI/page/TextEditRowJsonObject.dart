class TextEditRowJsonObject {
  static dynamic getPage() {
    return {
      "Separated": false,
      "WidgetData":{
        "wrapPage":{
          "flutterType": "Container",
          "color": "white",
          "padding": "20,0,10,0",
          "child": "()=>getFutureBuilder"
        }
      },
      "list": [
        {
          "flutterType": "TextField",
          "decoration": {
            "flutterType": "InputDecoration",
            "border": {
              "flutterType": "UnderlineInputBorder"
            },
            "labelText": "Имя Отчество"
          },
          "data": ""
        }
      ]
    };
  }
}