import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/AppStore.dart';
import 'Cache.dart';
import 'TabWrap.dart';
import 'package:uni_links/uni_links.dart';



void _handleIncomingLinks() {
    uriLinkStream.listen((Uri? uri) {
      print('got uri 1: $uri');
    }, onError: (Object err) {
      print('got err: $err');
    });
}

Future<void> _handleInitialUri() async {
  final uri = await getInitialUri();
  print('got uri 2: $uri');
}




Future<void> loadPref() async {
  AppStore.cache = await Cache.getInstance();

  //AppStore.cache.remove('key');
  final String? key = AppStore.cache?.get('key');
  if (key == null || "" == key) {
    AppStore.firstStart = true;
    await AppStore.registerPerson();
  } else {
    AppStore.setPersonKey(key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //accessed before the binding was initialized
  await loadPref();
  _handleIncomingLinks();
  _handleInitialUri();
  runApp(const Center(child: LifecycleApp()));
}

class LifecycleApp extends StatefulWidget {
  const LifecycleApp({super.key});

  @override
  State<LifecycleApp> createState() => _LifecycleAppState();
}

class _LifecycleAppState extends State<LifecycleApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    TabScope.getInstance().getLast()?.didChangeAppLifecycleState(state);
    //DynamicFn.alert(TabScope.getInstance().getLast()!, {"data": state.toString()});
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: AppStore.store,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          navigatorObservers: [ClearFocusOnPush()],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          debugShowCheckedModeBanner: false,
          home: WillPopScope(
            onWillPop: () async {
              //Замена события
              TabScope.getInstance().popHistory(null);
              return false;
            },
            child: TabWrap(context),
          ),
        ),
      ),
    );
  }
}

void testCacheRemove() async {
  for (int i = 0; i < 25; i++) {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    AppStore.cache?.pageAdd("p_$i", "0");
  }
}

class ClearFocusOnPush extends NavigatorObserver {
  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    final focus = FocusManager.instance.primaryFocus;
    focus?.unfocus();
  }
}
