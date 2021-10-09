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
