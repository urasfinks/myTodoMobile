import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'AppStore.dart';
import 'TabPage.dart';

void main() {
  runApp(const RouterPage());
}

class RouterPage extends StatelessWidget {
  const RouterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreProvider(
      store: AppStore.store,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: (RouteSettings settings) {
          return CupertinoPageRoute(
              builder: (_) => const TabPage(), settings: settings);
        },
      ),
    );
  }
}
