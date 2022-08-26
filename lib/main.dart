import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/AppStore.dart';
import 'BoardingPage.dart';
import 'Cache.dart';
import 'TabWrap.dart';

bool firstStart = false;

Future<void> loadPref() async {
  AppStore.cache = await Cache.getInstance();

  //AppStore.cache.remove('key');
  final String? key = AppStore.cache?.get('key');
  if (key == null || "" == key) {
    firstStart = true;
    await AppStore.registerPerson();
  } else {
    AppStore.setPersonKey(key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //accessed before the binding was initialized
  await loadPref();
  if (firstStart == true) {
    runApp(App());
  } else {
    runApp(const Center(child: LifecycleApp()));
  }
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
