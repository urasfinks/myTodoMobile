import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test3/AppStore/AppStore.dart';
import 'package:test3/DynamicUI/page/AccountPage.dart';
import 'package:test3/DynamicUI/page/FailPage.dart';
import 'DynamicPage/DynamicPage.dart';
//import 'WebSocket.dart';

class TabWrap extends StatefulWidget {
  final BuildContext context;

  const TabWrap(this.context, {Key? key}) : super(key: key);

  @override
  State<TabWrap> createState() => _TabWrapState();
}

class _TabWrapState extends State<TabWrap> {
  final List<Widget> _pages = [
    const AccountPage(title: 'Аккаунт'),
    const FailPage(title: 'Opa 2'),
    DynamicPage.fromMap(
      {
        "title": 'Аккаунт',
        "url": 'project/system/account',
        "parentState": "",
        //dataUID: AppStore.personKey,
        "backgroundColor": "blue.600",
        "pullToRefreshBackgroundColor": "blue.600",
        "progressIndicatorBackgroundColor": "#ffffff",
        "root": true,
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //WebSocket().subscribe("TabPage");
    //AppStore.getStore(context);
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 2,
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
              badgeContent: AppStore.connect(
                  "",
                  (store, def) => Text(
                        store != null ? store.get("cart", '0') : def,
                        style: const TextStyle(color: Colors.white, fontSize: 8),
                      ),
                  defaultValue: '0'),
              child: const Icon(Icons.business),
            ),
            label: 'Организация',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Аккаунт',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _pages[index];
          },
        );
      },
    );
  }
}
