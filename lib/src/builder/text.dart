import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scene/src/globals/globals.dart';

import '../component/models.dart';
import '../component/select.dart';
import '../component/box.dart';

class TextBox extends MultiBox<Text> {
  TextBox(Component component)
      : text = StringBox(component['#0']),
        style = TextStyleBox(component['style']),
        textAlign = CoreBox<TextAlign>(component['textAlign']);

  final StringBox text;

  final TextStyleBox style;

  final CoreBox<TextAlign> textAlign;

  @override
  Widget get editor => Layout(
        children: [
          SelectString(
            label: 'Text',
            value: text.value,
            listener: (value) {
              if (value is Lambda)
                text.lambda = value;
              else
                text.value = value;
            },
          ),
          style.editor,
        ],
      );
  @override
  Text get value {
    print(textAlign.value);
    return Text(
      text.value,
      style: style.value,
      textAlign: textAlign.value,
    );
  }

  @override
  List<Box> get fields => [text, style, textAlign];
}

class TextStyleBox extends MultiBox<TextStyle> {
  TextStyleBox(Component component)
      : fontSize = DoubleBox(component['fontSize']),
        letterSpacing = DoubleBox(component['letterSpacing']),
        wordSpacing = DoubleBox(component['wordSpacing']),
        fontWeight = CoreBox(component['fontWeight']),
        fontStyle = CoreBox(component['fontStyle']);

  final DoubleBox fontSize;

  final DoubleBox letterSpacing;

  final DoubleBox wordSpacing;

  final CoreBox<FontWeight> fontWeight;
  final CoreBox<FontStyle> fontStyle;

  @override
  Widget get editor => Layout(
        children: [
          SelectInt(
            label: 'Font Size',
            value: fontSize.value,
            listener: (value) {
              if (value is Lambda)
                fontSize.lambda = value;
              else
                fontSize.value = value;
            },
          ),
          SelectInt(
            label: 'Letter Spacing',
            value: letterSpacing.value,
            listener: (value) {
              if (value is Lambda)
                letterSpacing.lambda = value;
              else
                letterSpacing.value = value;
            },
          ),
          SelectInt(
            label: 'Word Spacing',
            value: wordSpacing.value,
            listener: (value) {
              if (value is Lambda)
                wordSpacing.lambda = value;
              else
                wordSpacing.value = value;
            },
          ),
          SelectEnum(
            label: 'Font Weight',
            value: 'w100',
            initialValues: FLUTTER_GLOBALS['FontWeight'].keys.toList(),
            listener: (value) {
              fontWeight.value = FLUTTER_GLOBALS['FontWeight'][value];
            },
          ),
          SelectEnum(
            label: 'Font Style',
            value: 'normal',
            initialValues: FLUTTER_GLOBALS['FontStyle'].keys.toList(),
            listener: (value) {
              print(value);
              fontStyle.value = FLUTTER_GLOBALS['FontStyle'][value];
            },
          ),
        ],
      );
  @override
  TextStyle get value => TextStyle(
        fontSize: fontSize.value,
        letterSpacing: letterSpacing.value,
        wordSpacing: wordSpacing.value,
        fontWeight: fontWeight.value,
        fontStyle: fontStyle.value,
      );
  @override
  List<Box> get fields =>
      [fontSize, letterSpacing, wordSpacing, fontWeight, fontStyle];
}
