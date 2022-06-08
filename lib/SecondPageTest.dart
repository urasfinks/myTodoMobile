import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'AppStore.dart';

class SecondPageTest extends StatefulWidget {
  final String title;

  const SecondPageTest({super.key, required this.title});

  @override
  State<SecondPageTest> createState() => _SecondPageTest();
}

class _SecondPageTest extends State<SecondPageTest> {
  @override
  Widget build(BuildContext context) {
    final AppStore store = StoreProvider.of<AppStore>(context).state;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                store.inc('x', step: 2);
                store.apply();
                //Navigator.of(context).pop();
              },
              child: store.connect((context, store) => Text('Go back! ${store.get("x", 0)}')),
            ),
            ElevatedButton(
              onPressed: () {
                store.inc('x1');
                store.set("cart", "${store.get('x1', 0)}");
                store.apply();
                //Navigator.of(context).pop();
              },
              child: store.connect((context, state) => Text('Go back! ${state.get("x1", 0)}')),
            ),
          ],
        ),

      ),
    );
  }
}
