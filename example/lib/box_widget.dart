import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scene/flutter_scene.dart';

class BoxWidget extends StatefulWidget {
  final MultiBox box;
  final Function(BuildContext context, Widget child, Widget editor) builder;
  const BoxWidget({Key key, @required this.box, @required this.builder})
      : super(key: key);

  @override
  _BoxWidgetState createState() => _BoxWidgetState();
}

class _BoxWidgetState extends State<BoxWidget> {
  final StreamController<int> _controller = StreamController();

  @override
  void initState() {
    super.initState();
    widget.box.flow.listen(_controller.add);
    widget.box.init();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _controller.stream,
      builder: (context, snapshot) => snapshot.hasData
          ? widget.builder(context, widget.box.value, widget.box.editor)
          : CircularProgressIndicator(),
    );
  }
}

class BoxFutureWidget extends StatefulWidget {
  final String file;
  final MultiBox Function(Component component) boxBuilder;
  final Function(BuildContext context, Widget child, Widget editor) builder;

  const BoxFutureWidget(
      {Key key,
      @required this.file,
      @required this.boxBuilder,
      @required this.builder})
      : super(key: key);
  @override
  _BoxFutureWidgetState createState() => _BoxFutureWidgetState();
}

class _BoxFutureWidgetState extends State<BoxFutureWidget> {
  @override
  void initState() {
    super.initState();
    load();
  }

  Future<Component> load() async {
    final scene = await File(widget.file).readAsString();
    return Component.parse(scene);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Component>(
      future: load(),
      builder: (context, snapshot) => snapshot.hasData
          ? BoxWidget(
              box: widget.boxBuilder(snapshot.data),
              builder: widget.builder,
            )
          : CircularProgressIndicator(),
    );
  }
}
