import 'dart:collection';
import 'builder.dart';
import '../parser/component_parser.dart';
import 'package:flutter/material.dart';

class Component {
  final String name;
  final Map<String, dynamic> params;
  ComponentBuilder builder;
  BuildContext context;

  Component(this.name, List<MapEntry<String, dynamic>> entries)
      : params = HashMap.fromEntries(entries);

  factory Component.parse(String text) =>
      ComponentParser().parse(text.trim()).value;

  dynamic operator [](String key) {
    dynamic value = params[key];
    if (value is VarElement)
      value = builder.globalVars[value.name];
    else if (value is CoreElement)
      value = builder.coreVars[value.name];
    else if (value is ColorElement) value = Color(value.color);
    return value;
  }

  Widget get child => builder.build(context, params['child']);

  List<Widget> get children => params['children']
      .map((value) => builder.build(context, value))
      .toList()
      .cast<Widget>();

  Color get color {
    final value = params['color'];
    if (value == null) return null;
    if (value is CoreElement) return builder.coreVars[value.name];
    return Color(value);
  }

  List<Color> get colors {
    final values = params['colors'];
    return values
        .map((value) =>
            value is CoreElement ? builder.coreVars[value.name] : Color(value))
        .toList()
        .cast<Color>();
  }

  double get width => params['width'].toDouble();

  double get height => params['height'].toDouble();

  EdgeInsets get padding {
    final values = params['padding'];
    return EdgeInsets.only(
      left: values[0],
      top: values[1],
      right: values[2],
      bottom: values[3],
    );
  }

  EdgeInsets get margin {
    final values = params['margin'];
    return EdgeInsets.only(
      left: values[0],
      top: values[1],
      right: values[2],
      bottom: values[3],
    );
  }

  BorderRadiusGeometry get borderRadius {
    final values = params['borderRadius'];
    return BorderRadius.only(
      topLeft: Radius.circular(values[0].toDouble()),
      topRight: Radius.circular(values[1].toDouble()),
      bottomRight: Radius.circular(values[2].toDouble()),
      bottomLeft: Radius.circular(values[3].toDouble()),
    );
  }

  Decoration get decoration => builder.build(context, params['decoration']);

  AlignmentGeometry get begin {
    var value = params['begin'];
    if (value is CoreElement) return builder.coreVars[value.name];
    return builder.build(context, value);
  }

  AlignmentGeometry get end {
    var value = params['end'];
    if (value is CoreElement) return builder.coreVars[value.name];
    return builder.build(context, value);
  }

  Gradient get gradient => builder.build(context, params['gradient']);

  @override
  String toString() => {
        'name': name,
        'params': params,
      }.toString();
}

class VarElement {
  final String name;

  VarElement(this.name);
}

class CoreElement {
  final String name;
  CoreElement(this.name);
}

class ColorElement {
  final int color;

  ColorElement(this.color);
}
