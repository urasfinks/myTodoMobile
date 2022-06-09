import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    final AppStore store = context.watch<AppStore>();
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
                store.inc('x1', step: 2);
                store.apply();
                //Navigator.of(context).pop();
              },
              child: Text('Go back! ${store.get("x1", 0)}'),
            ),
          ],
        ),

      ),
    );
  }
}
