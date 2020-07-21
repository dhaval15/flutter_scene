import 'dart:collection';
import 'package:flutter/material.dart';
import 'models.dart';

class ComponentBuilder {
  final Map<String, ComponentConverter> converters = HashMap();
  final Map<String, dynamic> globalVars = HashMap();
  final Map<String, dynamic> coreVars = HashMap();

  ComponentBuilder({
    Map<String, dynamic> globalVars = const {},
    Map<String, dynamic> coreVars = const {},
  }) {
    this.globalVars.addAll(globalVars);
    this.coreVars.addAll(coreVars);
  }

  void register(String key, ComponentConverter converter) {
    converters[key] = converter;
  }

  void unregister(String key) {
    converters[key] = null;
  }

  build(BuildContext context, Component component) {
    final converter = converters[component.name];
    if (converter != null) {
      component.builder = this;
      component.context = context;
      final convertedComponent = converter(component);
      component.builder = null;
      component.context = context;
      return convertedComponent;
    }
    throw Exception('Component \'${component.name}\' not registered.');
  }
}

typedef ComponentConverter<T> = T Function(Component component);
