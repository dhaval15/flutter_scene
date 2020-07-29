import 'package:example/box_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_scene/flutter_scene.dart';
import 'package:flurine_lambda/flurine_lambda.dart';
import 'handlers.dart';

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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: BoxFutureWidget(
          file: '/home/dhaval/Projects/flutter_scene/scenes/text.scene',
          boxBuilder: (component) => TextBox(component),
          builder: (context, child, editor) => Column(
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
                    child: child,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: editor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
