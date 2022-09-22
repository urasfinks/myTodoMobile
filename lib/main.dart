import 'dart:core';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/GlobalData.dart';
import 'Cache.dart';
import 'SliversApp.dart';
import 'TabScope.dart';
import 'TabWrap.dart';
import 'Util.dart';

Future<void> loadPref() async {
  GlobalData.cache = await Cache.getInstance();

  //AppStore.cache.remove('key');
  final String? key = GlobalData.cache?.get('key');
  if (key == null || "" == key) {
    GlobalData.firstStart = true;
    await GlobalData.registerPerson();
  } else {
    GlobalData.setPersonKey(key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //accessed before the binding was initialized
  //GestureBinding.instance.resamplingEnabled = true; // Set this flag.
  if(Util.isIOs()){
    GestureBinding.instance!.resamplingEnabled = true;
    GestureBinding.instance!.samplingOffset = const Duration(milliseconds: -18);
    //GestureBinding.instance!.resamplingEnabled = true;
  }
  await loadPref();
  Util.handleIncomingLinks();
  Util.handleInitialUri();
  runApp(const LifecycleApp());
  //runApp(const SliversApp());
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
    return GestureDetector(
      key: UniqueKey(),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        key: UniqueKey(),
        navigatorObservers: [ClearFocusOnPush()],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        home: WillPopScope(
          key: UniqueKey(),
          onWillPop: () async {
            //Замена события
            return !TabScope.getInstance().popHistory(null);
          },
          child: Material(
            key: UniqueKey(),
            child: const TabWrap(),
          ),
        ),
      ),
    );
  }
}

void testCacheRemove() async {
  for (int i = 0; i < 25; i++) {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    GlobalData.cache?.pageAdd("p_$i", "0");
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
