import 'package:cached_network_image/cached_network_image.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_select/flutter_awesome_select.dart';
import 'package:introduction_screen/introduction_screen.dart';

import 'package:myTODO/AppStore/PageData.dart';
import 'package:myTODO/DynamicPage/DynamicFn.dart';
import 'package:myTODO/DynamicUI/sw/CenterSW.dart';
import 'package:myTODO/DynamicUI/sw/CheckboxSW.dart';
import 'package:myTODO/DynamicUI/sw/CircleAvatarSW.dart';
import 'package:myTODO/DynamicUI/sw/ColumnSW.dart';
import 'package:myTODO/DynamicUI/sw/ContainerSW.dart';
import 'package:myTODO/DynamicUI/sw/DividerSW.dart';
import 'package:myTODO/DynamicUI/sw/ExpandedSW.dart';
import 'package:myTODO/DynamicUI/sw/IconSW.dart';
import 'package:myTODO/DynamicUI/sw/IconButtonSW.dart';
import 'package:myTODO/DynamicUI/sw/InkWellSW.dart';
import 'package:myTODO/DynamicUI/sw/LoopSW.dart';
import 'package:myTODO/DynamicUI/sw/MaterialSW.dart';
import 'package:myTODO/DynamicUI/sw/PaddingSW.dart';
import 'package:myTODO/DynamicUI/sw/RawMaterialButtonSW.dart';
import 'package:myTODO/DynamicUI/sw/RowSW.dart';
import 'package:myTODO/DynamicUI/sw/SelectableTextSW.dart';
import 'package:myTODO/DynamicUI/sw/SizeBoxSW.dart';
import 'package:myTODO/DynamicUI/sw/SlidableSW.dart';
import 'package:myTODO/DynamicUI/sw/TextFieldSW.dart';
import 'package:myTODO/DynamicUI/sw/TextSW.dart';
import '../AppMetric.dart';
import '../AppStore/GlobalData.dart';
import '../Util.dart';
import 'DynamicUI.dart';
import 'TypeParser.dart';

class FlutterType {
  static dynamic pTextStyle(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return TextStyle(
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      fontSize: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'fontSize', null, appStoreData, index, originKeyData),
      ),
      fontStyle: TypeParser.parseFontStyle(
        DynamicUI.def(parsedJson, 'fontStyle', null, appStoreData, index, originKeyData),
      ),
      fontWeight: TypeParser.parseFontWeight(
        DynamicUI.def(parsedJson, 'fontWeight', null, appStoreData, index, originKeyData),
      ),
    );
  }

  static dynamic pColumn(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return ColumnSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pRow(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return RowSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pExpanded(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return ExpandedSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pPadding(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return PaddingSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pSizedBox(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return SizedBoxSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pContainer(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return ContainerSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pCenter(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return CenterSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pCircleAvatar(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return CircleAvatarSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pIcon(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return IconSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pAssetImage(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return AssetImage(
      DynamicUI.def(parsedJson, 'src', '', appStoreData, index, originKeyData),
    );
  }

  static dynamic pBoxDecoration(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return BoxDecoration(
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData, index, originKeyData),
      borderRadius: TypeParser.parseBorderRadius(
        DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index, originKeyData),
      ),
      gradient: DynamicUI.def(parsedJson, 'gradient', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pSpacer(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return const Spacer();
  }

  static dynamic pLinearGradient(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return LinearGradient(
      begin: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'begin', 'centerLeft', appStoreData, index, originKeyData),
      )!,
      end: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'end', 'centerRight', appStoreData, index, originKeyData),
      )!,
      stops: TypeParser.parseListDouble(
        DynamicUI.def(parsedJson, 'stops', null, appStoreData, index, originKeyData),
      ),
      colors: TypeParser.parseListColor(
        DynamicUI.def(parsedJson, 'colors', null, appStoreData, index, originKeyData),
      ),
    );
  }

  static dynamic pButtonStyle(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return ButtonStyle(
      backgroundColor: MaterialStateProperty.all(
        TypeParser.parseColor(
          DynamicUI.def(parsedJson, 'backgroundColor', null, appStoreData, index, originKeyData),
        ),
      ),
      shadowColor: MaterialStateProperty.all(
        TypeParser.parseColor(
          DynamicUI.def(parsedJson, 'shadowColor', 'transparent', appStoreData, index, originKeyData),
        ),
      ),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: TypeParser.parseBorderRadius(
            DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index, originKeyData),
          )!,
        ),
      ),
    );
  }

  static dynamic pMaterial(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return MaterialSW(parsedJson, appStoreData, index, originKeyData);
  }

  static void dynamicFunction(parsedJson, PageData appStoreData, String key, int index, String originKeyData) {
    Map<String, dynamic> originData = appStoreData.getServerResponse()[originKeyData][index]["data"];
    List<String> exp = parsedJson[key].toString().split("):");
    List<dynamic> args = [];
    args.add(appStoreData);
    try {
      List<String> exp2 = exp[0].split("(");
      if (exp2.length > 1 && originData.containsKey(exp2[1])) {
        args.add(originData[exp2[1]]);
      }
    } catch (e, stacktrace) {
      AppMetric().exception(e, stacktrace);
    }
    if (args.length == 1) {
      args.add(null);
    }
    Function? x = DynamicUI.def(parsedJson, key, null, appStoreData, index, originKeyData);
    if (x != null) {
      Function.apply(x, args);
    }
  }

  static dynamic pRawMaterialButton(parsedJson, PageData appStoreData, int index, String originKeyData) {
    //GlobalData.debug("pRawMaterialButton: ${parsedJson}");
    return RawMaterialButtonSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pElevatedButton(parsedJson, PageData appStoreData, int index, String originKeyData) {
    //GlobalData.debug("pElevatedButton: ${parsedJson}");
    /*
    * [ElevatedButton/OutlinedButton]
    * StadiumBorder
    * RoundedRectangleBorder
    * CircleBorder
    * BeveledRectangleBorder
    * */
    double borderRadius = TypeParser.parseDouble(
      DynamicUI.def(parsedJson, 'borderRadius', 0, appStoreData, index, originKeyData),
    )!;
    String buttonStyleType =
        DynamicUI.def(parsedJson, 'buttonStyle', 'ElevatedButton', appStoreData, index, originKeyData);
    String shapeType = DynamicUI.def(parsedJson, 'shape', 'StadiumBorder', appStoreData, index, originKeyData);
    OutlinedBorder? shape;

    if (shapeType == "StadiumBorder") {
      shape = const StadiumBorder();
    }
    if (shapeType == "RoundedRectangleBorder") {
      shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius), // <-- Radius
      );
    }
    if (shapeType == "CircleBorder") {
      shape = const CircleBorder();
    }
    if (shapeType == "BeveledRectangleBorder") {
      shape = BeveledRectangleBorder(borderRadius: BorderRadius.circular(borderRadius));
    }

    ButtonStyle? buttonStyle;
    if (buttonStyleType == "ElevatedButton") {
      buttonStyle = ElevatedButton.styleFrom(shape: shape);
    }
    if (buttonStyleType == "OutlinedButton") {
      buttonStyle = OutlinedButton.styleFrom(shape: shape);
    }

    return ElevatedButton(
      onPressed: DynamicFn.evalTextFunction(parsedJson['onPressed'], parsedJson, appStoreData, index, originKeyData),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
      style: OutlinedButton.styleFrom(
        shape: const StadiumBorder(),
      ),
    );
  }

  static dynamic pElevatedButtonIcon(parsedJson, PageData appStoreData, int index, String originKeyData) {
    //GlobalData.debug(parsedJson);
    return ElevatedButton.icon(
      onPressed: DynamicFn.evalTextFunction(parsedJson['onPressed'], parsedJson, appStoreData, index, originKeyData),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index, originKeyData),
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index, originKeyData),
      label: DynamicUI.def(parsedJson, 'label', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pInkWell(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return InkWellSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pRoundedRectangleBorder(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return RoundedRectangleBorder(
      borderRadius: TypeParser.parseBorderRadius(
        DynamicUI.def(parsedJson, 'borderRadius', 0, appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pText(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return TextSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pSelectableText(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return SelectableTextSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pTextField(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return TextFieldSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pInputDecoration(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return InputDecoration(
      suffixIcon: DynamicUI.def(parsedJson, 'suffixIcon', null, appStoreData, index, originKeyData),
      enabledBorder: DynamicUI.def(parsedJson, 'enabledBorder', null, appStoreData, index, originKeyData),
      focusedBorder: DynamicUI.def(parsedJson, 'focusedBorder', null, appStoreData, index, originKeyData),
      filled: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'filled', null, appStoreData, index, originKeyData),
      ),
      fillColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'fillColor', null, appStoreData, index, originKeyData),
      ),
      icon: DynamicUI.def(parsedJson, 'icon', null, appStoreData, index, originKeyData),
      border: DynamicUI.def(parsedJson, 'border', null, appStoreData, index, originKeyData),
      labelText: DynamicUI.def(parsedJson, 'labelText', null, appStoreData, index, originKeyData),
      errorText: DynamicUI.def(parsedJson, 'errorText', null, appStoreData, index, originKeyData),
      hintText: DynamicUI.def(parsedJson, 'hintText', null, appStoreData, index, originKeyData),
      contentPadding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'contentPadding', null, appStoreData, index, originKeyData),
      ),
      prefixIcon: DynamicUI.def(parsedJson, 'prefixIcon', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pOutlineInputBorder(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return OutlineInputBorder(
      borderSide: DynamicUI.def(parsedJson, 'borderSide', const BorderSide(), appStoreData, index, originKeyData),
      borderRadius: TypeParser.parseBorderRadius(
        DynamicUI.def(parsedJson, 'borderRadius', 4.0, appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pUnderlineInputBorder(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return UnderlineInputBorder(
      borderSide: DynamicUI.def(parsedJson, 'borderSide', const BorderSide(), appStoreData, index, originKeyData),
      borderRadius: TypeParser.parseBorderRadius(
        DynamicUI.def(parsedJson, 'borderRadius', 4.0, appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pBorderSide(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return BorderSide(
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', '#f5f5f5', appStoreData, index, originKeyData),
      )!,
      width: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'width', 1, appStoreData, index, originKeyData),
      )!,
      style: TypeParser.parseBorderStyle(
        DynamicUI.def(parsedJson, 'style', 'solid', appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pGridView(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return GridView.count(
      crossAxisCount: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'crossAxisCount', 0, appStoreData, index, originKeyData),
      )!,
      mainAxisSpacing: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'mainAxisSpacing', 0.0, appStoreData, index, originKeyData),
      )!,
      crossAxisSpacing: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'crossAxisSpacing', 0.0, appStoreData, index, originKeyData),
      )!,
      childAspectRatio: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'childAspectRatio', 1.0, appStoreData, index, originKeyData),
      )!,
      reverse: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'reverse', false, appStoreData, index, originKeyData),
      )!,
      scrollDirection: TypeParser.parseAxis(
        DynamicUI.def(parsedJson, 'scrollDirection', 'vertical', appStoreData, index, originKeyData)!,
      )!,
      shrinkWrap: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'shrinkWrap', false, appStoreData, index, originKeyData),
      )!,
      padding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', null, appStoreData, index, originKeyData),
      )!,
      physics: Util.getPhysics(),
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData),
    );
  }

  static dynamic pListView(parsedJson, PageData appStoreData, int parentindex, originKeyData) {
    bool separated = TypeParser.parseBool(
      DynamicUI.def(parsedJson, 'separated', false, appStoreData, parentindex, originKeyData),
    )!;
    if (separated) {
      return ListView.separated(
        scrollDirection: TypeParser.parseAxis(
          DynamicUI.def(parsedJson, 'scrollDirection', 'vertical', appStoreData, parentindex, originKeyData)!,
        )!,
        padding: TypeParser.parseEdgeInsets(
          DynamicUI.def(parsedJson, 'padding', null, appStoreData, parentindex, originKeyData),
        ),
        shrinkWrap: TypeParser.parseBool(
          DynamicUI.def(parsedJson, 'shrinkWrap', false, appStoreData, parentindex, originKeyData),
        )!,
        reverse: TypeParser.parseBool(
          DynamicUI.def(parsedJson, 'reverse', false, appStoreData, parentindex, originKeyData),
        )!,
        physics: Util.getPhysics(),
        itemCount: TypeParser.parseInt(
          DynamicUI.def(parsedJson, 'itemCount', 0, appStoreData, parentindex, originKeyData),
        )!,
        itemBuilder: (BuildContext context, int index) {
          return DynamicUI.mainJson(parsedJson["children"][index], appStoreData, index, originKeyData);
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(
          height: 1,
        ),
      );
    } else {
      return ListView.builder(
        scrollDirection: TypeParser.parseAxis(
          DynamicUI.def(parsedJson, 'scrollDirection', 'vertical', appStoreData, parentindex, originKeyData)!,
        )!,
        padding: TypeParser.parseEdgeInsets(
          DynamicUI.def(parsedJson, 'padding', null, appStoreData, parentindex, originKeyData),
        ),
        shrinkWrap: TypeParser.parseBool(
          DynamicUI.def(parsedJson, 'shrinkWrap', false, appStoreData, parentindex, originKeyData),
        )!,
        reverse: TypeParser.parseBool(
          DynamicUI.def(parsedJson, 'reverse', false, appStoreData, parentindex, originKeyData),
        )!,
        physics: Util.getPhysics(),
        itemCount: TypeParser.parseInt(
          DynamicUI.def(parsedJson, 'itemCount', 0, appStoreData, parentindex, originKeyData),
        )!,
        itemBuilder: (BuildContext context, int index) {
          return DynamicUI.mainJson(parsedJson["children"][index], appStoreData, index, originKeyData);
        },
      );
    }
  }

  static dynamic pPageView(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return PageView(
      scrollDirection: TypeParser.parseAxis(
        DynamicUI.def(parsedJson, 'scrollDirection', 'vertical', appStoreData, index, originKeyData)!,
      )!,
      reverse: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'reverse', false, appStoreData, index, originKeyData),
      )!,
      physics: Util.getPhysics(),
      pageSnapping: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'pageSnapping', true, appStoreData, index, originKeyData),
      )!,
      padEnds: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'padEnds', true, appStoreData, index, originKeyData),
      )!,
      allowImplicitScrolling: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'allowImplicitScrolling', false, appStoreData, index, originKeyData),
      )!,
      clipBehavior: TypeParser.parseClip(
        DynamicUI.def(parsedJson, 'clipBehavior', 'none', appStoreData, index, originKeyData),
      )!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData),
    );
  }

  static dynamic pAlign(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Align(
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', 'center', appStoreData, index, originKeyData),
      )!,
      widthFactor: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'widthFactor', null, appStoreData, index, originKeyData),
      ),
      heightFactor: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'heightFactor', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pAspectRatio(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return AspectRatio(
      aspectRatio: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'aspectRatio', 1.0, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pFitBox(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return FittedBox(
      fit: TypeParser.parseBoxFit(
        DynamicUI.def(parsedJson, 'fit', 'contain', appStoreData, index, originKeyData),
      )!,
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', 'center', appStoreData, index, originKeyData),
      )!,
      clipBehavior: TypeParser.parseClip(
        DynamicUI.def(parsedJson, 'clipBehavior', 'none', appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pBaseline(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Baseline(
      baseline: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'baseline', null, appStoreData, index, originKeyData),
      )!,
      baselineType: TypeParser.parseTextBaseline(
        DynamicUI.def(parsedJson, 'baselineType', null, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pStack(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Stack(
      alignment: TypeParser.parseAlignmentDirectional(
        DynamicUI.def(parsedJson, 'alignment', 'topStart', appStoreData, index, originKeyData),
      )!,
      textDirection: TypeParser.parseTextDirection(
        DynamicUI.def(parsedJson, 'textDirection', null, appStoreData, index, originKeyData),
      ),
      fit: TypeParser.parseStackFit(
        DynamicUI.def(parsedJson, 'fit', 'loose', appStoreData, index, originKeyData),
      )!,
      clipBehavior: TypeParser.parseClip(
        DynamicUI.def(parsedJson, 'clipBehavior', 'hardEdge', appStoreData, index, originKeyData),
      )!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData),
    );
  }

  static dynamic pPositioned(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Positioned(
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      width: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      left: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'left', null, appStoreData, index, originKeyData),
      ),
      right: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'right', null, appStoreData, index, originKeyData),
      ),
      top: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'top', null, appStoreData, index, originKeyData),
      ),
      bottom: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'bottom', null, appStoreData, index, originKeyData),
      ),
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pOpacity(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Opacity(
      opacity: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'opacity', 1.0, appStoreData, index, originKeyData),
      )!,
      alwaysIncludeSemantics: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'alwaysIncludeSemantics', false, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pWrap(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Wrap(
      direction: TypeParser.parseAxis(
        DynamicUI.def(parsedJson, 'direction', 1.0, appStoreData, index, originKeyData),
      )!,
      alignment: TypeParser.parseWrapAlignment(
        DynamicUI.def(parsedJson, 'alignment', 'start', appStoreData, index, originKeyData),
      )!,
      spacing: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'spacing', 0.0, appStoreData, index, originKeyData),
      )!,
      runAlignment: TypeParser.parseWrapAlignment(
        DynamicUI.def(parsedJson, 'runAlignment', 'start', appStoreData, index, originKeyData),
      )!,
      runSpacing: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'runSpacing', 0.0, appStoreData, index, originKeyData),
      )!,
      crossAxisAlignment: TypeParser.parseWrapCrossAlignment(
        DynamicUI.def(parsedJson, 'crossAxisAlignment', 'start', appStoreData, index, originKeyData),
      )!,
      textDirection: TypeParser.parseTextDirection(
        DynamicUI.def(parsedJson, 'textDirection', null, appStoreData, index, originKeyData),
      ),
      verticalDirection: TypeParser.parseVerticalDirection(
        DynamicUI.def(parsedJson, 'verticalDirection', 'down', appStoreData, index, originKeyData),
      )!,
      clipBehavior: TypeParser.parseClip(
        DynamicUI.def(parsedJson, 'clipBehavior', 'none', appStoreData, index, originKeyData),
      )!,
      children: DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData),
    );
  }

  static dynamic pClipRRect(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return ClipRRect(
      borderRadius: TypeParser.parseBorderRadius(
        DynamicUI.def(parsedJson, 'borderRadius', null, appStoreData, index, originKeyData),
      ),
      clipBehavior: TypeParser.parseClip(
        DynamicUI.def(parsedJson, 'clipBehavior', 'antiAlias', appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pLimitedBox(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return LimitedBox(
      maxWidth: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'maxWidth', 'infinity', appStoreData, index, originKeyData),
      )!,
      maxHeight: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'maxWidth', 'infinity', appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pOverflowBox(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return OverflowBox(
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', 'center', appStoreData, index, originKeyData),
      )!,
      minWidth: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'minWidth', null, appStoreData, index, originKeyData),
      ),
      maxWidth: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'maxWidth', null, appStoreData, index, originKeyData),
      ),
      minHeight: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'minHeight', null, appStoreData, index, originKeyData),
      ),
      maxHeight: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'maxHeight', null, appStoreData, index, originKeyData),
      ),
    );
  }

  static dynamic pDivider(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return DividerSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pRotatedBox(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return RotatedBox(
      quarterTurns: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'quarterTurns', 0, appStoreData, index, originKeyData),
      )!,
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pIconButton(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return IconButtonSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pCheckbox(parsedJson, PageData appStoreData, int index, String originKeyData) {
    //print("BUILD pCheckbox");
    return CheckboxSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pDecorationImage(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return DecorationImage(
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData, index, originKeyData),
      fit: TypeParser.parseBoxFit(
        DynamicUI.def(parsedJson, 'fit', null, appStoreData, index, originKeyData),
      ),
      scale: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData, index, originKeyData),
      )!,
      opacity: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'opacity', 1.0, appStoreData, index, originKeyData),
      )!,
      repeat: TypeParser.parseImageRepeat(
        DynamicUI.def(parsedJson, 'repeat', "noRepeat", appStoreData, index, originKeyData),
      )!,
      filterQuality: FilterQuality.high,
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', "center", appStoreData, index, originKeyData),
      )!,
      matchTextDirection: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'matchTextDirection', false, appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pImageNetwork(parsedJson, PageData appStoreData, int index, String originKeyData) {
    String src = DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData);
    if (!src.startsWith("http")) {
      src = "${GlobalData.host}${src}";
    }
    return Image.network(
      src,
      width: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      fit: TypeParser.parseBoxFit(
        DynamicUI.def(parsedJson, 'fit', null, appStoreData, index, originKeyData),
      ),
      scale: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData, index, originKeyData),
      )!,
      repeat: TypeParser.parseImageRepeat(
        DynamicUI.def(parsedJson, 'repeat', "noRepeat", appStoreData, index, originKeyData),
      )!,
      filterQuality: FilterQuality.high,
      alignment: TypeParser.parseAlignment(
        DynamicUI.def(parsedJson, 'alignment', "center", appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pNetworkImage(parsedJson, PageData appStoreData, int index, String originKeyData) {
    String src = DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData);
    if (!src.startsWith("http")) {
      src = "${GlobalData.host}${src}";
    }
    return NetworkImage(
      src,
    );
  }

  static dynamic pCachedNetworkImageProvider(parsedJson, PageData appStoreData, int index, String originKeyData) {
    String src = DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData);
    if (!src.startsWith("http")) {
      src = "${GlobalData.host}${src}";
    }
    return CachedNetworkImageProvider(
      src,
      maxWidth: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'maxWidth', null, appStoreData, index, originKeyData),
      ),
      maxHeight: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'maxHeight', null, appStoreData, index, originKeyData),
      ),
      headers: GlobalData.requestHeader,
      scale: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'scale', 1.0, appStoreData, index, originKeyData),
      )!,
      cacheKey: DynamicUI.def(parsedJson, 'cacheKey', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pCachedNetworkImage(parsedJson, PageData appStoreData, int index, String originKeyData) {
    //print(parsedJson);
    String src = DynamicUI.def(parsedJson, 'src', null, appStoreData, index, originKeyData);
    if (!src.startsWith("http")) {
      src = "${GlobalData.host}${src}";
    }
    return CachedNetworkImage(
      color: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'color', null, appStoreData, index, originKeyData),
      ),
      httpHeaders: GlobalData.requestHeader,
      imageUrl: src,
      //placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: TypeParser.parseBoxFit(
        DynamicUI.def(parsedJson, 'fit', null, appStoreData, index, originKeyData),
      ),
      width: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'width', null, appStoreData, index, originKeyData),
      ),
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
    );
  }

  static dynamic pNothing(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return SizedBoxSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pAppStore(parsedJson, PageData appStoreData, int index, String originKeyData) {
    //return const Text("!");
    return SizedBoxSW(parsedJson, appStoreData, index, originKeyData);
    //return SWAppStore(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pSegmentControl(parsedJson, PageData appStoreData, int index, String originKeyData) {
    List<Widget> children = DynamicUI.defList(parsedJson, 'children', appStoreData, index, originKeyData);
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData, index, originKeyData);
    Map<int, Widget> ch = {};
    int count = 0;
    for (Widget w in children) {
      ch[count++] = w;
    }
    return CustomSlidingSegmentedControl(
      children: ch,
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index, originKeyData),
      thumbDecoration: DynamicUI.def(parsedJson, 'thumbDecoration', null, appStoreData, index, originKeyData),
      duration: Duration(
        milliseconds: TypeParser.parseInt(
          DynamicUI.def(parsedJson, 'duration', 300, appStoreData, index, originKeyData),
        )!,
      ),
      fixedWidth: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'fixedWidth', null, appStoreData, index, originKeyData),
      ),
      height: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'height', null, appStoreData, index, originKeyData),
      ),
      padding: TypeParser.parseDouble(
        DynamicUI.def(parsedJson, 'padding', 12, appStoreData, index, originKeyData),
      )!,
      splashColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'splashColor', null, appStoreData, index, originKeyData),
      ),
      highlightColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'highlightColor', null, appStoreData, index, originKeyData),
      ),
      fromMax: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'fromMax', false, appStoreData, index, originKeyData),
      )!,
      isStretch: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'isStretch', true, appStoreData, index, originKeyData),
      )!,
      onValueChanged: (int index) {
        appStoreData.pageDataState.set(key, index);
        appStoreData.apply();
      },
      initialValue: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'value', 0, appStoreData, index, originKeyData),
      ),
      innerPadding: TypeParser.parseEdgeInsets(
        DynamicUI.def(parsedJson, 'padding', 2.0, appStoreData, index, originKeyData),
      )!,
    );
  }

  static dynamic pVisibility(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return Visibility(
      child: DynamicUI.def(parsedJson, 'child', null, appStoreData, index, originKeyData),
      visible: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'visible', true, appStoreData, index, originKeyData),
      )!,
      maintainAnimation: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'maintainAnimation', false, appStoreData, index, originKeyData),
      )!,
      maintainInteractivity: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'maintainInteractivity', false, appStoreData, index, originKeyData),
      )!,
      maintainSemantics: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'maintainSemantics', false, appStoreData, index, originKeyData),
      )!,
      maintainSize: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'maintainSize', false, appStoreData, index, originKeyData),
      )!,
      maintainState: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'maintainState', false, appStoreData, index, originKeyData),
      )!,
      replacement:
          DynamicUI.def(parsedJson, 'replacement', const SizedBox.shrink(), appStoreData, index, originKeyData),
    );
  }

  static dynamic pDropdownRadio(parsedJson, PageData appStoreData, int index, String originKeyData) {
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData, index, originKeyData);
    String value =
        appStoreData.pageDataState.get(key, DynamicUI.def(parsedJson, 'value', '', appStoreData, index, originKeyData));
    appStoreData.pageDataState.set(key, value);
    List<S2Choice<String>> options = [];
    for (dynamic w in parsedJson["items"]) {
      options.add(S2Choice<String>(value: w["value"], title: w["title"]));
    }
    return SmartSelect<String>.single(
      choiceConfig: Util.getPhysics() != null ? S2ChoiceConfig(physics: Util.getPhysics()!) : null,
      title: DynamicUI.def(parsedJson, 'title', '', appStoreData, index, originKeyData),
      selectedValue: value,
      choiceItems: options,
      modalType: S2ModalType.bottomSheet,
      onChange: (state) {
        appStoreData.pageDataState.set(key, state.value);
        appStoreData.apply();
      },
    );
  }

  static dynamic pPageViewModel(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return PageViewModel(
      title: DynamicUI.def(parsedJson, 'title', '', appStoreData, index, originKeyData),
      body: DynamicUI.def(parsedJson, 'body', '', appStoreData, index, originKeyData),
      image: DynamicUI.def(parsedJson, 'image', null, appStoreData, index, originKeyData),
    );
  }

  static dynamic pIntroductionScreen(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return IntroductionScreen(
      pages: DynamicUI.defListPageViewModel(parsedJson, 'pages', appStoreData, index, originKeyData),
      onDone: DynamicFn.evalTextFunction(parsedJson['onDone'], parsedJson, appStoreData, index, originKeyData),
      onSkip: DynamicFn.evalTextFunction(parsedJson['onSkip'], parsedJson, appStoreData, index, originKeyData),
      // You can override onSkip callback
      showSkipButton: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'showSkipButton', true, appStoreData, index, originKeyData),
      )!,
      showBackButton: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'showBackButton', false, appStoreData, index, originKeyData),
      )!,
      skipOrBackFlex: 0,
      nextFlex: 0,
      back: DynamicUI.def(parsedJson, 'back', const Icon(Icons.arrow_back), appStoreData, index, originKeyData),
      skip: DynamicUI.def(parsedJson, 'skip', const Text('Пропустить', style: TextStyle(fontWeight: FontWeight.w600)),
          appStoreData, index, originKeyData),
      next: DynamicUI.def(parsedJson, 'next', const Icon(Icons.arrow_forward), appStoreData, index, originKeyData),
      done: DynamicUI.def(parsedJson, 'done', const Text('Готово', style: TextStyle(fontWeight: FontWeight.w600)),
          appStoreData, index, originKeyData),
      curve: Curves.fastLinearToSlowEaseIn,
      animationDuration: 1000,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.all(12.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
    );
  }

  static dynamic pSlidable(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return SlidableSW(parsedJson, appStoreData, index, originKeyData);
  }

  static dynamic pLoop(parsedJson, PageData appStoreData, int index, String originKeyData) {
    return LoopSW(parsedJson, appStoreData, index, originKeyData);
  }
}
