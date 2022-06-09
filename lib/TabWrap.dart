import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test3/AppStore.dart';
import 'package:test3/SecondPageTest.dart';
import 'DynamicPage.dart';

class TabWrap extends StatefulWidget {
  const TabWrap({Key? key}) : super(key: key);

  @override
  State<TabWrap> createState() => _TabWrapState();
}

class _TabWrapState extends State<TabWrap> {
  @override
  Widget build(BuildContext context) {
    AppStore.getStore(context, "TabPage");
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: 1,
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
                context,
                (store) => Text(
                  store.get("cart", '0'),
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
              ),
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
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const CupertinoPageScaffold(
                child: DynamicPage(
                  title: 'Opa 1',
                  url: 'http://jamsys.ru/json/1.json',
                  root: true,
                ),
              ),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const CupertinoPageScaffold(
                child: SecondPageTest(title: 'Opa 2'),
              ),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const CupertinoPageScaffold(
                child: SecondPageTest(title: 'Opa 3'),
              ),
            );
          default:
            return const CupertinoTabView();
        }
      },
    );
  }
}
