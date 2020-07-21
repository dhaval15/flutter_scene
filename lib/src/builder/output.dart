import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart';

import '../component/models.dart';
import '../component/select.dart';
import '../component/box.dart';

class TextStyleBox extends MultiBox<TextStyle> {
  TextStyleBox(Component component)
      : fontSize = DoubleBox(component['fontSize']),
        letterSpacing = DoubleBox(component['letterSpacing']),
        wordSpacing = DoubleBox(component['wordSpacing']);

  final DoubleBox fontSize;

  final DoubleBox letterSpacing;

  final DoubleBox wordSpacing;

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
        ],
      );
  @override
  TextStyle get value => TextStyle(
        fontSize: fontSize.value,
        letterSpacing: letterSpacing.value,
        wordSpacing: wordSpacing.value,
      );
  @override
  List<Box> get fields => [fontSize, letterSpacing, wordSpacing];
}

class TextBox extends MultiBox<Text> {
  TextBox(Component component)
      : text = StringBox(component['text']),
        style = TextStyleBox(component['style']);

  final StringBox text;

  final TextStyleBox style;

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
  Text get value => Text(
        text.value,
        style: style.value,
      );
  @override
  List<Box> get fields => [text, style];
}
