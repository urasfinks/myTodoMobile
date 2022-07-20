import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test3/AppStore/AppStore.dart';
import 'package:test3/DynamicUI/FlutterTypeConstant.dart';
import 'package:test3/TabPageHistory.dart';
import 'AppStore/AppStoreData.dart';
import 'DynamicPage/DynamicPage.dart';
import 'DynamicPage/DynamicPageUtil.dart';
//import 'WebSocket.dart';

class TabWrap extends StatefulWidget {
  final BuildContext context;

  const TabWrap(this.context, {Key? key}) : super(key: key);

  @override
  State<TabWrap> createState() => _TabWrapState();
}

class TabScope{ // singleton class
  static TabScope? _tabScope;
  final List<TabPageHistory> pages = [
    TabPageHistory(
      DynamicPage.fromMap(
        {
          "title": 'Доступные сервисы',
          "url": '/project/system',
          "backgroundColor": "#f5f5f5",
          "pullToRefreshBackgroundColor": "blue.600",
          "progressIndicatorBackgroundColor": "#ffffff",
          "root": true,
          "config": {
            "crossAxisCount": 2,
            "crossAxisSpacing": 10.0
          },
          "grid": true
        },
      ),
    ),
    TabPageHistory(
      DynamicPage.fromMap(
        {
          "title": 'Аккаунт',
          "url": '/project/system/account',
          "backgroundColor": "blue.600",
          "pullToRefreshBackgroundColor": "blue.600",
          "progressIndicatorBackgroundColor": "#ffffff",
          "root": true,
        },
      ),
    ),
  ];
  int tabIndex = 0;

  void addHistory(AppStoreData appStoreData){
    if(!pages[tabIndex].history.contains(appStoreData)){
      pages[tabIndex].history.add(appStoreData);
    }
  }

  void onDestroyPage(AppStoreData appStoreData){
    if(pages[tabIndex].history.length > 1){
      if(pages[tabIndex].history.last == appStoreData){
        pages[tabIndex].history.removeLast();
      }
    }
  }

  bool iamActivePage(AppStoreData appStoreData){
    if(pages[tabIndex].history.isNotEmpty){
      return pages[tabIndex].history.last == appStoreData;
    }
    return false;
  }

  void popHistory(dynamic data){
    if(pages[tabIndex].history.length > 1){
      if(data != null && data["url"] != null){
        while(pages[tabIndex].history.length > 1){
          if(pages[tabIndex].history.last.getWidgetData("url") == data["url"]){
            break;
          }
          AppStoreData last = pages[tabIndex].history.removeLast();
          Navigator.pop(last.getCtx()!);
          whatNext(pages[tabIndex].history.last, last.getParentUpdate());
        }
      }else if(data != null && data["count"] != null){
          for(int i=0;i<data["count"];i++){
            AppStoreData last = pages[tabIndex].history.removeLast();
            Navigator.pop(last.getCtx()!);
            whatNext(pages[tabIndex].history.last, last.getParentUpdate());
          }
      }else{
        AppStoreData last = pages[tabIndex].history.removeLast();
        Navigator.pop(last.getCtx()!);
        whatNext(pages[tabIndex].history.last, last.getParentUpdate());
      }
    }
  }

  void whatNext(AppStoreData appStoreData, bool parentUpdate){
    if(appStoreData.needUpdateOnActive || parentUpdate){
      DynamicPageUtil.loadData(appStoreData);
    }
  }

  static TabScope getInstance(){
    _tabScope ??= TabScope();
    return _tabScope!;
  }
  void setTabIndex(int index){
    //print("SELECTED TAB: ${index}");
    tabIndex = index;
  }
}

class _TabWrapState extends State<TabWrap> {


  final TabScope _tabScope = TabScope.getInstance();

  @override
  Widget build(BuildContext context) {
    //WebSocket().subscribe("TabPage");
    //AppStore.getStore(context);
    int lastClick = DateTime.now().millisecondsSinceEpoch;
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        onTap: (index) {
          int x = DateTime.now().millisecondsSinceEpoch;
          if(x - lastClick < 200){ //NICE!) IT's Double Tap!)
            TabScope.getInstance().popHistory({"url": ""});
          }
          lastClick = x;
          return _tabScope.setTabIndex(index);
        },
        backgroundColor: FlutterTypeConstant.parseColor("#fafafa"),
        activeColor: Colors.blue[600],
        border: const Border(),
        currentIndex: _tabScope.tabIndex,
        items: const [
          BottomNavigationBarItem(
            label: 'Сервисы',
            icon: Icon(Icons.dashboard),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Аккаунт',

          ),
        ],
      ),
      tabBuilder: (context, index) {
        AppStore.selectedTabIndex = index;
        return CupertinoTabView(
          builder: (context) {
            return _tabScope.pages[index].page;
          },
        );
      },
    );
  }
}

/*BottomNavigationBarItem(
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
          ),*/
