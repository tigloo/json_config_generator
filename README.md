A generator to create config class from json files that support many environments.

# Motivation

If you use a json file to config your applications, perphaps you need to write a dart class that contain all variables you define with their data types. When you need to manage nested objects is more complicated. Even if you want to add or delete a value in your json, you need to modify your dart class.

If you want to manage environments you need to writte manually the file path for every enviroment you need.

[json_config_generator] wants to help you to have an easy process with the manage of config files and environments.

# Install

To use [json_config_generator], you will need [build_runner]/code-generator setup.\
First, install [build_runner] and [json_config_generator] by adding them to your `pubspec.yaml` file:

> pubspec.yaml

```yaml
dependencies:
  json_config_annotation: ^0.1.0

dev_dependencies:
  build_runner:
  json_config_generator: ^0.1.0
```

- [build_runner], the tool to run code-generators
- [json_config_generator], the code generator
- [json_config_annotation], a package containing annotations for [json_config_generator]

# How to use

To use this generator need to create an empty config dart class that begins with `$` using the annotation `Configuration` defining the environments that you want to have. Each environment has `name` and `path`, if have more that one, the generator create an `Enum` to environments. Also you can specify the name of that `Enum`. By default it's name is `Environment`. Also, you need to add some imports.

> config.dart

```dart
import 'package:json_config_annotation/json_config_annotation.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

part 'config.g.dart'; //{dart file name}.g.dart

@Configuration(
  environmentEnumName: 'Env',
  environments:[
    Environment(name:'dev', path:'assets/config/dev.json'),
    Environment(name:'prd', path:'assets/config/prd.json'),
  ],
)
class $Config{}
```

suposing that have the next json file

> dev.json

```json
{
  "base_url": "https://example.com",
  "custom_class": {
    "value_1": "dfgdfgdfgwqrrqwrqwrqweqwe324523b252dghfdhd",
    "value_2": "6Lez7aIaAAAAAN6qZG2343c252bv66b7yn5m8m6"
  },
  "int_value": 3,
  "double_value": 3.5,
  "boolean_value": true,
  "string_list": ["hello", "world"],
  "int_list": [1, 23, 5],
  "bool_list": [false, true, true],
  "custom_list": [
    {
      "value_1": "hello"
    },
    {
      "value_1": "world"
    }
  ]
}
```

the generator creates

> config.g.dart

```dart
enum Env { dev, prd }

class Config {
  Config._();

  static final instance = Config._();

  late String baseUrl;

  late _CustomClass customClass;

  late int intValue;

  late double doubleValue;

  late bool booleanValue;

  late List<String> stringList;

  late List<int> intList;

  late List<bool> boolList;

  late List<_CustomList> customList;

  Future<void> init(Env env) async {
    String path = '';
    switch (env) {
      case Env.dev:
        path = 'assets/config/dev.json';
        break;
      case Env.prd:
        path = 'assets/config/prd.json';
        break;
    }
    final jsonString = await rootBundle.loadString(path);
    final config = json.decode(jsonString) as Map<String, dynamic>;
    baseUrl = config['base_url'] as String;
    customClass =
        _CustomClass.fromJson(config['custom_class'] as Map<String, dynamic>);
    intValue = config['int_value'] as int;
    doubleValue = config['double_value'] as double;
    booleanValue = config['boolean_value'] as bool;
    stringList = (config['string_list'] as List).cast<String>();
    intList = (config['int_list'] as List).cast<int>();
    boolList = (config['bool_list'] as List).cast<bool>();
    customList = _CustomList.listFromJson(config['custom_list'] as List);
  }
}

class _CustomClass {
  const _CustomClass({required this.value1, required this.value2});

  factory _CustomClass.fromJson(Map<String, dynamic> customClass) =>
      _CustomClass(
        value1: customClass['value_1'] as String,
        value2: customClass['value_2'] as String,
      );

  final String value1;

  final String value2;
}

class _CustomList {
  const _CustomList({required this.value1});

  factory _CustomList.fromJson(Map<String, dynamic> customList) => _CustomList(
        value1: customList['value_1'] as String,
      );

  final String value1;

  static List<_CustomList> listFromJson(List data) =>
      data.map((e) => _CustomList.fromJson(e as Map<String, dynamic>)).toList();
}
```

To use the generated configuration you need to call `init` method to initialize all values. Could be called in `main` defining the Environment that you want to use.

> main.dart

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Config.instance.init(Env.dev);
  runApp(const MyApp());
}
```

Now can access to fields easy using the `instance`

```dart
Config.instance.baseUrl;
Config.instance.customClass.value1;
```

# Supported data types

```dart
- String
- int
- double
- bool
- CustomClass
- List<String>
- List<int>
- List<double>
- List<bool>
- List<CustomClass>
```

Also can create nested classes!

**Important**

- Do not support nullable values
- Do not support dynamic values

# Run the generator

To run the generator use one of the next commands:

- `flutter pub run build_runner build`
- `dart pub run build_runner build`

## Considerations

Can also create a config with only one `Environment`. If that so, the `Enum` do not be created and when call `init` method, do not need to pass any argument.

It is important to known that the generator takes the first value in lists to known the type of the list, so be caferull

[json_config_generator]: https://pub.dev/packages/json_config_generator
[json_config_annotation]: https://pub.dev/packages/json_config_annotation
[build_runner]: https://pub.dev/packages/build_runner
