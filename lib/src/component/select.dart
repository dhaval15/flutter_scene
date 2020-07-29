import 'dart:ui';

import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:flutter/material.dart';

typedef OnSelectListener = Function(dynamic value);

typedef ValueConverter<To, From> = To Function(From value);

class SelectEnum extends StatelessWidget {
  final String label;
  final String value;
  final List<String> initialValues;
  final OnSelectListener listener;
  List<Widget> get actions => [];

  const SelectEnum({
    Key key,
    this.label,
    this.value,
    this.initialValues,
    this.listener,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 4),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                label,
                textWidthBasis: TextWidthBasis.parent,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white.withAlpha(10),
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                items: initialValues
                    .map((v) => DropdownMenuItem(
                          child: Text(v),
                          value: v,
                        ))
                    .toList(),
                style: TextStyle(fontSize: 13),
                onChanged: listener,
              ),
            ),
          ),
          ...actions,
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.edit,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}

class SelectString extends Select<String> {
  SelectString({
    Key key,
    OnSelectListener listener,
    dynamic value,
    String label,
  }) : super(
          listener: listener,
          key: key,
          label: label,
          value: value,
        );
}

class SelectNum extends Select<Lambda> {
  SelectNum({
    Key key,
    OnSelectListener listener,
    dynamic value,
    String label,
  }) : super(
          listener: listener,
          key: key,
          label: label,
          value: value,
          converter: (text) => Lambda.parse(text),
        );
}

class SelectInt extends Select<int> {
  SelectInt({
    Key key,
    OnSelectListener listener,
    dynamic value,
    String label,
  }) : super(
          listener: listener,
          key: key,
          label: label,
          value: value is double ? value.toInt() : value,
          converter: (text) => int.parse(text) ?? 0,
        );
}

class Select<V> extends StatefulWidget {
  final OnSelectListener listener;
  final String label;
  final value;
  final ValueConverter<V, String> converter;
  final ValueConverter<String, V> reverse;
  List<Widget> get actions => [];

  const Select(
      {Key key,
      this.listener,
      this.value,
      this.label,
      this.converter,
      this.reverse})
      : super(key: key);
  @override
  _SelectState createState() => _SelectState();
}

class _SelectState extends State<Select> {
  bool isLocked;

  @override
  void initState() {
    super.initState();
    isLocked = widget.value is Lambda;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8, right: 4),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              width: double.infinity,
              child: Text(
                widget.label,
                textWidthBasis: TextWidthBasis.parent,
                maxLines: 2,
                textAlign: TextAlign.start,
                style: TextStyle(fontSize: 13),
              ),
            ),
          ),
          Flexible(
            flex: 7,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              color: Colors.white.withAlpha(10),
              child: TextField(
                controller: TextEditingController(
                    text: widget.reverse?.call(widget.value) ??
                        widget.value.toString()),
                selectionHeightStyle: BoxHeightStyle.includeLineSpacingMiddle,
                style: TextStyle(fontSize: 13),
                cursorWidth: 1,
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
                onChanged: (text) {
                  widget.listener(widget.converter?.call(text) ?? text);
                },
              ),
            ),
          ),
          ...widget.actions,
          SizedBox(
            width: 8,
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.edit,
              size: 16,
            ),
          )
        ],
      ),
    );
  }
}

class LambdaEditorScreen extends StatefulWidget {
  final Lambda lambda;

  const LambdaEditorScreen({Key key, this.lambda}) : super(key: key);
  @override
  _LambdaEditorScreenState createState() => _LambdaEditorScreenState();
}

class _LambdaEditorScreenState extends State<LambdaEditorScreen> {
  TextEditingController _controller;
  Lambda lambda;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.lambda?.toString() ?? '');
    lambda = widget.lambda;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Lambda'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              try {
                lambda = Lambda.parse(_controller.text);
                Navigator.of(context).pop(lambda);
              } catch (e) {}
            },
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _controller,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1),
                      borderRadius: BorderRadius.circular(0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
