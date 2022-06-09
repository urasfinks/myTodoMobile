import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test3/AppStore.dart';
import 'AppStoreData.dart';

class SecondPageTest extends StatefulWidget {
  final String title;

  const SecondPageTest({super.key, required this.title});

  @override
  State<SecondPageTest> createState() => _SecondPageTest();
}

class _SecondPageTest extends State<SecondPageTest> {
  @override
  Widget build(BuildContext context) {

    final AppStoreData store = AppStore.getStore(context, widget.title);
    final AppStoreData? storeTabPage = AppStore.getStoreByName(context, "TabPage");

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
              child: AppStore.connect(context, (store) => Text('Go back! ${store.get("x", 0)}')),
            ),
            ElevatedButton(
              onPressed: () {
                store.inc('x1');
                store.apply();

                if(storeTabPage != null){
                  storeTabPage.set("cart", "${store.get('x1', 0)}");
                  storeTabPage.apply();
                }
                //Navigator.of(context).pop();
              },
              child: AppStore.connect(context, (store) => Text('Go back! ${store.get("x1", 0)}')),
            ),
          ],
        ),
      ),
    );
  }
}
