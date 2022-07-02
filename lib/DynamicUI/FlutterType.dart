import 'package:flutter/material.dart';
import 'package:test3/AppStore/AppStoreData.dart';
import 'DynamicUI.dart';
import 'FlutterTypeConstant.dart';
import 'icon.dart';

class FlutterType {
  static Widget defaultWidget = const SizedBox(width: 0);

  static dynamic pText(parsedJson, AppStoreData appStoreData) {
    return Text(
      DynamicUI.def(parsedJson, 'data', '', appStoreData),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData),
    );
  }

  static dynamic pTextStyle(parsedJson, AppStoreData appStoreData) {
    return TextStyle(
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData)),
      fontSize: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'fontSize', null, appStoreData)),
      fontStyle: FlutterTypeConstant.parseToFontStyle(DynamicUI.def(parsedJson, 'fontStyle', null, appStoreData)),
      fontWeight: FlutterTypeConstant.parseFontWeight(DynamicUI.def(parsedJson, 'fontWeight', null, appStoreData)),
    );
  }

  static dynamic pColumn(parsedJson, AppStoreData appStoreData) {
    return Column(
      crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(
        DynamicUI.def(
          parsedJson,
          'crossAxisAlignment',
          'center',
          appStoreData,
        ),
      )!,
      mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', appStoreData))!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData),
    );
  }

  static dynamic pRow(parsedJson, AppStoreData appStoreData) {
    return Row(crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center', appStoreData))!, mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', appStoreData))!, children: DynamicUI.defList(parsedJson, 'children', appStoreData));
  }

  static dynamic pExpanded(parsedJson, AppStoreData appStoreData) {
    return Expanded(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData),
    );
  }

  static dynamic pPadding(parsedJson, AppStoreData appStoreData) {
    return Padding(
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null, appStoreData))!,
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData),
    );
  }

  static dynamic pSizedBox(parsedJson, AppStoreData appStoreData) {
    return SizedBox(
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null, appStoreData)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, appStoreData)),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData),
    );
  }

  static dynamic pContainer(parsedJson, AppStoreData appStoreData) {
    return Container(
      margin: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'margin', null, appStoreData)),
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null, appStoreData)),
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null, appStoreData)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, appStoreData)),
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData),
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData),
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', null, appStoreData)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData)),
    );
  }

  static dynamic pCenter(parsedJson, AppStoreData appStoreData) {
    return Center(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, appStoreData),
    );
  }

  static dynamic pNetworkImage(parsedJson, AppStoreData appStoreData) {
    return NetworkImage(DynamicUI.def(parsedJson, 'src', null, appStoreData));
  }

  static dynamic pCircleAvatar(parsedJson, AppStoreData appStoreData) {
    return CircleAvatar(
      backgroundImage: DynamicUI.def(parsedJson, 'backgroundImage', null, appStoreData),
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'backgroundColor', null, appStoreData)),
      radius: FlutterTypeConstant.parseToDouble(
        DynamicUI.def(parsedJson, 'radius', null, appStoreData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData),
    );
  }

  static dynamic pIcon(parsedJson, AppStoreData appStoreData) {
    return Icon(
      iconsMap[DynamicUI.def(parsedJson, 'src', null, appStoreData)],
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData)),
      size: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'size', null, appStoreData)),
    );
  }

  static dynamic pAssetImage(parsedJson, AppStoreData appStoreData) {
    return AssetImage(DynamicUI.def(parsedJson, 'src', '', appStoreData));
  }

  static dynamic pDecorationImage(parsedJson, AppStoreData appStoreData) {
    return DecorationImage(
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData),
      fit: FlutterTypeConstant.parseBoxFit(DynamicUI.def(parsedJson, 'fit', null, appStoreData)),
      scale: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData))!,
      opacity: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData))!,
      repeat: FlutterTypeConstant.parseImageRepeat(DynamicUI.def(parsedJson, 'scale', "noRepeat", appStoreData))!,
      filterQuality: FilterQuality.high,
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', "center", appStoreData))!,
      matchTextDirection: DynamicUI.def(parsedJson, 'matchTextDirection', false, appStoreData),
    );
  }

  static dynamic pBoxDecoration(parsedJson, AppStoreData appStoreData) {
    return BoxDecoration(
      color: FlutterTypeConstant.parseToMaterialColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData),
      ),
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData),
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData)),
      gradient: DynamicUI.def(parsedJson, 'gradient', null, appStoreData),
    );
  }

  static dynamic pSpacer(parsedJson, AppStoreData appStoreData) {
    return const Spacer();
  }

  static dynamic pLinearGradient(parsedJson, AppStoreData appStoreData) {
    return LinearGradient(
      begin: FlutterTypeConstant.parseAlignmentGeometry(
        DynamicUI.def(parsedJson, 'begin', 'centerLeft', appStoreData),
      )!,
      colors: FlutterTypeConstant.parseListColor(
        DynamicUI.def(parsedJson, 'colors', null, appStoreData),
      ),
    );
  }

  static dynamic pDivider(parsedJson, AppStoreData appStoreData) {
    return Divider(
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, appStoreData)),
      thickness: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'thickness', null, appStoreData)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData)),
    );
  }

  static dynamic pElevatedButtonIcon(parsedJson, AppStoreData appStoreData) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData),
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData),
      label: DynamicUI.def(parsedJson, 'label', null, appStoreData),
    );
  }

  static dynamic pButtonStyle(parsedJson, AppStoreData appStoreData) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'backgroundColor', null, appStoreData),
        ),
      ),
      shadowColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'shadowColor', 'transparent', appStoreData),
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData))!,
        ),
      ),
    );
  }

  static dynamic pMaterial(parsedJson, AppStoreData appStoreData) {
    return Material(
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, appStoreData)),
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData)),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData),
    );
  }

  static dynamic pInkWell(parsedJson, AppStoreData appStoreData) {
    return InkWell(
        customBorder: DynamicUI.def(parsedJson, 'customBorder', null, appStoreData),
        splashColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'splashColor', null, appStoreData)),
        highlightColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData)),
        child: DynamicUI.def(parsedJson, 'child', null, appStoreData),
        onTap: () {
          List<String> exp = parsedJson['onTap'].toString().split("):");
          List<dynamic> args = [];
          args.add(appStoreData);
          try {
            List<String> exp2 = exp[0].split("(");
            if (exp2.length > 1 && parsedJson.containsKey(exp2[1])) {
              args.add(parsedJson[exp2[1]]);
            }
          } catch (e, stacktrace) {
            print(e);
            print(stacktrace);
          }
          if (args.length == 1) {
            args.add(null);
          }
          Function? x = DynamicUI.def(parsedJson, 'onTap', null, appStoreData);
          if (x != null) {
            Function.apply(x, args);
          }
        });
  }

  static dynamic pRoundedRectangleBorder(parsedJson, AppStoreData appStoreData) {
    return RoundedRectangleBorder(
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', 0, appStoreData))!,
    );
  }

  static dynamic pTextField(parsedJson, AppStoreData appStoreData) {
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData);

    return TextField(
      controller: appStoreData.getTextController(DynamicUI.def(parsedJson, 'name', '-', appStoreData), DynamicUI.def(parsedJson, 'data', '', appStoreData)),
      obscureText: DynamicUI.def(parsedJson, 'obscureText', false, appStoreData),
      obscuringCharacter: DynamicUI.def(parsedJson, 'obscureText', '*', appStoreData),
      keyboardType: FlutterTypeConstant.parseToTextInputType(DynamicUI.def(parsedJson, 'keyboardType', 'text', appStoreData))!,
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData),
      onChanged: (value) {
        appStoreData.set(key, value);
      },
    );
  }

  static dynamic pInputDecoration(parsedJson, AppStoreData appStoreData) {
    return InputDecoration(
      border: DynamicUI.def(parsedJson, 'border', null, appStoreData),
      labelText: DynamicUI.def(parsedJson, 'labelText', '', appStoreData),
    );
  }

  static dynamic pUnderlineInputBorder(parsedJson, AppStoreData appStoreData) {
    return UnderlineInputBorder(
      borderSide: DynamicUI.def(parsedJson, 'borderSide', const BorderSide(), appStoreData),
      borderRadius: DynamicUI.def(
        parsedJson,
        'borderRadius',
        const BorderRadius.only(
          topLeft: Radius.circular(4.0),
          topRight: Radius.circular(4.0),
        ),
        appStoreData,
      ),
    );
  }

  static dynamic pBorderSize(parsedJson, AppStoreData appStoreData) {
    return BorderSide(color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', '#f5f5f5', appStoreData))!, width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', 1, appStoreData))!, style: FlutterTypeConstant.parseToBorderStyle(DynamicUI.def(parsedJson, 'style', BorderStyle.solid, appStoreData))!);
  }

}
