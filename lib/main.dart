import 'dart:core';
import 'package:flutter/cupertino.dart';
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) {
        return CupertinoPageRoute(
            builder: (_) => const MainPage(), settings: settings);
      },
    );
  }
}

class DynamicPage extends StatefulWidget {
  const DynamicPage({Key? key, required this.title}) : super(key: key);

  final String title;

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
                      builder: (context) => const SecondRoute(
                        title: 'Soround',
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

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: [
          const BottomNavigationBarItem(
            label: 'Главная',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            icon: Badge(
                position: BadgePosition.topEnd(top: 0, end: -22),
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
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                  child: DynamicPage(title: 'Opa 1'));
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                  child: SecondRoute(title: 'Opa 2'));
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                  child: SecondRoute(title: 'Opa 3'));
            });
          default:
            return const CupertinoTabView();
        }
      },
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Go back!'),
        ),
      ),
    );
  }
}
