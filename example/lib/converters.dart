import 'package:flutter/material.dart';
import 'package:flutter_scene/flutter_scene.dart';

Widget container(Component component) {
  return Container(
    padding: EdgeInsets.all(component['padding'].toDouble()),
    margin: EdgeInsets.all(component['margin'].toDouble()),
    decoration: component.decoration,
    height: component.width,
    width: component.height,
    child: component.child,
  );
}

Widget text(Component component) {
  return Text(component['text']);
}

Widget column(Component component) {
  return Column(
    verticalDirection: component['verticalDirection'],
    mainAxisAlignment: component['mainAxisAlignment'],
    crossAxisAlignment: component['crossAxisAlignment'],
    mainAxisSize: component['mainAxisSize'],
    children: component.children,
  );
}

Widget row(Component component) {
  return Row(
    verticalDirection: component['verticalDirection'],
    mainAxisAlignment: component['mainAxisAlignment'],
    crossAxisAlignment: component['crossAxisAlignment'],
    mainAxisSize: component['mainAxisSize'],
    children: component.children,
  );
}

Widget center(Component component) {
  return Center(
    child: component.child,
  );
}

Widget card(Component component) {
  return Card(
    color: component['color'],
    margin: EdgeInsets.all(component['margin'].toDouble()),
    elevation: component['elevation'].toDouble(),
    child: component.child,
  );
}

BoxDecoration boxDecoration(Component component) {
  return BoxDecoration(
    borderRadius: component.borderRadius,
    gradient: component.gradient,
  );
}

LinearGradient linearGradient(Component component) {
  return LinearGradient(
    colors: component.colors,
    begin: component.begin,
    end: component.end,
  );
}
