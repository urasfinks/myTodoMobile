import 'dart:core';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/AppStore.dart';
import 'Cache.dart';
import 'TabWrap.dart';

Future<void> loadPref() async {
  AppStore.cache = await Cache.getInstance();

  //AppStore.cache.remove('key');
  final String? key = AppStore.cache?.get('key');
  if (key == null || "" == key) {
    await AppStore.registerPerson();
  } else {
    AppStore.setPersonKey(key);
  }
}

AppMetricaConfig get _config => const AppMetricaConfig('e0efc97c-b1aa-4c88-813a-fa1ef1ea20ed', logs: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //accessed before the binding was initialized
  AppMetrica.runZoneGuarded(() {
    AppMetrica.activate(_config);
  });
  //AppMetrica.activate(const AppMetricaConfig("e0efc97c-b1aa-4c88-813a-fa1ef1ea20ed"));

  await loadPref();
  //runApp(MyPage());
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
