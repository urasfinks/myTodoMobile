import 'package:flutter/material.dart';
import 'DynamicUI.dart';
import 'FlutterTypeConstant.dart';
import 'icon.dart';

class FlutterType {
  static Widget defaultWidget = const SizedBox(width: 0);

  static dynamic pText(parsedJson) {
    return Text(
      DynamicUI.def(parsedJson, 'data', ''),
      style: DynamicUI.def(parsedJson, 'style', null),
    );
  }

  static dynamic pTextStyle(parsedJson) {
    return TextStyle(
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null)),
      fontSize: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'fontSize', null)),
      fontStyle: FlutterTypeConstant.parseToFontStyle(DynamicUI.def(parsedJson, 'fontStyle', null)),
      fontWeight: FlutterTypeConstant.parseFontWeight(DynamicUI.def(parsedJson, 'fontWeight', null)),
    );
  }

  static dynamic pColumn(parsedJson) {
    return Column(
      crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center'))!,
      mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start'))!,
      children: DynamicUI.defList(parsedJson, 'children'),
    );
  }

  static dynamic pRow(parsedJson) {
    return Row(crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center'))!, mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start'))!, children: DynamicUI.defList(parsedJson, 'children'));
  }

  static dynamic pExpanded(parsedJson) {
    return Expanded(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget),
    );
  }

  static dynamic pPadding(parsedJson) {
    return Padding(
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null))!,
      child: DynamicUI.def(parsedJson, 'child', defaultWidget),
    );
  }

  static dynamic pSizedBox(parsedJson) {
    return SizedBox(
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null)),
      child: DynamicUI.def(parsedJson, 'child', null),
    );
  }

  static dynamic pContainer(parsedJson) {
    return Container(
      margin: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'margin', null)),
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null)),
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null)),
      child: DynamicUI.def(parsedJson, 'child', defaultWidget),
      decoration: DynamicUI.def(parsedJson, 'decoration', null),
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', null)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null)),
    );
  }

  static dynamic pCenter(parsedJson) {
    return Center(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget),
    );
  }

  static dynamic pNetworkImage(parsedJson) {
    return NetworkImage(DynamicUI.def(parsedJson, 'src', null));
  }

  static dynamic pCircleAvatar(parsedJson) {
    return CircleAvatar(
      backgroundImage: DynamicUI.def(parsedJson, 'backgroundImage', null),
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'backgroundColor', null)),
      radius: FlutterTypeConstant.parseToDouble(
        DynamicUI.def(parsedJson, 'radius', null),
      ),
      child: DynamicUI.def(parsedJson, 'child', null),
    );
  }

  static dynamic pIcon(parsedJson) {
    return Icon(
      iconsMap[DynamicUI.def(parsedJson, 'src', null)],
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null)),
      size: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'size', null)),
    );
  }

  static dynamic pAssetImage(parsedJson) {
    return AssetImage(DynamicUI.def(parsedJson, 'src', ''));
  }

  static dynamic pDecorationImage(parsedJson) {
    return DecorationImage(
      image: DynamicUI.def(parsedJson, 'image', null),
      fit: FlutterTypeConstant.parseBoxFit(DynamicUI.def(parsedJson, 'fit', null)),
      scale: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0))!,
      opacity: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0))!,
      repeat: FlutterTypeConstant.parseImageRepeat(DynamicUI.def(parsedJson, 'scale', "noRepeat"))!,
      filterQuality: FilterQuality.high,
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', "center"))!,
      matchTextDirection: DynamicUI.def(parsedJson, 'matchTextDirection', false),
    );
  }

  static dynamic pBoxDecoration(parsedJson) {
    return BoxDecoration(
      color: FlutterTypeConstant.parseToMaterialColor(
        DynamicUI.def(parsedJson, 'color', null),
      ),
      image: DynamicUI.def(parsedJson, 'image', null),
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null)),
      gradient: DynamicUI.def(parsedJson, 'gradient', null),
    );
  }

  static dynamic pSpacer(parsedJson) {
    return const Spacer();
  }

  static dynamic pLinearGradient(parsedJson) {
    return LinearGradient(
      begin: FlutterTypeConstant.parseAlignmentGeometry(
        DynamicUI.def(parsedJson, 'begin', 'centerLeft'),
      )!,
      colors: FlutterTypeConstant.parseListColor(
        DynamicUI.def(parsedJson, 'colors', null),
      ),
    );
  }

  static dynamic pDivider(parsedJson) {
    return Divider(
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null)),
      thickness: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'thickness', null)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null)),
    );
  }

  static dynamic pElevatedButtonIcon(parsedJson) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: DynamicUI.def(parsedJson, 'style', null),
      icon: DynamicUI.def(parsedJson, 'icon', null),
      label: DynamicUI.def(parsedJson, 'label', null),
    );
  }

  static dynamic pButtonStyle(parsedJson) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'backgroundColor', null),
        ),
      ),
      shadowColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'shadowColor', 'transparent'),
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null))!,
        ),
      ),
    );
  }
}
