import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test3/SecondPageTest.dart';

import 'DynamicPage.dart';

class TabPage extends StatefulWidget {
  const TabPage({Key? key}) : super(key: key);

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {
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
                  child: DynamicPage(
                title: 'Opa 1',
                url: 'http://jamsys.ru/json/1.json',
                root: true,
              ));
            });
          case 1:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                  child: SecondPageTest(title: 'Opa 2'));
            });
          case 2:
            return CupertinoTabView(builder: (context) {
              return const CupertinoPageScaffold(
                  child: SecondPageTest(title: 'Opa 3'));
            });
          default:
            return const CupertinoTabView();
        }
      },
    );
  }
}
