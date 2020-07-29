import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter_scene/flutter_scene.dart';

class TimeHandler extends Handler {
  @override
  Future compute() async {
    return DateTime.now().second.toDouble();
  }

  @override
  Duration get repeatingDuration => Duration(seconds: params[0]);
}

class GlobalHandler extends Handler {
  @override
  Future compute() async {
    final list = params[0].split('.');
    final prefix = list[0];
    final suffix = list[1];
    return FLUTTER_GLOBALS[prefix][suffix];
  }

  @override
  Duration get repeatingDuration => null;
}
