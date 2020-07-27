import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_scene/flutter_scene.dart';
import 'package:flurine_lambda/flurine_lambda.dart';

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

void main() async {
  Vein.init();
  Handler.register('tm', () => TimeHandler());
  Handler.register('globals', () => GlobalHandler());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextBox box;
  final StreamController<int> _controller = StreamController();
  Widget child;

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

  void load() async {
    final scene =
        await File('/home/dhaval/Projects/flutter_scene/scenes/text.scene')
            .readAsString();
    box = TextBox(Component.parse(scene));
    box.flow.listen(_controller.add);
    await box.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) => snapshot.hasData
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                          ),
                          child: box.value,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: box.editor,
                    ),
                  ],
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
