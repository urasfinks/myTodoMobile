import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../FlutterTypeConstant.dart';

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
      backgroundColor: FlutterTypeConstant.parseToMaterialColor("#f9fafa"),
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 0,
        backgroundColor: Colors.blue[600],
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent, // Status bar
        ),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: NetworkImage("http://jamsys.ru:8081/404.jpg"),
                fit: BoxFit.fitWidth,
                alignment: Alignment.topCenter
            )
        ),
        child: Column(
          children: [
            const SizedBox(height: 100, width: 300,),
            Text(
              code,
              style: TextStyle(fontStyle: FontStyle.normal, fontSize: 100, color: FlutterTypeConstant.parseToMaterialColor("#434a54"), fontWeight: FontWeight.bold),
            ),
            Text(titleError, style: TextStyle(fontStyle: FontStyle.normal, fontSize: 16, color: FlutterTypeConstant.parseToMaterialColor("#6c7787"))),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 0.0),
              child: Text(descriptionError, style: const TextStyle(fontStyle: FontStyle.normal, fontSize: 12, color: Color.fromRGBO(108, 119, 135, 0.5))),
            ),

          ],
        ),
      ),
    );
  }
}


