class ErrorPageJsonObject{
  static dynamic getPage(String status, String errorSide, String error){
    return {
      "WidgetData": {
        "backgroundColor": "#fafafa"
      },
      "list": [
        {
          "flutterType": "Container",
          "width": 1200,
          "decoration":{
            "flutterType": "BoxDecoration",
            "image":{
              "flutterType": "DecorationImage",
              "image": {
                "flutterType": "NetworkImage",
                "src": "http://jamsys.ru:8081/404.jpg"
              },
              "fit": "fitWidth",
              "alignment": "topCenter"
            }
          },
          "child":{
            "flutterType": "Column",
            "children":[
              {
                "flutterType": "SizedBox",
                "height": 110
              },
              {
                "flutterType": "Text",
                "data": status,
                "style": {
                  "flutterType": "TextStyle",
                  "fontStyle": "normal",
                  "fontWeight": "bold",
                  "fontSize": 100,
                  "color": "#434a54",
                }
              },
              {
                "flutterType": "Text",
                "data": errorSide,
                "style": {
                  "flutterType": "TextStyle",
                  "fontSize": 16,
                  "color": "#6c7787",
                }
              },
              {
                "flutterType": "SizedBox",
                "height": 16
              },
              {
                "flutterType": "Padding",
                "padding": "20,0,20,0",
                "child": {
                  "flutterType": "Text",
                  "data": error,
                  "style": {
                    "flutterType": "TextStyle",
                    "fontSize": 12,
                    "color": "rgba:108,119,135,0.5",
                  }
                }
              }
            ]
          }
        }
      ]
    };
  }
}