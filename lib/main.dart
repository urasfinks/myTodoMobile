import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'AppStore/AppStore.dart';
import 'TabWrap.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' show utf8, base64;

Future<void> loadPref() async {
  final prefs = await SharedPreferences.getInstance();
  //prefs.remove('key');
  final String? key = prefs.getString('key');
  if(key == null || "" == key){
    print("URL: ${AppStore.host}/person/${AppStore.personKey}");
    final response = await http.get(Uri.parse("${AppStore.host}/person/${AppStore.personKey}"));
    if (response.statusCode == 200) {
      await prefs.setString('key', AppStore.personKey);
    }
  }
  AppStore.personKey = prefs.getString('key') ?? 'undefined';
  AppStore.personKeyBasicAuth = base64.encode(utf8.encode("PersonKey:${AppStore.personKey}"));
  print("Person key: ${AppStore.personKey}");
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
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute(builder: (context) => TabWrap(context), settings: settings);
        },
      ),
    );
  }
}
