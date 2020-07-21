import 'builder.dart';

void main() {
  final styleBuilder = ModelBuilder(
    name: 'TextStyle',
    parameters: [
      Param(
        'Font Size',
        paramType: 'double',
        selectorClass: 'SelectInt',
      ),
      Param(
        'Letter Spacing',
        paramType: 'double',
        selectorClass: 'SelectInt',
      ),
      Param(
        'Word Spacing',
        paramType: 'double',
        selectorClass: 'SelectInt',
      ),
    ],
  );
  final textBuilder = ModelBuilder(
    name: 'Text',
    parameters: [
      Param(
        'Text',
        index: 0,
        paramType: 'String',
        selectorClass: 'SelectString',
      ),
      Param(
        'Style',
        paramType: 'TextStyle',
      ),
    ],
  );
  final containerBuilder = ModelBuilder(
    name: 'Container',
    parameters: [
      Param('Width', paramType: 'double', selectorClass: 'SelectInt'),
      Param('Height', paramType: 'double', selectorClass: 'SelectInt'),
    ],
  );
  print('''
import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart';

import '../component/models.dart';
import '../component/select.dart';
import '../component/box.dart';
		  ''');
  print(styleBuilder.generate());
}
