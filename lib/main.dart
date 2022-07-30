import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/AppStore.dart';
import 'TabWrap.dart';

Future<void> loadPref() async {
  final prefs = await SharedPreferences.getInstance();
  //prefs.remove('key');
  final String? key = prefs.getString('key');
  if (key == null || "" == key) {
    await AppStore.registerPerson(prefs);
  } else {
    AppStore.setPersonKey(key);
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //accessed before the binding was initialized
  await loadPref();
  runApp(const RouterPage());
}

class RouterPage extends StatelessWidget {
  const RouterPage({Key? key}) : super(key: key);

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
