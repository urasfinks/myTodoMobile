import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test3/AppStore/AppStoreData.dart';
import 'DynamicUI.dart';
import 'FlutterTypeConstant.dart';
import 'icon.dart';

class FlutterType {
  static Widget defaultWidget = const SizedBox(width: 0);

  static dynamic pText(parsedJson, AppStoreData appStoreData, int index) {
    return Text(
      DynamicUI.def(parsedJson, 'data', '', appStoreData, index),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index),
    );
  }

  static dynamic pTextStyle(parsedJson, AppStoreData appStoreData, int index) {
    return TextStyle(
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData, index)),
      fontSize: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'fontSize', null, appStoreData, index)),
      fontStyle: FlutterTypeConstant.parseToFontStyle(DynamicUI.def(parsedJson, 'fontStyle', null, appStoreData, index)),
      fontWeight: FlutterTypeConstant.parseFontWeight(DynamicUI.def(parsedJson, 'fontWeight', null, appStoreData, index)),
    );
  }

  static dynamic pColumn(parsedJson, AppStoreData appStoreData, int index) {
    return Column(
      crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(
        DynamicUI.def(
          parsedJson,
          'crossAxisAlignment',
          'center',
          appStoreData,
          index
        ),
      )!,
      mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', appStoreData, index))!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index),
    );
  }

  static dynamic pRow(parsedJson, AppStoreData appStoreData, int index) {
    return Row(crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center', appStoreData, index))!, mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', appStoreData, index))!, children: DynamicUI.defList(parsedJson, 'children', appStoreData, index));
  }

  static dynamic pExpanded(parsedJson, AppStoreData appStoreData, int index) {
    return Expanded(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData, index),
    );
  }

  static dynamic pPadding(parsedJson, AppStoreData appStoreData, int index) {
    return Padding(
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null, appStoreData, index))!,
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData, index),
    );
  }

  static dynamic pSizedBox(parsedJson, AppStoreData appStoreData, int index) {
    return SizedBox(
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null, appStoreData, index)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, appStoreData, index)),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index),
    );
  }

  static dynamic pContainer(parsedJson, AppStoreData appStoreData, int index) {
    return Container(
      margin: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'margin', null, appStoreData, index)),
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null, appStoreData, index)),
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null, appStoreData, index)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, appStoreData, index)),
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData, index),
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index),
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', null, appStoreData, index)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData, index)),
    );
  }

  static dynamic pCenter(parsedJson, AppStoreData appStoreData, int index) {
    return Center(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData, index),
    );
  }

  static dynamic pNetworkImage(parsedJson, AppStoreData appStoreData, int index) {
    return NetworkImage(DynamicUI.def(parsedJson, 'src', null, appStoreData, index));
  }

  static dynamic pCircleAvatar(parsedJson, AppStoreData appStoreData, int index) {
    return CircleAvatar(
      backgroundImage: DynamicUI.def(parsedJson, 'backgroundImage', null, appStoreData, index),
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'backgroundColor', null, appStoreData, index)),
      radius: FlutterTypeConstant.parseToDouble(
        DynamicUI.def(parsedJson, 'radius', null, appStoreData, index),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index),
    );
  }

  static dynamic pIcon(parsedJson, AppStoreData appStoreData, int index) {
    return Icon(
      iconsMap[DynamicUI.def(parsedJson, 'src', null, appStoreData, index)],
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData, index)),
      size: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'size', null, appStoreData, index)),
    );
  }

  static dynamic pAssetImage(parsedJson, AppStoreData appStoreData, int index) {
    return AssetImage(DynamicUI.def(parsedJson, 'src', '', appStoreData, index));
  }

  static dynamic pDecorationImage(parsedJson, AppStoreData appStoreData, int index) {
    return DecorationImage(
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData, index),
      fit: FlutterTypeConstant.parseBoxFit(DynamicUI.def(parsedJson, 'fit', null, appStoreData, index)),
      scale: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData, index))!,
      opacity: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData, index))!,
      repeat: FlutterTypeConstant.parseImageRepeat(DynamicUI.def(parsedJson, 'scale', "noRepeat", appStoreData, index))!,
      filterQuality: FilterQuality.high,
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', "center", appStoreData, index))!,
      matchTextDirection: DynamicUI.def(parsedJson, 'matchTextDirection', false, appStoreData, index),
    );
  }

  static dynamic pBoxDecoration(parsedJson, AppStoreData appStoreData, int index) {
    return BoxDecoration(
      color: FlutterTypeConstant.parseToMaterialColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index),
      ),
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData, index),
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index)),
      gradient: DynamicUI.def(parsedJson, 'gradient', null, appStoreData, index),
    );
  }

  static dynamic pSpacer(parsedJson, AppStoreData appStoreData, int index) {
    return const Spacer();
  }

  static dynamic pLinearGradient(parsedJson, AppStoreData appStoreData, int index) {
    return LinearGradient(
      begin: FlutterTypeConstant.parseAlignmentGeometry(
        DynamicUI.def(parsedJson, 'begin', 'centerLeft', appStoreData, index),
      )!,
      colors: FlutterTypeConstant.parseListColor(
        DynamicUI.def(parsedJson, 'colors', null, appStoreData, index),
      ),
    );
  }

  static dynamic pDivider(parsedJson, AppStoreData appStoreData, int index) {
    return Divider(
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, appStoreData, index)),
      thickness: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'thickness', null, appStoreData, index)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData, index)),
    );
  }

  static dynamic pButtonStyle(parsedJson, AppStoreData appStoreData, int index) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'backgroundColor', null, appStoreData, index),
        ),
      ),
      shadowColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'shadowColor', 'transparent', appStoreData, index),
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index))!,
        ),
      ),
    );
  }

  static dynamic pMaterial(parsedJson, AppStoreData appStoreData, int index) {
    return Material(
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData, index)),
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index)),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index),
    );
  }

  static void dynamicFunction(parsedJson, AppStoreData appStoreData, String key, int index){
    Map<String, dynamic> originData = appStoreData.getServerResponse()["Data"][index]["data"];
    List<String> exp = parsedJson[key].toString().split("):");
    List<dynamic> args = [];
    args.add(appStoreData);
    try {
      List<String> exp2 = exp[0].split("(");
      //print(exp2);
      //print(parsedJson);
      if (exp2.length > 1 && originData.containsKey(exp2[1])) {
        args.add(originData[exp2[1]]);
      }
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
    }
    if (args.length == 1) {
      args.add(null);
    }
    //print("ISORIG: ${originData}");
    Function? x = DynamicUI.def(parsedJson, key, null, appStoreData, index);
    if (x != null) {
      Function.apply(x, args);
    }
  }

  static dynamic pElevatedButtonIcon(parsedJson, AppStoreData appStoreData, int index) {
    print(parsedJson);
    return ElevatedButton.icon(
      onPressed: () {
        dynamicFunction(parsedJson, appStoreData, 'onPressed', index);
      },
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index),
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index),
      label: DynamicUI.def(parsedJson, 'label', null, appStoreData, index),
    );
  }

  static dynamic pInkWell(parsedJson, AppStoreData appStoreData, int index) {
    return InkWell(
        customBorder: DynamicUI.def(parsedJson, 'customBorder', null, appStoreData, index),
        splashColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'splashColor', null, appStoreData, index)),
        highlightColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData, index)),
        child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index),
        onTap: () {
          dynamicFunction(parsedJson, appStoreData, 'onTap', index);
        });
  }

  static dynamic pRoundedRectangleBorder(parsedJson, AppStoreData appStoreData, int index) {
    return RoundedRectangleBorder(
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', 0, appStoreData, index))!,
    );
  }

  static dynamic pTextField(parsedJson, AppStoreData appStoreData, int index) {
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData, index);
    String defData = DynamicUI.def(parsedJson, 'data', '', appStoreData, index);
    String type = DynamicUI.def(parsedJson, 'keyboardType', 'text', appStoreData, index);
    bool readOnly = type == "datetime" ? true : false;
    TextEditingController? textController = appStoreData.getTextController(DynamicUI.def(parsedJson, 'name', '-', appStoreData, index), defData);
    appStoreData.set(key, textController?.text);

    return TextField(
      readOnly: readOnly,
      controller: textController,
      obscureText: DynamicUI.def(parsedJson, 'obscureText', false, appStoreData, index),
      obscuringCharacter: DynamicUI.def(parsedJson, 'obscureText', '*', appStoreData, index),
      keyboardType: FlutterTypeConstant.parseToTextInputType(type)!,
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index),
      onChanged: (value) {
        appStoreData.set(key, value);
      },
      onTap: (type == "datetime") ? () async {
        DateTime? pickedDate = await showDatePicker(
            locale : const Locale('ru', 'ru_Ru'),
            context: appStoreData.getCtx()!,
            initialDate: DateTime.now(),
            firstDate: DateTime(1931), //DateTime.now() - not to allow to choose before today.
            lastDate: DateTime(2101),
        );
        if(pickedDate != null ){
          //print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
          String formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
          //print(formattedDate); //formatted date output using intl package =>  2021-03-16
          appStoreData.set(key, formattedDate);
          textController?.text = formattedDate;
        }
      } : (){},
    );
  }

  static dynamic pInputDecoration(parsedJson, AppStoreData appStoreData, int index) {
    return InputDecoration(
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index),
      border: DynamicUI.def(parsedJson, 'border', null, appStoreData, index),
      labelText: DynamicUI.def(parsedJson, 'labelText', '', appStoreData, index),
    );
  }

  static dynamic pUnderlineInputBorder(parsedJson, AppStoreData appStoreData, int index) {
    return UnderlineInputBorder(
      borderSide: DynamicUI.def(parsedJson, 'borderSide', const BorderSide(), appStoreData, index),
      borderRadius: DynamicUI.def(
        parsedJson,
        'borderRadius',
        const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        appStoreData,
        index,
      ),
    );
  }

  static dynamic pBorderSize(parsedJson, AppStoreData appStoreData, int index) {
    return BorderSide(color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', '#f5f5f5', appStoreData, index))!, width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', 1, appStoreData, index))!, style: FlutterTypeConstant.parseToBorderStyle(DynamicUI.def(parsedJson, 'style', BorderStyle.solid, appStoreData, index))!);
  }

}
