import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart' hide Flow;

abstract class Box<T> {
  final Flow flow = Flow();
  Future init();
  T get value;
}

class CoreBox<T> extends Box<T> {
  final Lambda _lambda;
  CoreBox(dynamic lambda)
      : this._lambda = lambda is Lambda ? lambda : Lambda.value(lambda) {
    if (!(lambda is Lambda)) value = lambda;
  }

  T boxedValue;
  T get value => boxedValue;

  set value(dynamic value) {
    boxedValue = value;
    flow.add(0);
  }

  @override
  Future init() async {
    await _lambda.execute();
    _lambda.vein.listen((value) {
      this.value = value;
    });
  }

  Lambda get lambda => _lambda;

  set lambda(Lambda lambda) {
    if (lambda != null) this._lambda.update(lambda);
  }
}

class IntBox extends CoreBox<int> {
  IntBox(lambda) : super(lambda);
  @override
  set value(value) {
    if (value is double)
      super.value = value.toInt();
    else if (value is int)
      super.value = value;
    else
      throw 'Not double or int';
  }
}

class DoubleBox extends CoreBox<double> {
  DoubleBox(lambda) : super(lambda);
  @override
  set value(value) {
    if (value is double)
      super.value = value;
    else if (value is int)
      super.value = value.toDouble();
    else
      throw 'Not double or int';
  }
}

class StringBox extends CoreBox<String> {
  StringBox(lambda) : super(lambda);
  set value(value) {
    if (value is String)
      super.value = value;
    else
      super.value = value.toString();
  }
}

abstract class MultiBox<T> extends Box<T> with EditorMixin {
  Future<Flow> combined() async {
    for (final field in fields) {
      await field.init();
    }
    return Flow.combine(fields.map((field) => field.flow).toList());
  }

  List<Box> get fields;

  @override
  Future init() async {
    final flow = await combined();
    flow.listen((_) {
      update();
    });
  }

  void update() {
    flow.add(0);
  }
}

mixin EditorMixin {
  Widget get editor;
  Widget get gap => SizedBox(height: 8);
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
