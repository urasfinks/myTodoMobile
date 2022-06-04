import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:badges/badges.dart';

import 'package:test3/FlutterType.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Hello world'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  Symbol lib2 = const Symbol('Text');

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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            print("AppBar leading");
          },
        ),
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
            padding: const EdgeInsets.all(8),
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return FlutterType.main(
                  '''{
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
                      }''');
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        items: [
          const BottomNavigationBarItem(
            label: 'Главная',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Badge(
                position: BadgePosition.topEnd(top: -5, end: -22),
                shape: BadgeShape.square,
                borderRadius: BorderRadius.circular(10),
                badgeContent: const Text(
                  '4500',
                  style: TextStyle(color: Colors.white, fontSize: 8),
                ),
                child: const Icon(Icons.business)),
            label: 'Организация',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Аккаунт',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          print("TabBar");
        },
      ),
    );
  }
}
