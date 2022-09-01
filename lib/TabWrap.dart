import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myTODO/AppStore/AppStore.dart';
import 'package:myTODO/DynamicUI/FlutterTypeConstant.dart';

import 'TabScope.dart';
//import 'WebSocket.dart';

class TabWrap extends StatefulWidget {
  final BuildContext context;

  const TabWrap(this.context, {Key? key}) : super(key: key);

  @override
  State<TabWrap> createState() => TabWrapState();
}

class TabWrapState extends State<TabWrap> {
  final TabScope _tabScope = TabScope.getInstance();

  selectTab(int index) {
    if (AppStore.selectedTabIndex != index) {
      _tabScope.setTabIndex(index);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    AppStore.tabWrapState = this;
    int lastClick = DateTime.now().millisecondsSinceEpoch;

    CupertinoTabBar cupertinoTabBar = CupertinoTabBar(
      onTap: (index) {
        int x = DateTime.now().millisecondsSinceEpoch;
        if (x - lastClick < 200) {
          //NICE!) IT's Double Tap!)
          TabScope.getInstance().popHistory({"url": ""});
        }
        lastClick = x;
        _tabScope.setTabIndex(index);
      },
      backgroundColor: FlutterTypeConstant.parseColor("#fafafa"),
      activeColor: Colors.blue[600],
      border: const Border(),
      items: const [
        BottomNavigationBarItem(
          label: 'Главная',
          icon: Icon(Icons.dashboard),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Аккаунт',
        ),
      ],
    );

    return CupertinoTabScaffold(
      controller: CupertinoTabController(initialIndex: _tabScope.tabIndex),
      tabBar: cupertinoTabBar,
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return _tabScope.tabs[index].page;
          },
        );
      },
    );
  }
}
