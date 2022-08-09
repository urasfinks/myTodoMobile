import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/AppStore.dart';
import 'Cache.dart';
import 'TabWrap.dart';

Future<void> loadPref() async {
  AppStore.cache = await Cache.getInstance();
  //prefs.remove('key');
  final String? key = AppStore.cache?.get('key');
  if (key == null || "" == key) {
    await AppStore.registerPerson();
  } else {
    AppStore.setPersonKey(key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //accessed before the binding was initialized
  await loadPref();
  //runApp(MyPage());
  runApp(const Center(child: LifecycleWatcher()));
}

class LifecycleWatcher extends StatefulWidget {
  const LifecycleWatcher({super.key});

  @override
  State<LifecycleWatcher> createState() => _LifecycleWatcherState();
}

class _LifecycleWatcherState extends State<LifecycleWatcher> with WidgetsBindingObserver {
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
      child: MaterialApp(
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
    );
  }
}
