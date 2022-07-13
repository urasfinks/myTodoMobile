import '../../WebSocket.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test3/AppStore/AppStore.dart';
import '../../AppStore/AppStoreData.dart';
import '../../AppStore/Invoke.dart';

class SecondPageTest extends StatefulWidget {
  final String title;

  const SecondPageTest({super.key, required this.title});

  @override
  State<SecondPageTest> createState() => _SecondPageTest();
}

class _SecondPageTest extends State<SecondPageTest> {

  @override
  Widget build(BuildContext context) {
    WebSocket().subscribe(widget.title);
    final AppStoreData store = AppStore.getStore(context);
    store.setOnIndexRevisionError(() {
      print("Reload page");
    });
    //final AppStoreData? storeTabPage = AppStore.getStoreByDataUID(context, "TabPage");

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
              child: AppStore.connect(
                  store, (def) => Text('Go back! ${store.get("x", 0)}'), defaultValue: 0),
            ),
            ElevatedButton(
              onPressed: () {
                store.inc('x1');
                store.apply();

                /*if (storeTabPage != null) {
                  storeTabPage.set("cart", "${store?.get('x1', 0)}");
                  storeTabPage.apply();
                }*/
                //Navigator.of(context).pop();
              },
              child: AppStore.connect(
                  store, (def) => Text('Go back! ${store.get("x1", 0)}'), defaultValue: 0),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    Invoke.apply(store, '{"fn":"dec", "arg":{"key":"c1"}, "extra":{"min": 1.0}}');
                    //Invoke.apply(store, '{"fn":"set", "arg":{"key":"c1", "value":"opa"}, "extra":{"step":2, "min": 1}}');
                  },
                  padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                ),
                AppStore.connect(
                    store, (def) => Text("${store.get('c1', 1)}"), defaultValue: 1),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                      Invoke.apply(store, '{"fn":"inc", "arg":{"key":"c1"}, "extra":{"max": 10.0}}');
                  },
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

}


