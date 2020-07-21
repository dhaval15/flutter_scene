import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:flutter_scene/src/component/models.dart';
import 'select.dart';
import 'box.dart';

class TextStyleBox extends MultiBox<TextStyle> {
  final DoubleBox fontSize;
  final DoubleBox letterSpacing;
  final DoubleBox wordSpacing;
  TextStyleBox(Component component)
      : fontSize = DoubleBox(component['fontSize']),
        letterSpacing = DoubleBox(component['letterSpacing']),
        wordSpacing = DoubleBox(component['wordSpacing']);

  @override
  List<Box> get fields => [fontSize, letterSpacing, wordSpacing];

  @override
  TextStyle get value => TextStyle(
        fontSize: fontSize.value,
        wordSpacing: wordSpacing.value,
        letterSpacing: letterSpacing.value,
      );

  @override
  Widget get editor => Layout(
        children: <Widget>[
          SelectInt(
            label: 'Font Size',
            listener: (value) {
              if (value is Lambda)
                fontSize.lambda = value;
              else
                fontSize.value = value;
            },
            value: fontSize.value,
          ),
          SelectInt(
            label: 'Letter Spacing',
            listener: (value) {
              if (value is Lambda)
                letterSpacing.lambda = value;
              else
                letterSpacing.value = value;
            },
            value: letterSpacing.value,
          ),
          SelectInt(
            label: 'Word Spacing',
            listener: (value) {
              if (value is Lambda)
                wordSpacing.lambda = value;
              else
                wordSpacing.value = value;
            },
            value: wordSpacing.value,
          ),
        ],
      );
}

class TextBox extends MultiBox<Text> {
  final CoreBox<String> text;
  final MultiBox<TextStyle> style;
  TextBox(Component component)
      : text = StringBox(component['text']),
        style = TextStyleBox(component['style']);

  @override
  List<Box> get fields => [text, style];

  @override
  Text get value => Text(
        text.value,
        style: style.value,
      );

  @override
  Widget get editor => Layout(
        children: <Widget>[
          SelectString(
            label: 'Text',
            value: text.value,
            listener: (value) {
              text.value = value;
            },
          ),
          style.editor,
        ],
      );
}

class Layout extends StatelessWidget {
  final List<Widget> children;

  const Layout({Key key, this.children}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: children,
    );
  }
}
