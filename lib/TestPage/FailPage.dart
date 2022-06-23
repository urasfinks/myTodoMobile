import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../DynamicUI/FlutterTypeConstant.dart';

class FailPage extends StatefulWidget {
  final String title;

  const FailPage({super.key, required this.title});

  @override
  State<FailPage> createState() => _FailPage();
}

class _FailPage extends State<FailPage> {
  @override
  Widget build(BuildContext context) {
    String code = "400";
    String titleError = "Ошибка загрузки";
    String descriptionError = "ProjectName: system; ProjectUrl: account; Extra: []";

    return Scaffold(
      backgroundColor: FlutterTypeConstant.parseToMaterialColor("#444444"),
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
          children: [
            const Spacer(),
            Text(
              code,
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 100, color: FlutterTypeConstant.parseToMaterialColor("#FFFFFF"), fontWeight: FontWeight.bold),
            ),
            Text(titleError, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16, color: FlutterTypeConstant.parseToMaterialColor("#FFFFFF"))),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text(descriptionError, style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: Color.fromRGBO(255, 255, 255, 0.5))),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
