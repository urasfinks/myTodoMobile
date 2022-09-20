import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:myTODO/AppStore/GlobalData.dart';

import '../../AppStore/PageData.dart';
import '../../DynamicPage/DynamicFn.dart';
import '../../Util.dart';
import '../DynamicUI.dart';
import '../TypeParser.dart';

class TextFieldSW extends StatelessWidget {
  late final Widget render;

  TextFieldSW(parsedJson, PageData appStoreData, int index, String originKeyData, {super.key}) {
    var key = DynamicUI.def(parsedJson, 'name', '-', appStoreData, index, originKeyData);
    String defData = DynamicUI.def(parsedJson, 'data', '', appStoreData, index, originKeyData);
    String formattedDate = defData;
    String type = DynamicUI.def(parsedJson, 'keyboardType', 'text', appStoreData, index, originKeyData);
    bool readOnly = TypeParser.parseBool(DynamicUI.def(
        parsedJson, 'readOnly', (type == "datetime" || type == "time"), appStoreData, index, originKeyData))!;
    bool rewriteState = parsedJson["rewriteState"] ?? false;

    if(rewriteState == true){
      appStoreData.pageDataState.set(key, defData);
    }

    String? defAppStoreData = appStoreData.pageDataState.get(key, defData);
    //GlobalData.debug("Read defAppStoreData = $defAppStoreData");


    TextEditingController? textController = appStoreData.pageDataState.getTextController(key, defAppStoreData!);
    if(rewriteState == false){
      appStoreData.pageDataState.set(key, defAppStoreData);
    }

    textController?.text = defAppStoreData;
    //GlobalData.debug("textController key: ${key}; value: ${textController?.text}");

    //AppStore.debug(appStoreData.getStringStoreState());
    if (defAppStoreData != '') {
      //AppStore.debug("BUILD TextField: ${textController?.text}");
      int? x = textController?.text.length;
      if (x != null && x > 0) {
        textController?.selection = TextSelection.fromPosition(TextPosition(offset: x));
      }
    }

    List<TextInputFormatter> f = [];
    String regExp = DynamicUI.def(parsedJson, 'regexp', '', appStoreData, index, originKeyData);
    if (regExp.isNotEmpty) {
      f.add(FilteringTextInputFormatter.allow(RegExp('^[a-z0-9_-]{3,16}\$')));
    }

    render =  TextField(
      key: Util.getKey(parsedJson, appStoreData, index, originKeyData),
      focusNode: appStoreData.pageDataState.getFocusNode(key),
      onSubmitted: (String x) {
        dynamic c =
        DynamicFn.evalTextFunction(parsedJson['onSubmitted'], parsedJson, appStoreData, index, originKeyData);
        if (c != null && x.isNotEmpty) {
          Function.apply(c, []);
        }
      },
      onEditingComplete:
      DynamicFn.evalTextFunction(parsedJson['onEditingComplete'], parsedJson, appStoreData, index, originKeyData),
      inputFormatters: f,
      textCapitalization: TypeParser.parseTextCapitalization(
        DynamicUI.def(parsedJson, 'textCapitalization', 'sentences', appStoreData, index, originKeyData),
      )!,
      minLines: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'minLines', 1, appStoreData, index, originKeyData),
      ),
      maxLines: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'maxLines', null, appStoreData, index, originKeyData),
      ),
      maxLength: TypeParser.parseInt(
        DynamicUI.def(parsedJson, 'maxLength', null, appStoreData, index, originKeyData),
      ),
      textAlign: TypeParser.parseTextAlign(
        DynamicUI.def(parsedJson, 'textAlign', 'start', appStoreData, index, originKeyData),
      )!,
      textAlignVertical: TypeParser.parseTextAlignVertical(
        DynamicUI.def(parsedJson, 'textAlignVertical', null, appStoreData, index, originKeyData),
      ),
      clipBehavior: TypeParser.parseClip(
        DynamicUI.def(parsedJson, 'clipBehavior', 'hardEdge', appStoreData, index, originKeyData),
      )!,
      showCursor: DynamicUI.def(parsedJson, 'showCursor', null, appStoreData, index, originKeyData),
      autocorrect: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'autocorrect', true, appStoreData, index, originKeyData),
      )!,
      autofocus: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'autofocus', false, appStoreData, index, originKeyData),
      )!,
      expands: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'expands', false, appStoreData, index, originKeyData),
      )!,
      enabled: DynamicUI.def(parsedJson, 'enabled', null, appStoreData, index, originKeyData),
      cursorColor: TypeParser.parseColor(
        DynamicUI.def(parsedJson, 'cursorColor', null, appStoreData, index, originKeyData),
      ),
      readOnly: readOnly,
      controller: textController,
      obscureText: TypeParser.parseBool(
        DynamicUI.def(parsedJson, 'obscureText', false, appStoreData, index, originKeyData),
      )!,
      obscuringCharacter: DynamicUI.def(parsedJson, 'obscureText', '*', appStoreData, index, originKeyData),
      keyboardType: TypeParser.parseTextInputType(type)!,
      decoration: DynamicUI.def(parsedJson, 'decoration', null, appStoreData, index, originKeyData),
      style: DynamicUI.def(parsedJson, 'style', null, appStoreData, index, originKeyData),
      onChanged: (value) {
        appStoreData.pageDataState.set(key, value);
      },
      onTap: () async {
        if (type == "datetime") {
          DateTime? pickedDate = await showDatePicker(
            locale: const Locale('ru', 'ru_Ru'),
            context: appStoreData.getCtx()!,
            initialDate:
            textController?.text != "" ? DateFormat("dd.MM.yyyy").parse(textController!.text) : DateTime.now(),
            firstDate: DateTime(1931),
            lastDate: DateTime(2101),
          );
          if (pickedDate != null) {
            formattedDate = DateFormat('dd.MM.yyyy').format(pickedDate);
            appStoreData.pageDataState.set(key, formattedDate);
            textController?.text = formattedDate;
          } else {
            textController?.text = "";
          }
        } else if (type == "time") {
          String? t = textController?.text;
          TimeOfDay tod = TimeOfDay.now();
          if (t != null && t != "") {
            List<String> exp = t.split(":");
            tod = TimeOfDay(hour: TypeParser.parseInt(exp[0])!, minute: TypeParser.parseInt(exp[1])!);
          }
          final TimeOfDay? result = await showTimePicker(
            builder: (context, child) {
              return Localizations.override(
                context: context,
                locale: const Locale('ru', 'ru_Ru'),
                child: child,
              );
            },
            initialEntryMode: TimePickerEntryMode.input,
            initialTime: tod,
            context: appStoreData.getCtx()!,
          );
          if (result != null) {
            formattedDate = "${Util.intLPad(result.hour, pad: 2)}:${Util.intLPad(result.minute, pad: 2)}";
            appStoreData.pageDataState.set(key, formattedDate);
            textController?.text = formattedDate;
          }
        }
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return render;
  }
}
