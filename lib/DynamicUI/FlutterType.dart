import 'package:flutter/material.dart';
import '../DynamicPage/DynamicPage.dart';
import 'DynamicUI.dart';
import 'FlutterTypeConstant.dart';
import 'icon.dart';

class FlutterType {
  static Widget defaultWidget = const SizedBox(width: 0);

  static dynamic pText(parsedJson, DynamicPage context) {
    return Text(
      DynamicUI.def(parsedJson, 'data', '', context),
      style: DynamicUI.def(parsedJson, 'style', null, context),
    );
  }

  static dynamic pTextStyle(parsedJson, DynamicPage context) {
    return TextStyle(
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, context)),
      fontSize: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'fontSize', null, context)),
      fontStyle: FlutterTypeConstant.parseToFontStyle(DynamicUI.def(parsedJson, 'fontStyle', null, context)),
      fontWeight: FlutterTypeConstant.parseFontWeight(DynamicUI.def(parsedJson, 'fontWeight', null, context)),
    );
  }

  static dynamic pColumn(parsedJson, DynamicPage context) {
    return Column(
      crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(
        DynamicUI.def(
          parsedJson,
          'crossAxisAlignment',
          'center',
          context,
        ),
      )!,
      mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', context))!,
      children: DynamicUI.defList(parsedJson, 'children', context),
    );
  }

  static dynamic pRow(parsedJson, DynamicPage context) {
    return Row(crossAxisAlignment: FlutterTypeConstant.parseToCrossAxisAlignment(DynamicUI.def(parsedJson, 'crossAxisAlignment', 'center', context))!, mainAxisAlignment: FlutterTypeConstant.parseToMainAxisAlignment(DynamicUI.def(parsedJson, 'mainAxisAlignment', 'start', context))!, children: DynamicUI.defList(parsedJson, 'children', context));
  }

  static dynamic pExpanded(parsedJson, DynamicPage context) {
    return Expanded(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, context),
    );
  }

  static dynamic pPadding(parsedJson, DynamicPage context) {
    return Padding(
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null, context))!,
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, context),
    );
  }

  static dynamic pSizedBox(parsedJson, DynamicPage context) {
    return SizedBox(
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null, context)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, context)),
      child: DynamicUI.def(parsedJson, 'child', null, context),
    );
  }

  static dynamic pContainer(parsedJson, DynamicPage context) {
    return Container(
      margin: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'margin', null, context)),
      padding: FlutterTypeConstant.parseEdgeInsetsGeometry(DynamicUI.def(parsedJson, 'padding', null, context)),
      width: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'width', null, context)),
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, context)),
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, context),
      decoration: DynamicUI.def(parsedJson, 'decoration', null, context),
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', null, context)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, context)),
    );
  }

  static dynamic pCenter(parsedJson, DynamicPage context) {
    return Center(
      child: DynamicUI.def(parsedJson, 'child', defaultWidget, context),
    );
  }

  static dynamic pNetworkImage(parsedJson, DynamicPage context) {
    return NetworkImage(DynamicUI.def(parsedJson, 'src', null, context));
  }

  static dynamic pCircleAvatar(parsedJson, DynamicPage context) {
    return CircleAvatar(
      backgroundImage: DynamicUI.def(parsedJson, 'backgroundImage', null, context),
      backgroundColor: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'backgroundColor', null, context)),
      radius: FlutterTypeConstant.parseToDouble(
        DynamicUI.def(parsedJson, 'radius', null, context),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, context),
    );
  }

  static dynamic pIcon(parsedJson, DynamicPage context) {
    return Icon(
      iconsMap[DynamicUI.def(parsedJson, 'src', null, context)],
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, context)),
      size: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'size', null, context)),
    );
  }

  static dynamic pAssetImage(parsedJson, DynamicPage context) {
    return AssetImage(DynamicUI.def(parsedJson, 'src', '', context));
  }

  static dynamic pDecorationImage(parsedJson, DynamicPage context) {
    return DecorationImage(
      image: DynamicUI.def(parsedJson, 'image', null, context),
      fit: FlutterTypeConstant.parseBoxFit(DynamicUI.def(parsedJson, 'fit', null, context)),
      scale: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0, context))!,
      opacity: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'scale', 1.0, context))!,
      repeat: FlutterTypeConstant.parseImageRepeat(DynamicUI.def(parsedJson, 'scale', "noRepeat", context))!,
      filterQuality: FilterQuality.high,
      alignment: FlutterTypeConstant.parseAlignmentGeometry(DynamicUI.def(parsedJson, 'alignment', "center", context))!,
      matchTextDirection: DynamicUI.def(parsedJson, 'matchTextDirection', false, context),
    );
  }

  static dynamic pBoxDecoration(parsedJson, DynamicPage context) {
    return BoxDecoration(
      color: FlutterTypeConstant.parseToMaterialColor(
        DynamicUI.def(parsedJson, 'color', null, context),
      ),
      image: DynamicUI.def(parsedJson, 'image', null, context),
      borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, context)),
      gradient: DynamicUI.def(parsedJson, 'gradient', null, context),
    );
  }

  static dynamic pSpacer(parsedJson, DynamicPage context) {
    return const Spacer();
  }

  static dynamic pLinearGradient(parsedJson, DynamicPage context) {
    return LinearGradient(
      begin: FlutterTypeConstant.parseAlignmentGeometry(
        DynamicUI.def(parsedJson, 'begin', 'centerLeft', context),
      )!,
      colors: FlutterTypeConstant.parseListColor(
        DynamicUI.def(parsedJson, 'colors', null, context),
      ),
    );
  }

  static dynamic pDivider(parsedJson, DynamicPage context) {
    return Divider(
      height: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'height', null, context)),
      thickness: FlutterTypeConstant.parseToDouble(DynamicUI.def(parsedJson, 'thickness', null, context)),
      color: FlutterTypeConstant.parseToMaterialColor(DynamicUI.def(parsedJson, 'color', null, context)),
    );
  }

  static dynamic pElevatedButtonIcon(parsedJson, DynamicPage context) {
    return ElevatedButton.icon(
      onPressed: () {},
      style: DynamicUI.def(parsedJson, 'style', null, context),
      icon: DynamicUI.def(parsedJson, 'icon', null, context),
      label: DynamicUI.def(parsedJson, 'label', null, context),
    );
  }

  static dynamic pButtonStyle(parsedJson, DynamicPage context) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'backgroundColor', null, context),
        ),
      ),
      shadowColor: MaterialStateProperty.all(
        FlutterTypeConstant.parseToMaterialColor(
          DynamicUI.def(parsedJson, 'shadowColor', 'transparent', context),
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: FlutterTypeConstant.parseToBorderRadius(DynamicUI.def(parsedJson, 'borderRadius', null, context))!,
        ),
      ),
    );
  }

}
