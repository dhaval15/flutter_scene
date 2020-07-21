import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';

class ModelBuilder {
  final String name;
  final List<Param> parameters;
  final String layout = 'Layout';

  ModelBuilder({this.name, this.parameters});

  String generate() {
    final builder = ClassBuilder();
    builder.name = '${name}Box';
    builder.extend = refer('MultiBox<$name>');
    builder.constructors.addAll(constructors);
    builder.methods.addAll(methods);
    builder.fields.addAll(fields);
    final emitter = DartEmitter();
    return DartFormatter().format('${builder.build().accept(emitter)}');
  }

  List<Constructor> get constructors => [defaultConstructor];

  Constructor get defaultConstructor => (ConstructorBuilder()
        ..requiredParameters.addAll([
          (ParameterBuilder()
                ..name = 'component'
                ..type = refer('Component'))
              .build(),
        ])
        ..initializers
            .add(Code('${parameters.map((p) => p.assignment).join(',')}')))
      .build();

  List<Method> get methods => [editor, render, fieldsGetter];

  String get buildMethodPassedParameters =>
      parameters.map((p) => 'model.${p.name}.convertedValue').join(',');

  Method get render => (MethodBuilder()
        ..name = 'value'
        ..lambda = true
        ..annotations.add(CodeExpression(Code('override')))
        ..body =
            Code('$name(${parameters.map((p) => p.paramInRender).join(',')},)')
        ..returns = refer(name)
        ..type = MethodType.getter)
      .build();

  Method get editor {
    final buffer = StringBuffer();
    buffer.write('$layout( children : [ ');
    buffer.write(parameters.map((p) => p.selector).join(''));
    buffer.write('],)');
    return (MethodBuilder()
          ..name = 'editor'
          ..type = MethodType.getter
          ..lambda = true
          ..annotations.add(CodeExpression(Code('override')))
          ..returns = refer('Widget')
          ..body = Code('$buffer'))
        .build();
  }

  Method get fieldsGetter => (MethodBuilder()
        ..name = 'fields'
        ..type = MethodType.getter
        ..lambda = true
        ..annotations.add(CodeExpression(Code('override')))
        ..returns = refer('List<Box>')
        ..body = Code('[${parameters.map((p) => p.name).join(',')}]'))
      .build();

  List<Field> get fields => parameters.map((p) => p.field).toList();
}

class Param {
  final String label;
  String name;
  final String paramType;
  final int index;
  final String selectorClass;
  Param(
    this.label, {
    this.index,
    this.name,
    this.paramType,
    this.selectorClass,
  }) {
    if (name == null) {
      final buffer = StringBuffer();
      buffer.write(label[0].toLowerCase());
      buffer.write(label.substring(1).replaceAll(' ', ''));
      name = buffer.toString();
    }
  }

  Field get field => (FieldBuilder()
        ..name = name
        ..modifier = FieldModifier.final$
        ..type = refer('$boxType'))
      .build();

  String get boxType =>
      paramType[0].toUpperCase() + paramType.substring(1) + 'Box';

  String get assignment =>
      "$name = $boxType(component[\'${index == null ? name : '#$index'}\'])";

  String get selector => selectorClass != null
      ? '''
		  	$selectorClass(
					label:'$label',
					value: $name.value,
					listener:(value) {
						if(value is Lambda)
							$name.lambda = value;
						else 
						   $name.value = value;
					},
					$additionalParam
			),
		  '''
      : '''
				  $name.editor,
				  ''';

  String get paramInRender =>
      index == null ? '$name:$name.value' : '$name.value';

  String get additionalParam => '';
}
