import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test3/AppStore/AppStore.dart';
import 'package:test3/SecondPageTest.dart';
import 'DynamicPage.dart';
//import 'WebSocket.dart';

class TabWrap extends StatefulWidget {
  final BuildContext context;
  const TabWrap(this.context, {Key? key}) : super(key: key);

  @override
  State<TabWrap> createState() => _TabWrapState();
}

class _TabWrapState extends State<TabWrap> {

  @override
  Widget build(BuildContext context) {
    //WebSocket().subscribe("TabPage");
    AppStore.getStore(context, "TabPage");
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
                context,
                (store, def) => Text(
                  store != null ? store.get("cart", '0') : def,
                  style: const TextStyle(color: Colors.white, fontSize: 8),
                ),
                defaultValue: '0'
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
                child: SecondPageTest(title: 'Opa 1'),
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
              builder: (context) => CupertinoPageScaffold(
                child: DynamicPage(
                  title: 'Opa 1',
                  url: 'http://jamsys.ru:8081/project/system',
                  parentState: "",
                  root: true,
                  dataUID: AppStore.personKey,
                ),
              ),
            );
          default:
            return const CupertinoTabView();
        }
      },
    );
  }
}
