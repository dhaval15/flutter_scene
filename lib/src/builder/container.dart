import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart';

import '../component/models.dart';
import '../component/select.dart';
import '../component/box.dart';

class ContainerBox extends MultiBox<Container> {
  ContainerBox(Component component)
      : width = DoubleBox(component['width']),
        height = DoubleBox(component['height']);

  final DoubleBox width;

  final DoubleBox height;

  @override
  Widget get editor => Layout(
        children: [
          SelectInt(
            label: 'Width',
            value: width.value,
            listener: (value) {
              if (value is Lambda)
                width.lambda = value;
              else
                width.value = value;
            },
          ),
          SelectInt(
            label: 'Height',
            value: height.value,
            listener: (value) {
              if (value is Lambda)
                height.lambda = value;
              else
                height.value = value;
            },
          ),
        ],
      );
  @override
  Container get value => Container(
        width: width.value,
        height: height.value,
      );
  @override
  List<Box> get fields => [width, height];
}
