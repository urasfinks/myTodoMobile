import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import 'FlutterType.dart';

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key, required this.title, this.root = false})
      : super(key: key);

  final String title;
  final bool root;

  @override
  State<DynamicPage> createState() => _DynamicPageState();
}

class _DynamicPageState extends State<DynamicPage> {
  Future<void> _refresh() async {
    print("Refresh");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
        title: Text(widget.title),
        leading: widget.root == true
            ? IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  print("AppBar leading");
                },
              )
            : null,
      ),
      body: Center(
        child: LiquidPullToRefresh(
          color: Colors.blue[600],
          showChildOpacityTransition: false,
          springAnimationDurationInMilliseconds: 500,
          animSpeedFactor: 2,
          height: 90,
          onRefresh: _refresh,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(left: 8, top: 8, right: 8, bottom: 60),
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: FlutterType.main('''{
                        "flutterType": "Row",
                        "crossAxisAlignment": "start", 
                        "children": [
                          {
                            "flutterType": "Container", 
                            "margin": "0,5,10,0", 
                            "child": {
                              "flutterType": "CircleAvatar", 
                              "backgroundImage": {
                                "flutterType": "NetworkImage", 
                                "src": "https://s.imgur.com/images/favicon-32x32.png"
                              }
                            }
                          },
                          {
                            "flutterType": "Expanded", 
                            "child": {
                              "flutterType": "Row", 
                              "crossAxisAlignment": "start", 
                              "children": [
                                {
                                  "flutterType": "SizedBox", 
                                  "width": 10
                                },
                                {
                                  "flutterType": "Expanded", 
                                  "child": {
                                    "flutterType": "Column", 
                                    "crossAxisAlignment": "start", 
                                    "children": [
                                      {
                                        "flutterType": "Text", 
                                        "data": "If you want the same background color, you should use a FlatButton instead, and Colors.transparent to avoid the elevation shadow from the RaisedButton", 
                                        "style": {
                                          "flutterType": "TextStyle", 
                                          "fontSize": 15
                                        }
                                      }, 
                                      {
                                        "flutterType": "Text", 
                                        "data": "Description", 
                                        "style": {
                                          "flutterType": "TextStyle",
                                          "color": "grey", 
                                          "fontSize": 13
                                        }
                                      }
                                    ]
                                  }
                                }
                              ]
                            }
                          }, 
                          {
                            "flutterType": "SizedBox", 
                            "width": 10
                          }, 
                          {
                            "flutterType": "Icon", 
                            "src": "arrow_forward_ios_sharp", 
                            "size": 17
                          }
                        ]
                      }'''),
                onTap: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => const DynamicPage(
                        title: 'Soround',
                        root: false,
                      ),
                    ),
                  );
                },
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }
}
