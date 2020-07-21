import 'package:flurine_lambda/flurine_lambda.dart';
import 'package:petitparser/petitparser.dart';
import 'component_definition.dart';
import '../component/models.dart';

class ComponentParser extends GrammarParser {
  ComponentParser() : super(ComponentParserDefinition());
}

class ComponentParserDefinition extends ComponentGrammarDefinition {
  @override
  Parser component() => super.component().map((value) {
        String name = value[1];
        List params = value[3];
        if (name.startsWith('Lambda')) {
          final s =
              '\$${name.replaceAll('Lambda', '')}\(${params.map((v) => v.value).join(',')}\)\$';
          print(s);
          return Lambda.parse(s);
        }
        return Component(name, params);
      });

  @override
  Parser componentBody() => super.componentBody().map((value) => value[2]);

  @override
  Parser componentParameters() => super.componentParameters().map((v) {
        final value = v[0];
        List<MapEntry<String, dynamic>> entries = [];
        for (int i = 0; i < value.length; i++) {
          MapEntry<String, dynamic> entry = value[i];
          entries.add(MapEntry(entry.key ?? '#$i', entry.value));
        }
        return entries;
      });

  @override
  Parser paramName() => super.paramName().map((value) => value[0]);

  @override
  Parser componentParam() => super
      .componentParam()
      .map((value) => MapEntry<String, dynamic>(value[0], value[2]));

  @override
  Parser variableName() => super
      .variableName()
      .map((value) => [value[0], value[1].join('')].join(''));

  @override
  Parser variable() => super.variable().map((value) => Lambda.fromParsedString(
      'globals', [Lambda.value(value[0] + (value[1]?.join('') ?? ''))]));

  @override
  Parser listToken() => super.listToken().map((value) => value[1]);

  @override
  Parser colorToken() => super.colorToken().map((v) {
        String value = v;
        final buffer = StringBuffer();
        buffer.write('0x');
        buffer.write(value.substring(7, 9));
        buffer.write(value.substring(1, 7));
        print(buffer.toString());
        return ColorElement(int.parse(buffer.toString()));
      });

  //@override
  //Parser varToken() => super.varToken().map((value) => VarElement(value[1]));

  @override
  Parser coreToken() => super.coreToken().map((value) => CoreElement(value[1]));

  @override
  Parser stringToken() =>
      super.stringToken().map((value) => value.substring(1, value.length - 1));

  @override
  Parser numberToken() => super.numberToken().map((value) => toNum(value));

  @override
  Parser lambdaToken() => super.lambdaToken().map((value) {
        print(value);
        return value;
      });
}

dynamic toNum(String s) {
  final doubleValue = double.parse(s);
  final intValue = doubleValue.toInt();
  if (intValue - doubleValue == 0) {
    return intValue;
  } else {
    return doubleValue;
  }
}
